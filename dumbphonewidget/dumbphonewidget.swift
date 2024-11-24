import WidgetKit
import SwiftUI

struct AppInfo: Identifiable, Hashable {
  let id = UUID()
  let name: String
  let urlScheme: String
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(apps: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(apps: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
      let selectedApps = [AppInfo(name: "spotify", urlScheme: "spotify://"), AppInfo(name: "iBooks", urlScheme: "ibooks://")]
      let entry = SimpleEntry(apps: selectedApps)
        let timeline = Timeline(entries: [entry], policy: .never) // No time-based updates
        completion(timeline)
    }
}



struct SimpleEntry: TimelineEntry {
    let date = Date() // Required by WidgetKit; unused in logic
    var apps: [AppInfo]
}

struct dumbphonewidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        VStack (alignment: .center, spacing: 10){
   
          
          if !entry.apps.isEmpty {
            ForEach(entry.apps, id: \.self) { app in
              Link(destination: URL(string: "dumbphone://openApp?urlScheme=\(app.urlScheme)")!) {
                Text(app.name).bold().font(.custom("Poppins-Bold", size:20))
              }
            }
              
            
          } else {
            Text("No Apps")
            
          }
        }
        .padding(20)
    }
  
}

struct dumbphonewidget: Widget {
    let kind: String = "dumbphonewidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            dumbphonewidgetEntryView(entry: entry)
                .containerBackground(.white.tertiary, for: .widget)
        }
        .configurationDisplayName("My Widget")
        .description("This is a simple widget.")
//        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    dumbphonewidget()
} timeline: {
    SimpleEntry(apps: [AppInfo(name: "Spotify Music", urlScheme: "spotify://"), AppInfo(name: "iBooks", urlScheme: "ibooks://")])
}
