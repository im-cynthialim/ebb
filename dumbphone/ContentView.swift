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
  @State private var showPopup = false
  @State private var newApp = AppInfo(name: "", urlScheme: "")
  @State private var addedApp = false
  
  var coreColor: Color {
       colorScheme == .dark ? Color.darkMode : Color.lightMode
   }
  var oppositeColor: Color {
    colorScheme == .dark ? Color.lightMode : Color.darkMode
   }

  let lightGrey = Color(red: 0.8274509803921568, green: 0.8274509803921568, blue: 0.8274509803921568)
  
  struct ButtonWithAnimation: View {

      @State private var isClicked = false
      var coreColor: Color
      var oppositeColor: Color
      let action: () -> Void
    
      var body: some View {
          Button(action: {
              isClicked.toggle() // Toggle the local state
              action() // Perform the action passed in
              DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 2 seconds delay
                           isClicked = false
                       }
          }) {
              Image(systemName: isClicked ? "checkmark.circle.fill" : "plus.circle.fill")
              .foregroundColor(isClicked ? .green : oppositeColor)
              .font(.system(size: 20))
                .scaleEffect(isClicked ? 1.0 : 1.0)
                  .animation(.easeInOut(duration: 0.2), value: isClicked) // Smooth animation
          }
          .buttonStyle(PlainButtonStyle())
      }
  }

  
  var body: some View {
    ZStack {
      
      VStack {
        Text("Selected Apps").padding(.top, 20).bold().padding(.bottom, 20)
        
        List {
          ForEach(selectedApps) { app in
            if editingAppId == app.id {
              if let index = selectedApps.firstIndex(where: { $0.id == app.id }) {
                TextField("Edit app name", text: $selectedApps[index].name).bold() .font(.system(size: 15))
                  .padding(.leading, 10)
                  .padding(8)
                  .background(RoundedRectangle(cornerRadius: 8).strokeBorder(lightGrey, lineWidth: 0.5))
                
                  .frame(width: 200)
                  .onSubmit {
                    // Save changes and exit editing mode
                    SharedStorage.saveSelectedApps(selectedApps)
                    WidgetCenter.shared.reloadAllTimelines()
                    editingAppId = nil
                  }
              }
            } else {
              Text(app.name).bold().font(.system(size: 15)).padding(.leading, 10)
                .onTapGesture {
                  // Set editing mode if row clicked
                  editingAppId = app.id
                }
            }
          }
          .onDelete(perform: removeApp) // Delete by sliding left
          .onMove(perform: moveApp) // Make the list draggable for reordering
          .listRowSeparator(.hidden)
          .listRowBackground(coreColor)
        }
        .listStyle(PlainListStyle())
        .onAppear {
          selectedApps = SharedStorage.loadSelectedApps() // Load saved apps from persistent storage when the view appears
        }
        
        Divider()
          .frame(height: 2) // Adjust the thickness
          .background(oppositeColor)
        
        
        ZStack {
          Text("Available Apps").padding(.top, 20).bold().padding(.bottom, 20).padding(.leading, 25).frame(maxWidth: .infinity, alignment: .leading)
          Button (action: {
            withAnimation {
              showPopup = true
            }
          }) {
            
            Text ("New App")
              .bold()
              .foregroundColor(colorScheme == .dark ? Color.darkMode : Color.lightMode)
              .padding(15)
              .background(colorScheme == .dark ? Color.lightMode : Color.darkMode)
              .cornerRadius(8)
          }
          .frame(maxWidth: .infinity, alignment: .trailing).padding(.trailing, 25)
          
        }
        
        
        
        List{
          ForEach(availableApps){ app in
            HStack {
              
              
              Text(app.name)
              
              
              Spacer()
              
              ButtonWithAnimation(coreColor: coreColor, oppositeColor: oppositeColor, action: {
                addApp(app)
              })
              .buttonStyle(PlainButtonStyle()) // To avoid extra button styling
            }
            .padding()
            .listRowBackground(coreColor)
          }
          .listRowSeparator(.hidden)
          .listRowBackground(coreColor)
          
        }
        .listStyle(PlainListStyle())
        .onAppear {
          selectedApps = SharedStorage.loadSelectedApps() // Load saved apps from persistent storage when the view appears
        }
      }
      .background(coreColor)
      
      if showPopup {
        VStack {
          VStack{
            TextField("app name", text: $newApp.name)
            TextField("app url", text: $newApp.urlScheme)
          }
          .padding(.horizontal, 20)
          .padding(.top, 20)
          
          
          
          
          HStack {
            Button(action: {
              withAnimation {
                showPopup = false // Close the popup
              }
            }) {
              Text("Cancel")
                .foregroundColor(colorScheme == .dark ? Color.lightMode : Color.darkMode)
                .padding(10)
                .overlay(
                  RoundedRectangle(cornerRadius: 5)
                    .stroke(colorScheme == .dark ? Color.lightMode : Color.darkMode, lineWidth: 1)
                )
            }
            
            Button(action: {
              if (newApp.name != "" || newApp.urlScheme != "") {
                selectedApps.append(newApp)
              }
              newApp = AppInfo(name: "", urlScheme: "") // reset values
              SharedStorage.saveSelectedApps(selectedApps)
              WidgetCenter.shared.reloadAllTimelines() // Update widget after reordering
              withAnimation {
                showPopup = false // Close the popup
              }
            }) {
              Text("Add")
                .padding(10)
                .foregroundColor(coreColor)
              
                .background(oppositeColor)
            }
            .cornerRadius(5)
          }
          .padding(.top, 10)
          
          
        }
        .frame(width: 300)
        .padding(.bottom, 20)
        .background(colorScheme == .dark ? Color.darkMode : Color.lightMode) // Dimmed background
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(colorScheme == .dark ? Color.lightMode : Color.darkMode, lineWidth: 1) // Border color and width
        )
        .transition(.scale) // Smooth animation
        .animation(.easeInOut, value: showPopup)
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
