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
}

struct blankwidgetEntryView: View {
    var entry: SimpleEntry
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Color.clear // Blank widget background
        .containerBackground(colorScheme == .dark ? Color.darkMode : Color.white, for: .widget)
      
    }
  
}


struct blankwidget: Widget {
    let kind: String = "blankwidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            blankwidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Blank Widget")
        .description("Add this widget above the main widget to position your list of apps")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    blankwidget()
} timeline: {
    SimpleEntry()
}
