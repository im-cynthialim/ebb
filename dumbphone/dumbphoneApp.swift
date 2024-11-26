import SwiftUI

@main
struct dumbphoneApp: App {
  @AppStorage("openedFromWidget") private var openedFromWidget = false
  @State private var targetURLScheme: String?
  @State private var selectedApps: [AppInfo]
  
  init() {
      // Load selected apps from shared storage
      let savedApps = SharedStorage.loadSelectedApps()

          // If there are no saved apps, use the default apps
          if savedApps.isEmpty {
              let defaultApps = [
                  AppInfo(name: "spotify", urlScheme: "spotify://"),
                  AppInfo(name: "books", urlScheme: "ibooks://"),
                  AppInfo(name: "mail", urlScheme: "message://"),
                  AppInfo(name: "whatsapp", urlScheme: "whatsapp://"),
                  AppInfo(name: "photos", urlScheme: "photos-redirect://"),
                  AppInfo(name: "discord", urlScheme: "discord://"),
                  
              ]
              selectedApps = defaultApps
              // Save the default apps to shared storage
              SharedStorage.saveSelectedApps(defaultApps)
          } else {
              // If apps exist in storage, use them
              selectedApps = savedApps
          }

      }
  
  var body: some Scene {
    
    WindowGroup {
      DecideView(targetURLScheme: $targetURLScheme)
        .onOpenURL{url in
          // when text is clicked, find the right URL scheme to open
          if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
             components.host == "openApp",
             let queryItems = components.queryItems,
             let urlScheme = queryItems.first(where: { $0.name == "urlScheme" })?.value {
          // update vars
            targetURLScheme = urlScheme
            openedFromWidget = true
          // open app using url scheme
            openApp(with: urlScheme)
          }
        }
    }
    
    
  }
  
  private func openApp(with urlScheme: String) {
    if let url = URL(string: urlScheme) {
      UIApplication.shared.open(url, options: [:]) { success in
        if success {
          print("App opened successfully: \(urlScheme)")
          // Reset targetURLScheme after opening
          DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            targetURLScheme = nil
            openedFromWidget = false
          }
        } else {
          print("Failed to open app with URL scheme: \(urlScheme)")
        }
      }
    } else {
      print("Invalid URL scheme: \(urlScheme)")
    }
  }
}


struct DecideView: View {
    @AppStorage("openedFromWidget") private var openedFromWidget = false
    @Binding var targetURLScheme: String?

    var body: some View {
        VStack {
            if openedFromWidget {
              BlankView(targetURLScheme: $targetURLScheme)
            } else {
              ContentView()
               
            }
        }
    }
}

struct BlankView: View {
  @AppStorage("openedFromWidget") private var openedFromWidget = false
  @Binding var targetURLScheme: String?
    var body: some View {
      Color.clear
    }
}

