//
//  ScreennamesView.swift
//  dumbphone
//
//  Created by Cynthia Lim on 2025-03-03.
//

import SwiftUI
import WidgetKit

struct ScreennamesView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var screennames: [Screenname] = []
    @State private var showPopup = false
    @State private var newHandle = ""

    var coreColor: Color {
        colorScheme == .dark ? Color.darkMode : Color.lightMode
    }
    var oppositeColor: Color {
        colorScheme == .dark ? Color.lightMode : Color.darkMode
    }

    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(screennames) { sn in
                        Text("@\(sn.handle)").bold().font(.system(size: 15)).padding(.leading, 10)
                    }
                    .onDelete(perform: removeScreenname)
                    .onMove(perform: moveScreenname)
                    .listRowSeparator(.hidden)
                    .listRowBackground(coreColor)
                }
                .listStyle(PlainListStyle())
            }
            .background(coreColor)
            .navigationTitle("Quote Accounts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { withAnimation { showPopup = true } }) {
                        Image(systemName: "plus")
                            .foregroundColor(oppositeColor)
                    }
                }
            }
            .onAppear {
                screennames = SharedStorage.loadScreennames()
            }

            if showPopup {
                VStack {
                    TextField("@handle", text: $newHandle)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    HStack {
                        Button(action: {
                            withAnimation { showPopup = false }
                            newHandle = ""
                        }) {
                            Text("Cancel")
                                .foregroundColor(oppositeColor)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(oppositeColor, lineWidth: 1)
                                )
                        }

                        Button(action: {
                            let handle = newHandle
                                .trimmingCharacters(in: .whitespaces)
                                .replacingOccurrences(of: "@", with: "")
                            if !handle.isEmpty {
                                screennames.append(Screenname(id: UUID(), handle: handle))
                                SharedStorage.saveScreennames(screennames)
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                            newHandle = ""
                            withAnimation { showPopup = false }
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
                .background(coreColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(oppositeColor, lineWidth: 1)
                )
                .transition(.scale)
                .animation(.easeInOut, value: showPopup)
            }
        }
    }

    func moveScreenname(from source: IndexSet, to destination: Int) {
        screennames.move(fromOffsets: source, toOffset: destination)
        SharedStorage.saveScreennames(screennames)
        WidgetCenter.shared.reloadAllTimelines()
    }

    func removeScreenname(at offsets: IndexSet) {
        screennames.remove(atOffsets: offsets)
        SharedStorage.saveScreennames(screennames)
        WidgetCenter.shared.reloadAllTimelines()
    }
}

#Preview {
    NavigationStack {
        ScreennamesView()
    }
}
