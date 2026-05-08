//
//  AccessibilitySettings.swift
//  IOS Induvidual Coursework
//
//  Created on 08/05/2026.
//

import SwiftUI
import Combine

final class AccessibilitySettings: ObservableObject {
    static let shared = AccessibilitySettings()

    @Published var textSize: String {
        didSet { UserDefaults.standard.set(textSize, forKey: "textSize") }
    }
    @Published var boldTextEnabled: Bool {
        didSet { UserDefaults.standard.set(boldTextEnabled, forKey: "boldTextEnabled") }
    }
    @Published var reduceMotionEnabled: Bool {
        didSet { UserDefaults.standard.set(reduceMotionEnabled, forKey: "reduceMotionEnabled") }
    }
    @Published var hapticFeedbackEnabled: Bool {
        didSet { UserDefaults.standard.set(hapticFeedbackEnabled, forKey: "hapticFeedbackEnabled") }
    }

    private init() {
        textSize = UserDefaults.standard.string(forKey: "textSize") ?? "Default"
        boldTextEnabled = UserDefaults.standard.bool(forKey: "boldTextEnabled")
        reduceMotionEnabled = UserDefaults.standard.bool(forKey: "reduceMotionEnabled")
        hapticFeedbackEnabled = UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true
    }

    // MARK: - SwiftUI Environment Values

    var fontScale: CGFloat {
        switch textSize {
        case "Small":       return 0.85
        case "Large":       return 1.15
        case "Extra Large": return 1.30
        default:            return 1.0
        }
    }

    var dynamicTypeSize: DynamicTypeSize {
        switch textSize {
        case "Small":       return .small
        case "Large":       return .xLarge
        case "Extra Large": return .xxLarge
        default:            return .large
        }
    }

    var legibilityWeight: LegibilityWeight {
        boldTextEnabled ? .bold : .regular
    }
}
