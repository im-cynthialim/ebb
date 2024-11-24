//
//  ContentView.swift
//  dumbphone
//
//  Created by Cynthia Lim on 2024-11-21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
          Link(destination: URL(string: "spotify://")!) {
            Text("Open Test Spotify")
          }
          .onTapGesture {
            print("open spotif")
          }
          
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
