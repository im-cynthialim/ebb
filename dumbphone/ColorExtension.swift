//
//  ColorExtension.swift
//  dumbphone
//
//  Created by Cynthia Lim on 2024-11-24.
//

// Note: Set target membership to both the app and its widgets

import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
  
  //  using this color to hide bottom grey bar
  static let darkMode = Color(hex: "#252424", alpha: 1.0)
  static let lightMode = Color(hex: "F4F4F4", alpha: 1.0)
}


