//
//  HapticManager.swift
//  IOS Induvidual Coursework
//
//  Created on 08/05/2026.
//

import UIKit

struct HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard AccessibilitySettings.shared.hapticFeedbackEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard AccessibilitySettings.shared.hapticFeedbackEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    static func selection() {
        guard AccessibilitySettings.shared.hapticFeedbackEnabled else { return }
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
