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
  
  
  let lightGrey = Color(red: 0.8274509803921568, green: 0.8274509803921568, blue: 0.8274509803921568)
  
  var body: some View {
    VStack {
      Text("Selected Apps").padding(.top, 20).bold().padding(.bottom, 20)
      
      List {
        ForEach(selectedApps) { app in
          if editingAppId == app.id {
            if let index = selectedApps.firstIndex(where: { $0.id == app.id }) {
              TextField("Edit app name", text: $selectedApps[index].name).bold().font(.custom("Poppins-Bold", size: 20))
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
            Text(app.name).bold().font(.custom("Poppins-Bold", size: 20)).padding(.leading, 10)
              .onTapGesture {
                // Set editing mode if row clicked
                editingAppId = app.id
              }
          }
        }
        .onDelete(perform: removeApp) // Delete by sliding left
        .onMove(perform: moveApp) // Make the list draggable for reordering
        .listRowSeparator(.hidden)
        .listRowBackground(colorScheme == .dark ? Color.darkMode : Color.lightMode)
      }
      .listStyle(PlainListStyle())
      .onAppear {
        selectedApps = SharedStorage.loadSelectedApps() // Load saved apps from persistent storage when the view appears
      }
      
      ZStack {
        Button (action: {
          withAnimation {
            showPopup = true
          }
        }) {
          
          Text ("New App")
            .bold()
            .foregroundColor(Color.lightMode)
            .padding(15)
            .background(Color.darkMode)
            .cornerRadius(8)
        }
        if showPopup {
          VStack {
            VStack{
              TextField("app name", text: $newApp.name)
              TextField("app url", text: $newApp.urlScheme)
            }
            .padding(.leading, 10)
            
            
            
            HStack {
              Button(action: {
                withAnimation {
                  showPopup = false // Close the popup
                }
              }) {
                Text("Cancel")
                  .foregroundColor(Color.darkMode)
                  .padding(10)
                  .overlay(
                    RoundedRectangle(cornerRadius: 5)
                      .stroke(Color.darkMode, lineWidth: 1)
                  )
              }
              
              Button(action: {
                selectedApps.append(newApp)
                newApp = AppInfo(name: "", urlScheme: "") // reset values
                SharedStorage.saveSelectedApps(selectedApps)
                WidgetCenter.shared.reloadAllTimelines() // Update widget after reordering
                withAnimation {
                  showPopup = false // Close the popup
                }
              }) {
                Text("Add")
                .padding(10)
                .foregroundColor(Color.lightMode)
                
                .background(Color.darkMode)
              }
              .cornerRadius(5)
            }
          
  
          }
            .frame(width: 300, height: 200)
            .padding(5)
            .background(Color.lightMode) // Dimmed background
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(Color.darkMode, lineWidth: 1) // Border color and width
            )
            .transition(.scale) // Smooth animation
            .animation(.easeInOut, value: showPopup)
          }
          
        }
        
        
        
        
        List{
          
          ForEach(availableApps){ app in
            HStack {
              
              
              Text(app.name)
              
              
              Spacer()
              
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
            .listRowBackground(colorScheme == .dark ? Color.darkMode : Color.lightMode)
          }
          .listStyle(PlainListStyle())
        }
        .onAppear {
          selectedApps = SharedStorage.loadSelectedApps() // Load saved apps from persistent storage when the view appears
          
        }
        
      }
      
      .background(colorScheme == .dark ? Color.darkMode : Color.lightMode)
    }
    
    //  func newApp(
    
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
  
  struct ModalView: View {
    var body: some View {
      VStack {
        Text ("opened modal")
        
      }
    }
  }
  
  
  #Preview {
    ContentView()
  }
