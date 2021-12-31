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

@MainActor
public final class HomeViewModel: ObservableObject {
    
    private let service: UVWeatherService
    private let feedbackGenerator: HapticFeedbackGenerator
    private let userDefaults: UserDefaultsManager
    private let constants: HomeConstants
    private var cancellables = Set<AnyCancellable>()
    private var direction: Direction = .none
    @Published var uiState: HomeViewModelUIState = .firstDisplay
    
    public init(
        with service: UVWeatherService,
        feedbackGenerator: HapticFeedbackGenerator,
        userDefaults: UserDefaultsManager,
        constants: HomeConstants
    ) {
        self.service = service
        self.feedbackGenerator = feedbackGenerator
        self.userDefaults = userDefaults
        self.constants = constants
    }
    
    func viewDidAppear() async {
        guard case .firstDisplay = uiState else { return }
        await load()
    }
    
    func scrollWasUpdated(with offset: CGFloat) async {
        if direction == .none {
            guard !offset.isZero else { return }
            direction = offset > .zero ? .down : .up
        } else if offset == .zero {
            direction = .none
        }
        
        if direction == .down, offset >= constants.loadOffset {
            direction = .none
            await load()
        }
    }
    
    private func load() async {
        guard canLoad() else { return }
        
        uiState = .loading
        feedbackGenerator.generate(.selectionChanged)
        
        do {
            if constants.loadBufferTime > .zero {
                try await Task.sleep(nanoseconds: constants.nanoseconds)
            }
            
            let data = try await service.fetchUV()
            
            guard let firstItem = data.items.first else { throw APIError.invalid }
            guard Calendar.singapore.isDateInToday(firstItem.timestamp) else { throw APIError.outdated }
            
            handleEventsOnReceiveOutput(data)
            
            let items = data.items.first?.records.compactMap { record -> UVWidgetData? in
                guard let uvIndex = UVIndex(from: record.value) else { return nil }
                return UVWidgetData(
                    date: record.timestamp,
                    uvValue: String(record.value),
                    uvDescription: uvIndex.name()
                )
            }
            
            guard let validItems = items else { throw APIError.unknown }
            
            handleReceivedUVWidgetData(validItems)
        } catch(let error) {
            handleError(error)
        }
    }
    
    private func handleEventsOnReceiveOutput(_ data: UVData) {
        if let encodedData = try? JSONEncoder.iso8601Encoder.encode(data) {
            self.userDefaults.set(encodedData, forKey: UserDefaultsKeys.lastUVDataUpdated.rawValue)
        }
    }
    
    private func handleReceivedUVWidgetData(_ data: [UVWidgetData]) {
        feedbackGenerator.generate(.successNotification)
        uiState = .validData(data)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func handleError(_ error: Error) {
        feedbackGenerator.generate(.errorNotification)
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
        guard case .loading = uiState else { return true }
        return false
    }
    
}

private extension HomeConstants {
    var nanoseconds: UInt64 {
        UInt64(loadBufferTime * 1000000000)
    }
}
