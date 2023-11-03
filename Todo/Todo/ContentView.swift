//
//  ContentView.swift
//  Todo
//
//  Created by Adam Tokarski on 31/10/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) var modelContext
	@Query var todos: [Todo]
	@State private var showSheet = false
	
    var body: some View {
		NavigationStack {
			VStack {
				List {
					ForEach(todos) { todo in
						NavigationLink {
							Text(todo.name)
						} label: {
							HStack {
								Image(systemName: "checkmark")
									.foregroundStyle(Color.green)
								
								Text(todo.name)
							}
						}
					}
					.onDelete(perform: deleteTodo)
				}
			}
			.toolbar {
				Button {
					showSheet = true
				} label: {
					Image(systemName: "plus")
				}
			}
			.navigationTitle("Todo")
			.sheet(isPresented: $showSheet) {
				AddView()
			}
		}
    }
	
	private func deleteTodo(_ indexSet: IndexSet) {
		for index in indexSet {
			let todo = todos[index]
			modelContext.delete(todo)
		}
	}
	
}

#Preview {
    ContentView()
}
