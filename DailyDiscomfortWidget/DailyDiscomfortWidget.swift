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
        SimpleEntry(quote: "Loading...")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let quote = await HormoziQuoteService.getDailyQuote()
            completion(SimpleEntry(quote: quote))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task {
            let quote = await HormoziQuoteService.getDailyQuote()
            let entry = SimpleEntry(quote: quote)

            // Refresh at midnight tomorrow
            let nextMidnight = Calendar.current.startOfDay(
                for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            )
            let timeline = Timeline(entries: [entry], policy: .after(nextMidnight))
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date = Date()
    let quote: String
}

struct DailyDiscomfortWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
          Text(entry.quote)
            .bold()
            .font(.custom("Poppins-Bold", size: 10))
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
    SimpleEntry(quote: "Do the boring work that no one else is willing to do.")
}
