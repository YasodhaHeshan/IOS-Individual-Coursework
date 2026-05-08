//
//  AppFontModifier.swift
//  IOS Induvidual Coursework
//
//  Reactive font modifier that respects Text Size and Bold Text accessibility settings.
//

import SwiftUI

private struct AppFontModifier: ViewModifier {
    @ObservedObject var settings = AccessibilitySettings.shared
    let size: CGFloat
    let weight: Font.Weight
    let design: Font.Design

    func body(content: Content) -> some View {
        let scaled = size * settings.fontScale
        let effective: Font.Weight = settings.boldTextEnabled ? .bold : weight
        return content.font(.system(size: scaled, weight: effective, design: design))
    }
}

extension View {
    func appFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        modifier(AppFontModifier(size: size, weight: weight, design: design))
    }
}
