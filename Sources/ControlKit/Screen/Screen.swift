//
//  Screen.swift
//  
//
//  Created by Vaida on 6/15/24.
//

import CoreGraphics
import Foundation
import AVFoundation
import Synchronization


/// Different to `ScreenCaptureKit`, The methods works well in executables without identities.
public struct Screen {
    
    /// Captures the current screen.
    ///
    /// - Parameters:
    ///   - display: The display to capture. The default value is the display on screen.
    ///   - target: The rect of interest
    ///
    /// - Experiment: On a benchmark with `-O`, it takes 50ms on average to capture. That is around 200 frames per second. It took around 8% of the CPU to capture non-stop.
    ///
    /// To obtain a list of displays, use ``displays(of:maxDisplays:)``.
    @inlinable
    public static func capture(_ display: Display = .main, target: CGRect? = nil) -> CGImage? {
        if let target,
           let imageRef = CGDisplayCreateImage(display.id, rect: target) {
            return imageRef
        } else if let imageRef = CGDisplayCreateImage(display.id) {
            return imageRef
        }
        
        return nil
    }
    
    /// The list of displays of the given kind.
    ///
    /// - Parameters:
    ///   - kind: The display kind.
    ///   - maxDisplays: This value determines the maximum number of display IDs that can be returned.
    public static func displays(
        of kind: DisplayKind = .active,
        maxDisplays: Int = 10
    ) throws(CGError) -> [Display] {
        let displays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: maxDisplays)
        defer {
            displays.deallocate()
        }
        var displayCount: UInt32 = 0
        let error: CGError
        
        if kind == .online {
            error = CGGetOnlineDisplayList(UInt32(maxDisplays), displays, &displayCount)
        } else {
            assert(kind == .active)
            error = CGGetActiveDisplayList(UInt32(maxDisplays), displays, &displayCount)
        }
        
        guard error == .success else { throw error }
        guard displayCount != 0 else { return [] }
        
