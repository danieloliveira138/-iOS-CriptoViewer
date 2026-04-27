//
//  ExchangeListView.swift
//  CryptoViewer
//
//  Created by Daniel Oliveira on 4/25/26.
//

import SwiftUI
internal import Combine

struct ExchangeListView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel: ExchangeListViewModel

    init(useCase: ExchangeUseCase = ExchangeUseCaseImpl()) {
        _viewModel = StateObject(wrappedValue: ExchangeListViewModel(useCase: useCase))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 0) {
                Text("Exchanges")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.mbTextPrimary)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier("exchanges-title")

                Rectangle()
                    .fill(Color.mbOrange)
                    .frame(height: 2)
            }
            .background(Color.mbBgDark)

            ZStack {
                Color.mbBgDark.ignoresSafeArea()

                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .mbOrange))
                            .scaleEffect(1.5)
                            .accessibilityIdentifier("exchanges-loading")
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.exchanges) { exchange in
                                Button {
                                    viewModel.didSelectExchangeItem(exchange: exchange)
                                } label: {
                                    ExchangeRow(exchange: exchange)
                                }
                                .buttonStyle(.plain)
                                .accessibilityIdentifier("exchange-row-\(exchange.id)")
                            }
                            Color.clear
                                .frame(height: 1)
                                .task {
                                    if let lastId = viewModel.exchanges.last?.id {
                                        await viewModel.loadMoreIfNeeded(exchangeId: lastId)
                                    }
                                }
                        }
                        .padding(16)
                    }
                    .accessibilityIdentifier("exchanges-list")
                    .refreshable {
                        await viewModel.refresh()
                    }
                    .background(Color.mbBgDark)
                }
            }
            .background(Color.mbBgDark.ignoresSafeArea())
            .navigationBarHidden(true)
            .onAppear {
                viewModel.onNavigateToDetail = { id in
                    coordinator.showExchangeDetail(id: id)
                }
            }
            .task {
                await viewModel.fetchExchangesList()
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
}

#Preview {
    ExchangeListView()
        .environmentObject(AppCoordinator())
}
