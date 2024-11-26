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
        
      
        List {
          ForEach (selectedApps, id: \.self) { app in
            Text(app.name).bold().padding(.leading, 20)
              .font(.custom("Poppins-Bold", size: 16))
    
            .listRowSeparator(.hidden)
         
          }
          .onDelete(perform: removeApp)
          .onMove(perform: moveApp)
        }
      
        .background(Color.white)
        .listStyle(PlainListStyle())
        .onAppear {
          selectedApps = SharedStorage.loadSelectedApps() // Load saved apps from persistent storage when the view appears
        }
        
        // Make the list draggable for reordering
        //      NavigationView {
        //                List(availableApps, id: \.self) { app in
        //                    HStack {
        //                      Text(app.name) // Display the app name
        //
        //                        Spacer()
        //
        //                        // Plus icon to add app to selected apps
        //                        Button(action: {
        //                          addApp(app)
        //                        }) {
        //                            Image(systemName: "plus.circle.fill")
        //                                .foregroundColor(.black)
        //                                .clipShape(Circle())
        //                                .scaleEffect(1.5)
        //                        }
        //                        .buttonStyle(PlainButtonStyle()) // To avoid extra button styling
        //                    }
        //                    .padding()
        //                }
        //                .navigationTitle("Available Apps")
        //            }
        //      .onAppear {
        //                selectedApps = SharedStorage.loadSelectedApps() // Load saved apps from persistent storage when the view appears
        //              }
        
      }
    
  
  func moveApp(from source: IndexSet, to destination: Int) {
         selectedApps.move(fromOffsets: source, toOffset: destination)
         SharedStorage.saveSelectedApps(selectedApps) // Save the new order
         WidgetCenter.shared.reloadAllTimelines() // Update widget after reordering
     }
  
  func removeApp(at offsets: IndexSet) {
            for index in offsets {
                selectedApps.remove(at: index)
            }
          // Save the updated selectedApps list
          SharedStorage.saveSelectedApps(selectedApps)
          
          // Trigger widget update if needed
          WidgetCenter.shared.reloadAllTimelines()
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
