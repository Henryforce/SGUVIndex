//
//  ContentView.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import SwiftUI

public struct ContentView: View {
    
    @State private var offset: CGFloat = .zero
    @ObservedObject var viewModel: HomeViewModel
    let constants: HomeConstants
    let foregroundColor: Color = .white
    
    public init(with viewModel: HomeViewModel, constants: HomeConstants) {
        self.viewModel = viewModel
        self.constants = constants
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            displayView(when: viewModel.uiState)
        }.background(Color.appBackground)
        .onAppear() {
            viewModel.viewDidAppear()
        }
        
    }
    
    private func displayView(when uiState: HomeViewModelUIState) -> some View {
        Group {
            switch uiState {
            case .loading, .firstDisplay:
                displayViewWhenLoading()
            case .validData(let uvItems):
                displayViewWhenValidData(uvItems)
            case .error(let message):
                displayViewWhenError(message)
            }
        }
    }
    
    private func displayViewWhenLoading() -> some View {
        Group {
            buildTitleViews()
            ProgressView()
            Spacer()
        }
        .offset(x: 0, y: self.offset)
        .onAppear() {
            self.offset = constants.loadOffset
            withAnimation(.easeOut(duration: constants.loadBufferTime)) {
                self.offset = .zero
            }
        }
    }
    
    private func displayViewWhenValidData(_ uvItems: [UVWidgetData]) -> some View {
        ScrollViewOffset { offset in
            viewModel.scrollWasUpdated(with: offset)
        } content: {
            LazyVStack(alignment: .center, spacing: 4) {
                buildTitleViews()
                ForEach(uvItems.indices, id: \.self) { index in
                    Separator()
                    UVView(
                        uvValue: uvItems[index].uvValue,
                        uvDescription: uvItems[index].uvDescription,
                        date: uvItems[index].date,
                        index: index
                    )
                }
                buildDisclaimerText()
            }
        }
    }
    
    private func displayViewWhenError(_ message: String) -> some View {
        ScrollViewOffset { offset in
            viewModel.scrollWasUpdated(with: offset)
        } content: {
            LazyVStack(alignment: .center, spacing: 0) {
                buildTitleViews()
                Text(message)
                    .font(Font.init(.montserratBold, size: 14))
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
    
    private func buildTitleViews() -> some View {
        Group {
            HStack {
                Spacer()
                VStack {
                    Text(Localization.localize(.singapore))
                        .font(.init(.montserratBold, size: 24))
                    Text(Localization.localize(.uvLevels))
                        .font(.init(.montserratRegular, size: 24))
                }
                Spacer()
                VStack {
                    Text(Date().monthComponent)
                        .font(.init(.montserratRegular, size: 20))
                    Text(Date().dayComponent)
                        .font(.init(.montserratBold, size: 30))
                }
                Spacer()
            }
            .padding(.top, 48)
            .padding(.bottom, 24)
        }
    }
    
    private func buildDisclaimerText() -> some View {
        Group {
            Text(Localization.localize(.disclaimerMessage))
                .accessibilityIdentifier("Disclaimer")
                .font(.init(.montserratRegular, size: 9))
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
