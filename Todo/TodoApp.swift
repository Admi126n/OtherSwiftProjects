//
//  TodoApp.swift
//  Todo
//
//  Created by Adam Tokarski on 31/10/2023.
//

import SwiftData
import SwiftUI

@main
struct TodoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(for: Todo.self)
    }
}
