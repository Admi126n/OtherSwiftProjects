//
//  Todo.swift
//  Todo
//
//  Created by Adam Tokarski on 31/10/2023.
//

import Foundation
import SwiftData

@Model
class Todo: Identifiable {
	let id = UUID()
	var name: String
	
	init(name: String = "") {
		self.name = name
	}
}
