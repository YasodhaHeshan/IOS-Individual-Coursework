import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                OnboardingCardView(
                    page: viewModel.currentPage,
                    onNext: handleNext,
                    onSkip: handleSkip,
                    isLastPage: viewModel.isLastPage
                )

                HStack {
                    PageIndicator(
                        currentPage: viewModel.currentPage.rawValue,
                        totalPages: OnboardingPage.allCases.count
                    )
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(uiColor: .systemGroupedBackground))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: viewModel.currentPage)
    }

    private func handleNext() {
        if viewModel.isLastPage {
            onComplete()
        } else {
            viewModel.nextPage()
        }
    }

    private func handleSkip() {
        onComplete()
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
