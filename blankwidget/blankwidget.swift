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
}


struct SimpleEntry: TimelineEntry {
    let date = Date() // Required by WidgetKit; unused in logic
//    var apps: [String]
}

struct blankwidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        // This view will now display nothing
        Color.clear // Blank widget background
    }
}


struct blankwidget: Widget {
    let kind: String = "blankwidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            blankwidgetEntryView(entry: entry)
                .containerBackground(.white.tertiary, for: .widget)
        }
        .configurationDisplayName("My Widget")
        .description("This is a simple widget.")
//        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemMedium) {
    blankwidget()
} timeline: {
    SimpleEntry()
}
