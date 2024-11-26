import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(apps: [ AppInfo(name: "spotify", urlScheme: "spotify://"),
                            AppInfo(name: "books", urlScheme: "ibooks://"),
                            AppInfo(name: "mail", urlScheme: "message://"),
                            AppInfo(name: "whatsapp", urlScheme: "whatsapp://"),
                            AppInfo(name: "photos", urlScheme: "photos-redirect://"),
                            AppInfo(name: "discord", urlScheme: "discord://")])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
      let apps = SharedStorage.loadSelectedApps()
        let entry = SimpleEntry(apps: apps)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {

      let apps = SharedStorage.loadSelectedApps()
      
      // Create a timeline entry
      let entry = SimpleEntry(apps: apps)
      
        let timeline = Timeline(entries: [entry], policy: .never) // No time-based updates
        completion(timeline)
    }
}



struct SimpleEntry: TimelineEntry {
    let date = Date() // Required by WidgetKit; unused in logic
    var apps: [AppInfo]
}

struct dumbphonewidgetEntryView: View {
    @Environment(\.colorScheme) var colorScheme
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

        .containerBackground(colorScheme == .dark ? Color.darkMode : Color.lightMode, for: .widget)
    }
  
}

struct dumbphonewidget: Widget {
    let kind: String = "dumbphonewidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            dumbphonewidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ebb")
        .description("This is main widget listing all your apps")
//        .supportedFamilies([.system.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    dumbphonewidget()
} timeline: {
    SimpleEntry(apps: [])
}


//AppInfo(name: "spotify", urlScheme: "spotify://"),
//                   AppInfo(name: "books", urlScheme: "ibooks://"),
//                   AppInfo(name: "mail", urlScheme: "message://"),
//                   AppInfo(name: "whatsapp", urlScheme: "whatsapp://"),
//                   AppInfo(name: "photos", urlScheme: "photos-redirect://"),
//                   AppInfo(name: "discord", urlScheme: "discord://")
