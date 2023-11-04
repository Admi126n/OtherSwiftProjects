//
//  VideoCaptureManager.swift
//  Client
//
//  Created by Adam Tokarski on 04/11/2023.
//

import AVFoundation

fileprivate enum SessionSetupResult {
	case success
	case notAuthorized
	case configurationFailed
}

fileprivate enum ConfigurationError: Error {
	case cannotAddInput
	case cannotAddOutput
	case defaultDeviceNotExist
}

class VideoCaptureManager {
	private let session = AVCaptureSession()
	private let videoOutput = AVCaptureVideoDataOutput()
	
	private let sessionQueue = DispatchQueue(label: "session.queue")
	private let videoOutputQueue = DispatchQueue(label: "video.output.queue")
	
	private var setupResult: SessionSetupResult = .success
	
	init() {
		sessionQueue.async {
			self.requestCameraAuthIfNeeded()
		}
		
		sessionQueue.async {
			self.configureSession()
		}
		
		sessionQueue.async {
			self.startSessionIfPossible()
		}
	}
	
	private func requestCameraAuthIfNeeded() {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized:
			return
		case .notDetermined:
			sessionQueue.suspend()
			AVCaptureDevice.requestAccess(for: .video) { granted in
				if !granted {
					self.setupResult = .notAuthorized
				}
				
				self.sessionQueue.resume()
			}
		default:
			setupResult = .notAuthorized
		}
	}
	
	private func addVideoDeviceInputToSession() throws {
		do {
			var defaultVideoDevice: AVCaptureDevice?
			
			if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
				defaultVideoDevice = dualCameraDevice
			} else if let dualWideCameraDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) {
				defaultVideoDevice = dualWideCameraDevice
			} else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
				defaultVideoDevice = backCameraDevice
			} else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
				defaultVideoDevice = frontCameraDevice
			}
			
			guard let videoDevice = defaultVideoDevice else {
				print("Default device is unavilable")
				setupResult = .configurationFailed
				session.commitConfiguration()
				
				throw ConfigurationError.defaultDeviceNotExist
			}
			
			let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
			
			if session.canAddInput(videoDeviceInput) {
				session.addInput(videoDeviceInput)
			} else {
				setupResult = .configurationFailed
				session.commitConfiguration()
				
				throw ConfigurationError.cannotAddInput
			}
			
		} catch {
			setupResult = .configurationFailed
			session.commitConfiguration()
			
			throw error
		}
	}
	
	private func addVideoOutputToSession() throws {
		if session.canAddOutput(videoOutput) {
			session.addOutput(videoOutput)
		} else {
			setupResult = .configurationFailed
			session.commitConfiguration()
			
			throw ConfigurationError.cannotAddOutput
		}
	}
	
	private func configureSession() {
		guard setupResult == .success else { return }
		
		session.beginConfiguration()
		
		if session.canSetSessionPreset(.iFrame1280x720) {
			session.sessionPreset = .iFrame1280x720
		}
		
		do {
			try addVideoDeviceInputToSession()
			try addVideoOutputToSession()
			
			if let connection = session.connections.first {
//				connection.videoOrientation = .portrait
				connection.videoRotationAngle = 90
			}
		} catch {
			print("An error occured: \(error.localizedDescription)")
			return
		}
		
		session.commitConfiguration()
	}
	
	private func startSessionIfPossible() {
		switch setupResult {
		case .success:
			session.startRunning()
		case .notAuthorized:
			print("Camera usage not authorized")
		case .configurationFailed:
			print("Configuration failed")
		}
	}
	
	func setVideoOutputDelegate(with delegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
		videoOutput.setSampleBufferDelegate(delegate, queue: videoOutputQueue)
	}
}
