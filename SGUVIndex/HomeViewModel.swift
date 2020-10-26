//
//  HomeViewModel.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import SwiftUI
import Combine
import WidgetKit

final class HomeViewModel: ObservableObject {
    
    @Published var uvItems: [UVWidgetData]
    let service: UVWeatherService
    var cancellables = Set<AnyCancellable>()
    
    init(with service: UVWeatherService) {
        self.uvItems = [
            UVWidgetData(date: Date(),
                         uvValue: "0",
                         uvDescription: "-")
        ]
        self.service = service
    }
    
    func load() {
        service.fetchUV()
            .tryMap { data -> [UVWidgetData] in
                guard let firstItem = data.items.first else { throw APIError.invalid }
                return firstItem.records.compactMap { record -> UVWidgetData? in
                    guard let uvIndex = UVIndex(from: record.value) else { return nil }
                    return UVWidgetData(date: record.timestamp,
                                        uvValue: String(record.value),
                                        uvDescription: uvIndex.name())
                }
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(UVWidgetData.previewData.date)
                print(completion)
            }, receiveValue: { [weak self] value in
                guard let this = self else { return }
                print(value)
                this.uvItems = value
                
                WidgetCenter.shared.reloadAllTimelines()
            }).store(in: &cancellables)
    }
    
}
