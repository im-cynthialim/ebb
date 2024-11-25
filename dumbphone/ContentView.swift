//
//  ContentView.swift
//  dumbphone
//
//  Created by Cynthia Lim on 2024-11-21.
//

import SwiftUI

struct ContentView: View {
    let availableApps: [AppInfo]
  @State private var isChecked: Bool = false
    var body: some View {
      Text("hi")
      List(availableApps, id: \.name) { app in
                 VStack(alignment: .leading) {
                   Button(action: {
                                  isChecked.toggle()
                              }) {
                                  Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                                      .foregroundColor(isChecked ? .blue : .gray)
                                      .font(.title)
                              }
                     Text(app.name)
                         .font(.headline)
                     Text("URL Scheme: \(app.urlScheme)")
                         .font(.subheadline)
                         .foregroundColor(.gray)
                 }
             }
        .padding()
    }
}

#Preview {
  ContentView(availableApps: [    AppInfo(name: "Apple News", urlScheme: "applenews://"),
                                  AppInfo(name: "App Store", urlScheme: "itms-apps://itunes.apple.com"),])
}
