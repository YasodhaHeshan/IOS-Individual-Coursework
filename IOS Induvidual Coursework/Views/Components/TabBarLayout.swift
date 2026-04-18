import SwiftUI

enum TabBarLayout {
    static var bottomClearance: CGFloat {
        let height = UIScreen.main.bounds.height
        switch height {
        case ..<700:
            return 84
        case ..<820:
            return 96
        default:
            return 112
        }
    }
}
