//
//  ExchangeDetailsView.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import SwiftUI

// MARK: - Main View
struct ExchangeDetailsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel: ExchangeDetailViewModel

    let exchangeId: Int

    init(exchangeId: Int, useCase: ExchangeUseCase = ExchangeUseCaseImpl()) {
        self.exchangeId = exchangeId
        _viewModel = StateObject(wrappedValue: ExchangeDetailViewModel(useCase: useCase))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.didTapBack()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.mbOrange)
                }
                .accessibilityIdentifier("exchange-detail-back")

                Text("Exchange Details")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.mbTextPrimary)
                    .accessibilityIdentifier("exchange-detail-title")

                Spacer()
            }
            .padding(.top, 40)
            .padding(.bottom, 20)
            .padding(.horizontal, 24)
            .background(Color.mbBgDark)
            .overlay(
                Rectangle()
                    .fill(Color.mbOrange)
                    .frame(height: 2),
                alignment: .bottom
            )

            // Content
            if let info = viewModel.exchangeInfo {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        ExchangeTopInfo(
                            name: info.name,
                            logo: info.logo,
                            id: info.id,
                            dateLaunched: info.dateLaunched
                        )

                        HStack(spacing: 12) {
                            StatCard(
                                label: "Maker Fee",
                                value: info.makerFee.map { "\($0)%" } ?? "N/A"
                            )
                            StatCard(
                                label: "Taker Fee",
                                value: info.takerFee.map { "\($0)%" } ?? "N/A"
                            )
                        }

                        LinkRowView(websites: info.urls.website)
                        DescriptionSection(description: info.description)
                        TradeCoinsList(coinsList: info.tradeCoins)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 16)
                }
                .background(Color.mbBgDark)
            } else {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .mbOrange))
                    .scaleEffect(1.5)
                    .accessibilityIdentifier("exchange-detail-loading")
                Spacer()
            }
        }
        .background(Color.mbBgDark.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onNavigateBack = {
                coordinator.pop()
            }
        }
        .task {
            await viewModel.load(id: exchangeId)
        }
        .alert("Oooops", isPresented: Binding(
            get: { viewModel.error != nil },
            set: { if !$0 { viewModel.error = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
    }
}

// MARK: - Subviews

struct ExchangeTopInfo: View {
    let name: String
    let logo: String?
    let id: Int
    let dateLaunched: String?

    private var launchYear: String? {
        dateLaunched.flatMap { $0.isEmpty ? nil : String($0.prefix(4)) }
    }

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: logo.flatMap(URL.init)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 56, height: 56)
            .padding(4)
            .background(Color.white)
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.mbTextPrimary)
                    .accessibilityIdentifier("exchange-detail-name")

                Text("ID: \(id)" + (launchYear.map { " | Launched: \($0)" } ?? ""))
                    .font(.system(size: 14))
                    .foregroundColor(.mbTextDisabled)
            }
            Spacer()
        }
    }
}

struct StatCard: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.mbOrange)
                .frame(width: 3)

            VStack(alignment: .leading, spacing: 4) {
                Text(label.uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.mbTextSecondary)

                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.mbTextPrimary)
            }
            .padding(16)
            Spacer(minLength: 0)
        }
        .background(Color.mbCardBg)
        .cornerRadius(12)
    }
}

struct LinkRowView: View {
    let websites: [String]

    var body: some View {
        if !websites.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Website")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.mbOrange)

                ForEach(websites, id: \.self) { urlString in
                    if let url = URL(string: urlString) {
                        Link("\(urlString) ↗", destination: url)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.mbOrange)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(16)
                            .background(Color.mbCardBg)
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
}

struct DescriptionSection: View {
    let description: String?

    var body: some View {
        if let text = description, !text.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("About")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.mbOrange)

                Text(text)
                    .font(.system(size: 14))
                    .lineSpacing(4)
                    .foregroundColor(.mbTextSecondary)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.mbCardBg)
                    .cornerRadius(12)
            }
        }
    }
}

#Preview {
    ExchangeDetailsView(exchangeId: 24)
        .environmentObject(AppCoordinator())
}
