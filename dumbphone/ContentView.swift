//
//  ContentView.swift
//  dumbphone
//
//  Created by Cynthia Lim on 2024-11-21.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State private var isChecked: Bool = false
    @State private var selectedApps: [AppInfo] = []

    var body: some View {
      Text("Selected Apps").padding(.top, 20).bold()
//     convert Set to Array to properly list with List
      
      
        List(Array(selectedApps)) { app in
          HStack {
            Text(app.name)
            // Plus icon to add app to selected apps
            Button(action: {
              removeApp(app)
            }) {
              Image(systemName: "minus.circle.fill")
                .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
        }
      }
    .onAppear {
        selectedApps = SharedStorage.loadSelectedApps() // Load saved apps from persistent storage when the view appears
      }
      NavigationView {
                List(availableApps, id: \.self) { app in
                    HStack {
                      Text(app.name) // Display the app name
                        
                        Spacer()
                        
                        // Plus icon to add app to selected apps
                        Button(action: {
                          addApp(app)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle()) // To avoid extra button styling
                    }
                    .padding()
                }
                .navigationTitle("Available Apps")
            }
      .onAppear {
                selectedApps = SharedStorage.loadSelectedApps() // Load saved apps from persistent storage when the view appears
              }
     
    }
  
  
  func removeApp(_ app: AppInfo) {
    if let index = selectedApps.firstIndex(where: { $0.urlScheme == app.urlScheme }) {
          // Remove the app at that index
          selectedApps.remove(at: index)
          
          // Save the updated selectedApps list
          SharedStorage.saveSelectedApps(selectedApps)
          
          // Trigger widget update if needed
          WidgetCenter.shared.reloadAllTimelines()
      }
      }
  
  func addApp(_ app: AppInfo) {
    if !selectedApps.contains(app) {
          selectedApps.append(app)
        SharedStorage.saveSelectedApps(selectedApps)
      WidgetCenter.shared.reloadAllTimelines()
          }
      }
}

#Preview {
  ContentView()
 }
