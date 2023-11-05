//
//  TCPClient.swift
//  Client
//
//  Created by Adam Tokarski on 05/11/2023.
//

import Foundation
import Network

class TCPClient {
	enum ConnectionError: Error {
		case invalidIPAddress
		case invalidPort
	}
	
	private lazy var queue = DispatchQueue.init(label: "tcp.client.queue")
//	private lazy var queue2 = DispatchQueue(label: "tcp.client.queue")  // is there any difference?
	
	private var connection: NWConnection?
	
	private var state: NWConnection.State = .preparing
	
	func connect(to ipAddress: String, with port: UInt16) throws {
		guard let ipAddress = IPv4Address(ipAddress) else { throw ConnectionError.invalidIPAddress }
		
		guard let port = NWEndpoint.Port.init(rawValue: port) else { throw ConnectionError.invalidPort }
		
		let host = NWEndpoint.Host.ipv4(ipAddress)
		
		connection = NWConnection(host: host, port: port, using: .tcp)
		
		connection?.stateUpdateHandler = { [unowned self] state in
			self.state = state
		}
		
		connection?.start(queue: queue)
	}
	
	func send(data: Data) {
		guard state == .ready else { return }
		
		connection?.send(content: data, completion: .contentProcessed({ error in
			if let error = error {
				print(error.localizedDescription)
			}
		}))
	}
}
