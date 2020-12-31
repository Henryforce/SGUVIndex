//
//  HomeViewModel.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import SwiftUI
import Combine
import WidgetKit

enum HomeViewModelUIState {
    case firstDisplay
    case loading
    case validData([UVWidgetData])
    case error(String)
}

final class HomeViewModel: ObservableObject {
    
    private let service: UVWeatherService
    private let feedbackGenerator: FeedbackGenerator
    private let constants: HomeConstants
    private var cancellables = Set<AnyCancellable>()
    private var direction: Direction = .none
    @Published var uiState: HomeViewModelUIState = .firstDisplay
    
    init(
        with service: UVWeatherService,
        feedbackGenerator: FeedbackGenerator,
        constants: HomeConstants
    ) {
        self.service = service
        self.feedbackGenerator = feedbackGenerator
        self.constants = constants
    }
    
    func viewDidAppear() {
        guard case .firstDisplay = uiState else { return }
        load()
    }
    
    func scrollWasUpdated(with offset: CGFloat) {
        if direction == .none {
            guard !offset.isZero else { return }
            direction = offset > .zero ? .down : .up
        } else if offset == .zero {
            direction = .none
        }
        
        if direction == .down, offset >= constants.loadOffset {
            direction = .none
            load()
        }
    }
    
    private func load() {
        guard canLoad() else { return }
        
        uiState = .loading
        feedbackGenerator.selectionChanged()
        
        Just.init(service)
            .delay(for: .seconds(constants.loadBufferTime), scheduler: RunLoop.main)
            .flatMap { $0.fetchUV() }
            .tryMap { data -> [UVWidgetData] in
//                throw APIError.outdated
                guard let firstItem = data.items.first else { throw APIError.invalid }
                guard Calendar.current.isDateInToday(firstItem.timestamp) else { throw APIError.outdated }
                return firstItem.records.compactMap { record -> UVWidgetData? in
                    guard let uvIndex = UVIndex(from: record.value) else { return nil }
                    return UVWidgetData(date: record.timestamp,
                                        uvValue: String(record.value),
                                        uvDescription: uvIndex.name())
                }
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.handleError(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                
                self.feedbackGenerator.notificationOccurred(.success)
                self.uiState = .validData(value)
                WidgetCenter.shared.reloadAllTimelines()
            }).store(in: &cancellables)
    }
    
    private func handleError(_ error: Error) {
        feedbackGenerator.notificationOccurred(.error)
        if let apiError = error as? APIError {
            switch apiError {
            case .outdated:
                uiState = .error(Localization.localize(.dataGovSGOutdatedMessage))
                break
            default:
                uiState = .error(Localization.localize(.dataGovSGErrorMessage))
                break
            }
        } else {
            uiState = .error(Localization.localize(.unknownErrorMessage))
        }
    }
    
    private func canLoad() -> Bool {
        switch uiState {
        case .loading:
            return false
        default:
            return true
        }
    }
    
}