//
//  SharedStorage.swift
//  dumbphone
//
//  Created by Cynthia Lim on 2024-11-25.
//

import Foundation




struct SharedStorage {
    static let appGroupIdentifier = "group.com.cynthialim.dumbphone"
  
  private static var cachedApps: [AppInfo]?
  
  
    
    static func loadSelectedApps() -> [AppInfo] {
      if let cachedApps = cachedApps {
                  return cachedApps
              }
      
        if let data = UserDefaults(suiteName: appGroupIdentifier)?.data(forKey: "selectedApps"),
           let apps = try? JSONDecoder().decode([AppInfo].self, from: data) {
            return apps
        }
        return []
    }
    
    static func saveSelectedApps(_ apps: [AppInfo]) {
        if let data = try? JSONEncoder().encode(apps) {
            UserDefaults(suiteName: appGroupIdentifier)?.set(data, forKey: "selectedApps")
        }
    }
}
