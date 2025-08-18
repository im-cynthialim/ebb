//
//  DailyDiscomfortWidget.swift
//  DailyDiscomfortWidget
//
//  Created by Cynthia Lim on 2025-08-16.
//

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let timeline = Timeline(entries: [SimpleEntry()], policy: .never) // No time-based updates
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
  let date = Date() // Required by WidgetKit; unused in logic
}

struct DailyDiscomfortWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme
  
    var body: some View {
        VStack {
          Text(getDailyQuestion())
            .bold()
            .font(.custom("Poppins-Bold", size: 15))
            .containerBackground(colorScheme == .dark ? Color.darkMode : Color.lightMode, for: .widget)
            .multilineTextAlignment(.center)
        }
    }
}

struct DailyDiscomfortWidget: Widget {
    let kind: String = "Daily Discomfort"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyDiscomfortWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Discomfort")
        .description("Asks an uncomfortable question daily")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    DailyDiscomfortWidget()
}
timeline: {
  SimpleEntry()
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
}
