import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 16) {
                    AppLogo(size: 74, iconSize: 30)

                    VStack(spacing: 4) {
                        Text("RepairCost LK")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)

                        Text("AUTOMOTIVE PRECISION")
                            .font(.footnote.weight(.medium))
                            .tracking(2)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Text("EST. MODERN • VEHICLE DIAGNOSTIC SUITE")
                    .font(.caption2.weight(.medium))
                    .tracking(1)
                    .foregroundStyle(.tertiary)
                    .padding(.bottom, 18)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    SplashView()
}
