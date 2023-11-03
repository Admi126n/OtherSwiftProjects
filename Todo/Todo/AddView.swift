//
//  AddView.swift
//  Todo
//
//  Created by Adam Tokarski on 31/10/2023.
//

import SwiftUI

struct AddView: View {
	@Environment(\.modelContext) var modelContext
	@Environment(\.dismiss) var dismiss
	@State private var todoName = ""
	
    var body: some View {
		NavigationStack {
			Form {
				TextField("Todo name", text: $todoName)
			}
			.navigationTitle("Add todo")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Add") {
						if !todoName.isEmpty {
							let newTodo = Todo(name: todoName)
							modelContext.insert(newTodo)
							dismiss()
						}
					}
				}
				
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismiss()
					}
				}
			}
		}
    }
}

#Preview {
    AddView()
}
