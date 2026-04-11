import SwiftUI

struct OnboardingCardView: View {
    let page: OnboardingPage
    let onNext: () -> Void
    let onSkip: () -> Void
    let isLastPage: Bool

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                decorativeBackground

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        iconCircle

                        VStack(spacing: 12) {
                            Text(page.title)
                                .font(.system(size: 36, weight: .heavy, design: .rounded))
                                .multilineTextAlignment(.center)

                            Text(page.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }

                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                }

                VStack(spacing: 12) {
                    if isLastPage {
                        Button {
                            onNext()
                        } label: {
                            HStack {
                                Text("Get Started")
                                    .font(.headline.weight(.semibold))
                                Image(systemName: "arrow.right")
                                    .font(.subheadline.weight(.semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.orange)
                            )
                        }
                    } else {
                        Button {
                            onNext()
                        } label: {
                            HStack {
                                Text("Next")
                                    .font(.headline.weight(.semibold))
                                Image(systemName: "arrow.right")
                                    .font(.subheadline.weight(.semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.orange)
                            )
                        }

                        Button {
                            onSkip()
                        } label: {
                            Text("Skip")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 16)
                .background(Color(uiColor: .systemGroupedBackground))
            }
        }
    }

    private var decorativeBackground: some View {
        ZStack {
            Color(uiColor: .secondarySystemGroupedBackground)

            VStack {
                HStack {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.gray.opacity(0.2))
                    Spacer()
                }
                .padding(20)

                Spacer()

                HStack {
                    Spacer()
                    Image(systemName: "wrench.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.orange.opacity(0.15))
                }
                .padding(20)
            }

            iconCircle
        }
        .frame(height: 220)
    }

    private var iconCircle: some View {
        VStack {
            Circle()
                .fill(Color.white)
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 140, height: 140)
                )
                .overlay(
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 180, height: 180)
                )
                .overlay(
                    Image(systemName: page.icon)
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(Color.orange)
                )
        }
    }
}