        var array: [Display] = []
        let _displayCount = Int(displayCount)
        array.reserveCapacity(_displayCount)
        for i in 0..<_displayCount {
            array.append(Display(displayID: displays[i]))
        }
        return array
    }
    
    
    /// Returns all windows satisfying `options`.
    ///
    /// - Parameters:
    ///   - options: The options describing which window dictionaries to return. Typical options let you return dictionaries for all windows or for windows above or below the window specified in the relativeToWindow parameter.
    ///
    /// Generating the system windows is a relatively expensive operation. As always, you should profile your code and adjust your usage of this function appropriately for your needs.
    public static func windows(options: CGWindowListOption = [.excludeDesktopElements, .optionOnScreenOnly]) throws -> [Window] {
        let windowListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as NSArray?
        
        // Check if we got the window list
        guard let windowList = windowListInfo as? [[CFString: Any]] else {
            throw ObtainWindowsError.noWindowList
        }
        
        return windowList.map(Window.init)
    }
    
    /// Captures the image of a window.
    ///
    /// - Parameters:
    ///   - window: Specify a particular window for capturing.
    ///   - listOption: Specifies the scope of windows to include in the image.
    ///   - imageOption: Specifies the image rendering options. See discussion for more.
    ///
    /// For `imageOption`, you could pass:
    /// - `boundsIgnoreFraming` for ignoring the shadow.
    ///
    /// - Note: A window obtained ``windows(options:)`` does not guarantee such window is capture-able.
    public static func capture(
        _ window: Window,
        listOption: CGWindowListOption = .optionIncludingWindow,
        imageOption: CGWindowImageOption = []
    ) -> CGImage? {
        CGWindowListCreateImage(.null, listOption, window.id, imageOption)
    }
    
    /// Captures the current screen.
    ///
    /// - Parameters:
    ///   - display: The display to capture. The default value is the display on screen.
    ///   - target: The rect of interest
    ///   - destination: The location to store the video. You need to ensure this function can write to this location, and there doesn't exit a file there.
    ///   - codec: The codec for the video.
    ///
    /// To obtain a list of displays, use ``displays(of:maxDisplays:)``.
    public static func record(_ display: Display = .main, target: CGRect? = nil, to destination: URL, codec: AVVideoCodecType = .hevc) throws -> VideoWriter {
        let firstFrame = capture(display, target: target)!
        return try VideoWriter(produce: { capture(display, target: target) }, size: firstFrame.size, to: destination)
    }
    
    /// Captures the image of a window.
    ///
    /// - Parameters:
    ///   - window: Specify a particular window for capturing.
    ///   - listOption: Specifies the scope of windows to include in the image.
    ///   - imageOption: Specifies the image rendering options. See discussion for more.
    ///   - destination: The location to store the video. You need to ensure this function can write to this location, and there doesn't exit a file there.
    ///   - codec: The codec for the video. When the codec is ProRess4444, alpha channel is preserved.
    ///
    /// For `imageOption`, you could pass:
    /// - `boundsIgnoreFraming` for ignoring the shadow.
    ///
    /// - Note: A window obtained ``windows(options:)`` does not guarantee such window is capture-able.
    ///
    /// ### Record a window
    ///
    /// With the ``record(_:listOption:imageOption:to:codec:)``, you could record a window, something that macOS screen recording cannot do.
    ///
    /// For example, This would record the *finder* window that currently opens *computer*
    ///
    /// ```swift
    /// // locate the window
    /// let window = try Screen.windows().filter({ $0.owner.name.contains("Finder") && $0.name == "Vaida's MacBook Pro" }).first!
    ///
    /// // start the record session. This method returns immediately after the record session is started
    /// let recorder = try Screen.record(window, to: .desktopDirectory.appending(path: "file (alpha).mov"), codec: .proRes4444)
    ///
    /// // the duration to record
    /// try await Task.sleep(for: .seconds(1))
    ///
    /// // tell the recorder to stop recording. This method will wait until the file is written.
    /// try await recorder.finish()
    /// ```
    ///
    /// With the `proRes4444` codec, the alpha component is preserved.
    ///
    /// - Experiment: The recorded video is around `66.89 fps`. As the capture and render happens in sync.
    public static func record(
        _ window: Window,
        listOption: CGWindowListOption = .optionIncludingWindow,
        imageOption: CGWindowImageOption = [],
        to destination: URL,
        codec: AVVideoCodecType = .hevcWithAlpha
    ) throws -> VideoWriter {
        let firstFrame = capture(window, listOption: listOption, imageOption: imageOption)!
        return try VideoWriter(produce: { capture(window, listOption: listOption, imageOption: imageOption) }, size: firstFrame.size, to: destination, codec: codec)
    }
    
    
    public final class VideoWriter: @unchecked Sendable {
        
        let assetWriter: AVAssetWriter
        
        let assetWriterVideoInput: AVAssetWriterInput
        
        nonisolated(unsafe)
        var isFinished = false
        
        let mediaQueue = DispatchQueue(label: "package.ControlKit.VideoWriter.mediaQueue")
        
        // Must use GCD instead of swift concurrency.
        let preparePixelQueue = DispatchQueue(label: "package.ControlKit.VideoWriter.preparePixelQueue")
        
        /// Transparency is only recorded when codec is `ProRess4444`.
        init(produce: @escaping () -> CGImage?, size: CGSize, to url: URL, colorSpace: CGColorSpace? = nil, container: AVFileType = .mov, codec: AVVideoCodecType = .hevc) throws {
            let videoWidth  = size.width
            let videoHeight = size.height
            
            self.assetWriter = try AVAssetWriter(outputURL: url, fileType: container)
            
            // Define settings for video input
            let videoSettings: [String : AnyObject] = [
                AVVideoCodecKey : codec       as AnyObject,
                AVVideoWidthKey : videoWidth  as AnyObject,
                AVVideoHeightKey: videoHeight as AnyObject
            ]
            
            // Add video input to writer
            self.assetWriterVideoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoSettings)
            assetWriter.add(assetWriterVideoInput)
            
            // If here, AVAssetWriter exists so create AVAssetWriterInputPixelBufferAdaptor
            let sourceBufferAttributes : [String : AnyObject] = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA as AnyObject,
                kCVPixelBufferWidthKey           as String: videoWidth                as AnyObject,
                kCVPixelBufferHeightKey          as String: videoHeight               as AnyObject
            ]
            nonisolated(unsafe)
            let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterVideoInput, sourcePixelBufferAttributes: sourceBufferAttributes)
            
            // Start writing session
            assetWriter.startWriting()
            
            assetWriter.startSession(atSourceTime: CMTime.zero)
            guard pixelBufferAdaptor.pixelBufferPool != nil else { throw ConvertImagesToVideoError.pixelBufferPoolNil }
            
            // -- Set video parameters
            let date = Date()
            
            // -- Add images to video
            let drawCGRect = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)
            let defaultColorSpace = CGColorSpaceCreateDeviceRGB()
            
            nonisolated(unsafe)
            let produce = produce
            
            assetWriterVideoInput.requestMediaDataWhenReady(on: mediaQueue) { [unowned self] in
                guard assetWriterVideoInput.isReadyForMoreMediaData else { return } // go on waiting
                guard !isFinished else {
                    assetWriterVideoInput.markAsFinished()
                    return
                }
                
                // prepare buffer
                nonisolated(unsafe)
                let pixelBufferPointer = UnsafeMutablePointer<CVPixelBuffer?>.allocate(capacity: 1)
                
                nonisolated(unsafe)
                var pixelBuffer: CVPixelBuffer! = nil
                
                nonisolated(unsafe)
                var context: CGContext! = nil
                
                preparePixelQueue.async {
                    let pixelBufferPool = pixelBufferAdaptor.pixelBufferPool!
                    
                    CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, pixelBufferPointer)
                    pixelBuffer = pixelBufferPointer.pointee!
                    
                    CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
                    
                    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
                    
                    // Create CGBitmapContext
                    context = CGContext(data: pixelData, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: colorSpace ?? defaultColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)!
                }
                
                // Produce
                var _frame = produce()
                while _frame == nil {
                    _frame = produce()
                }
                let frame = _frame!

                // Draw image into context
                let presentationTime = CMTime(seconds: date.distance(to: Date()), preferredTimescale: 120)
                
                preparePixelQueue.sync { } // wait for the queue
                
                context.draw(frame, in: drawCGRect) // takes most time
                CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
                
                pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                pixelBufferPointer.deallocate()
            }
        }
        
        /// Finish the reading and writing stream, and wait for completes.
        public func finish() async throws {
            isFinished = true
            mediaQueue.sync { }
            await assetWriter.finishWriting()
            
            guard assetWriter.error == nil else { throw assetWriter.error! }
        }
        
        private enum ConvertImagesToVideoError: LocalizedError, CustomStringConvertible {
            
            case pixelBufferPoolNil
            
            case cannotCreateCGContext
            
            
            var description: String {
                "\(errorDescription!): \(failureReason!)"
            }
            
            
            var errorDescription: String? { "Convert images to video error" }
            
            var failureReason: String? {
                switch self {
                case .pixelBufferPoolNil:
                    return "Pixel buffer pool is nil after starting writing session, this typically means you do not have permission to write to the given file"
                case .cannotCreateCGContext:
                    return "Cannot create CGContext for a frame"
                }
            }
            
        }
        
    }
    
    
    public enum DisplayKind: Sendable {
        
        /// Displays that are online (active, mirrored, or sleeping)
        case online
        
        /// Displays that are active for drawing
        case active
    }
    
    
    public enum ObtainWindowsError: Error {
        case noWindowList
    }
    
}


extension CGError: @retroactive Error {
    
}
