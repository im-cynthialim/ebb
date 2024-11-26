//
//  ContentView.swift
//  dumbphone
//
//  Created by Cynthia Lim on 2024-11-21.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
  @Environment(\.colorScheme) var colorScheme
  @State private var selectedApps: [AppInfo] = []
  @State private var editingAppId: UUID? = nil
  
  let lightGrey = Color(red: 0.8274509803921568, green: 0.8274509803921568, blue: 0.8274509803921568)
  
  var body: some View {
    VStack {
      Text("Selected Apps").padding(.top, 20).bold().padding(.bottom, 20)
      
      List {
        ForEach(selectedApps) { app in
          if editingAppId == app.id {
            if let index = selectedApps.firstIndex(where: { $0.id == app.id }) {
              TextField("Edit app name", text: $selectedApps[index].name).bold().font(.custom("Poppins-Bold", size: 16))
                .padding(.leading, 10)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).strokeBorder(lightGrey, lineWidth: 0.5))
                .frame(width: 200)
                .onSubmit {
                  // Save changes and exit editing mode
                  SharedStorage.saveSelectedApps(selectedApps)
                  editingAppId = nil
                }
            }
          } else {
            Text(app.name).bold().font(.custom("Poppins-Bold", size: 16)).padding(.leading, 10)
              .onTapGesture {
                //                         Set editing mode if row clicked
                editingAppId = app.id
              }
          }
        }
        .onDelete(perform: removeApp) // Delete by sliding left
        .onMove(perform: moveApp) // Make the list draggable for reordering
        .listRowSeparator(.hidden)
      }
      .background(colorScheme == .dark ? Color.darkMode : Color.lightMode)
      .listStyle(PlainListStyle())
      .onAppear {
        selectedApps = SharedStorage.loadSelectedApps() // Load saved apps from persistent storage when the view appears
      }
      
      
      List(availableApps, id: \.self) { app in
        HStack {
          
          Text(app.name) // Display the app name
          
          Spacer()
          
          // Plus icon to add app to selected apps
          Button(action: {
            addApp(app)
          }) {
            Image(systemName: "plus.circle.fill")
              .foregroundColor(.black)
              .clipShape(Circle())
              .scaleEffect(1.5)
          }
          .buttonStyle(PlainButtonStyle()) // To avoid extra button styling
        }
        .padding()
      }
      
      .onAppear {
        selectedApps = SharedStorage.loadSelectedApps() // Load saved apps from persistent storage when the view appears
      }
      
    }
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
