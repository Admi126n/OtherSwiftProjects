//
//  VideoClient.swift
//  Client
//
//  Created by Adam Tokarski on 05/11/2023.
//

import AVFoundation

class VideoClient {
	private lazy var captureManager = VideoCaptureManager()
	private lazy var videoEncoder = H264Encoder()
	private lazy var tcpClient = TCPClient()
	
	func connect(to ipAddress: String, with port: UInt16) throws {
		try tcpClient.connect(to: ipAddress, with: port)
	}
	
	func startSendingVideoToServer() throws {
		try videoEncoder.configureCompressSession()
		
		captureManager.setVideoOutputDelegate(with: videoEncoder)
		
		videoEncoder.naluHandling = { [unowned self] data in
			tcpClient.send(data: data)
		}
	}
}
