//
//  H264Encoder.swift
//  Client
//
//  Created by Adam Tokarski on 04/11/2023.
//

import AVFoundation
import VideoToolbox

class H264Encoder: NSObject {
	enum ConfigurationError: Error {
		case cannotCreateSession
		case CannotSetProperties
		case cannotPrepareToEncode
	}
	
	private var _session: VTCompressionSession!
	
	private static let naluStartCode = Data([UInt8](arrayLiteral: 0x00, 0x00, 0x00, 0x01))
	var naluHandling: ((Data) -> Void)?
	
	private var encodingOutputCallback: VTCompressionOutputCallback {
		// TODO: implement
	}
	
	override init() {
		super.init()
	}
	
	private func encode(buffer: CMSampleBuffer) {
		// TODO: implement
	}
	
	func configureCompressSession() throws {
		let error = VTCompressionSessionCreate(allocator: kCFAllocatorDefault,
											   width: Int32(720),
											   height: Int32(1280),
											   codecType: kCMVideoCodecType_H264,
											   encoderSpecification: nil,
											   imageBufferAttributes: nil,
											   compressedDataAllocator: kCFAllocatorDefault,
											   outputCallback: encodingOutputCallback,
											   refcon: Unmanaged.passUnretained(self).toOpaque(),
											   compressionSessionOut: &_session)
		
		guard error == errSecSuccess, let session = _session else {
			throw ConfigurationError.cannotCreateSession
		}
		
		let propertyDictionary = [
			kVTCompressionPropertyKey_ProfileLevel: kVTProfileLevel_H264_Baseline_AutoLevel,
			kVTCompressionPropertyKey_MaxKeyFrameInterval: 60,
			kVTCompressionPropertyKey_RealTime: true,
			kVTCompressionPropertyKey_Quality: 0.5
		] as CFDictionary
		
		guard VTSessionSetProperties(session, propertyDictionary: propertyDictionary) == noErr else {
			throw ConfigurationError.CannotSetProperties
		}
		
		guard VTCompressionSessionPrepareToEncodeFrames(session) == noErr else {
			throw ConfigurationError.cannotPrepareToEncode
		}
		
		print("VTCompressionSession is ready to use!")
	}
}

extension H264Encoder: AVCaptureVideoDataOutputSampleBufferDelegate {
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		encode(buffer: sampleBuffer)
	}
}
