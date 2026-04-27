//
//  Color+Hex.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/26/26.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red:     Double((hex >> 16) & 0xff) / 255,
            green:   Double((hex >> 08) & 0xff) / 255,
            blue:    Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

// MARK: - App Palette
extension Color {
    static let mbOrange       = Color(hex: 0xF7931A)
    static let mbBgDark       = Color(hex: 0x121214)
    static let mbCardBg       = Color(hex: 0x202024)
    static let mbTextPrimary  = Color(hex: 0xFFFFFF)
    static let mbTextDisabled = Color(hex: 0x7C7C8A)
    static let mbTextSecondary = Color(hex: 0xA9A9B2)
    static let mbGreenAccent  = Color(hex: 0x00D395)
}
