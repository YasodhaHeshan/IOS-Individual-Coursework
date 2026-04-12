import SwiftUI

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    let accentColor: Color = .orange

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                if index == currentPage {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(accentColor)
                        .frame(width: 24, height: 6)
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
}
