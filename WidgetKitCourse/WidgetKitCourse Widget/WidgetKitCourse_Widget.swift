//
//  WidgetKitCourse_Widget.swift
//  WidgetKitCourse Widget
//
//  Created by Adam Tokarski on 24/10/2023.
//

import WidgetKit
import SwiftUI

// MARK: - Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), todos: [.placeholder(0), .placeholder(1)])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		Task {
			do {
				let allTodos = try await TodoService.shared.getAllTodos()
				let fiveTodos = Array(allTodos.prefix(5))
				let entry = SimpleEntry(date: .now, todos: fiveTodos)
				
				completion(entry)
			} catch {
				completion(SimpleEntry(date: .now, todos: [.placeholder(0)]))
			}
		}
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		Task {
			do {
				let allTodos = try await TodoService.shared.getAllTodos()
				let fiveTodos = Array(allTodos.prefix(5))
				let entry = SimpleEntry(date: .now, todos: fiveTodos)
				
				let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 60 * 60 * 30)))
				
				completion(timeline)
			} catch {
				let entry = SimpleEntry(date: .now, todos: [.placeholder(0)])
				let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 60 * 60 * 30)))
				
				completion(timeline)
			}
		}
    }
}

// MARK: - SimpleEntry

struct SimpleEntry: TimelineEntry {
    let date: Date
	let todos: [Todo]
}

// MARK: - VidgetView

struct WidgetView: View {
	@Environment(\.widgetFamily) var widgetFamily
	
    var entry: Provider.Entry

    var body: some View {
		switch widgetFamily {
		case .systemMedium:
			MediumSizeView(entry: entry)
		case .systemLarge:
			LargeSizeView(entry: entry)
		default:
			Text("Not implememnted")
		}
    }
}

struct WidgetKitCourse_Widget: Widget {
    let kind: String = "WidgetKitCourse_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
		.supportedFamilies([.systemMedium, .systemLarge])
        .configurationDisplayName("My Todos")
        .description("View yout latest todos.")
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    WidgetKitCourse_Widget()
} timeline: {
	SimpleEntry(date: .now, todos: [.placeholder(0)])
}
