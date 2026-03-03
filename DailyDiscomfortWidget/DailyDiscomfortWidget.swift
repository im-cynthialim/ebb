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
        SimpleEntry(quote: "Loading...", author: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let tweet = await QuoteService.getDailyQuote()
            completion(SimpleEntry(quote: tweet.text, author: tweet.author))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task {
            let tweet = await QuoteService.getDailyQuote()
            let entry = SimpleEntry(quote: tweet.text, author: tweet.author)

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
    let author: String
}

struct DailyDiscomfortWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.35))
                    .frame(width: 3)

                Text(entry.quote)
                    .font(.custom("Poppins-SemiBold", size: 13))
                    .minimumScaleFactor(0.75)
                    .lineLimit(8)
                    .foregroundStyle(.primary)
            }
            .fixedSize(horizontal: false, vertical: true)

            Text(entry.author)
                .font(.custom("Poppins-Medium", size: 9))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(8)
        .padding(.trailing, 9)
        .containerBackground(
            colorScheme == .dark ? Color.darkMode : Color.lightMode,
            for: .widget
        )
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
    SimpleEntry(quote: "Do the boring work that no one else is willing to do.", author: "Alex Hormozi")
}
