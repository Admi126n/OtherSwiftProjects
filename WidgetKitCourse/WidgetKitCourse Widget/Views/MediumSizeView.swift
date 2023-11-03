//
//  MediumSizeView.swift
//  WidgetKitCourse WidgetExtension
//
//  Created by Adam Tokarski on 24/10/2023.
//

import SwiftUI
import WidgetKit

struct MediumSizeView: View {
	var entry: SimpleEntry
	
    var body: some View {
		GroupBox {
			HStack {
				Image(systemName: "person")
					.resizable()
					.scaledToFit()
					.foregroundStyle(.secondary)
				
				Divider()
				
				if let todo = entry.todos.first {
					VStack(alignment: .leading) {
						Text(todo.title)
							.font(.headline)
						
						Text(todo.completed ? "Compleated" : "Open")
							.font(.subheadline)
					}
				}
				
				Spacer()
			}
			.padding()
		} label: {
			Label("My todos", systemImage: "list.dash")
		}
		.widgetURL(URL(string: "myapp://todo/\(entry.todos.first?.id ?? 0)"))
    }
}
