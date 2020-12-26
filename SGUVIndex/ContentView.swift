//
//  ContentView.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var offset: CGFloat = .zero
    @ObservedObject var viewModel: HomeViewModel
    let constants: HomeConstants
    let foregroundColor: Color = .white
    
    init(with viewModel: HomeViewModel, constants: HomeConstants) {
        self.viewModel = viewModel
        self.constants = constants
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            displayView(when: viewModel.uiState)
        }
        .onAppear() {
            viewModel.load()
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
            }
        }
    }
    
    private func displayViewWhenError(_ message: String) -> some View {
        Group {
            buildTitleViews()
            Text(message)
                .font(.caption)
                .fontWeight(.bold)
//            .foregroundColor(foregroundColor)
        }
    }
    
    private func buildTitleViews() -> some View {
        Group {
            HStack {
                Spacer()
                VStack {
                    Text("Singapore")
                        .font(.custom("Roboto-Black", size: 24))
                    Text("UV Levels")
                        .font(.custom("Roboto-Regular", size: 24))
                }
                Spacer()
                VStack {
                    Text(Date().monthComponent)
                        .font(.custom("Roboto-Regular", size: 20))
                    Text(Date().dayComponent)
                        .font(.custom("Roboto-Black", size: 30))
                }
                Spacer()
            }
            .padding(.top, 32)
            .padding(.bottom, 16)
        }
    }
}
