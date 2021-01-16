//
//  Mocks.swift
//  SGUVIndexTests
//
//  Created by Henry Javier Serrano Echeverria on 26/12/20.
//

import UIKit
import Combine
@testable import SGUVIndex

final class MockUVWeatherService: UVWeatherService {
    var fetchUVWasCalledCount = 0
    var data: UVData = .dataToday
    func fetchUV() -> AnyPublisher<UVData, Error> {
        fetchUVWasCalledCount += 1
        return Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class MockFeedbackGenerator: HapticFeedbackGenerator {
    
    var generateEventWasCalledCount = 0
    var generateEventValueStack = [HapticEvent]()
    func generate(_ event: HapticEvent) {
        generateEventWasCalledCount += 1
        generateEventValueStack.append(event)
    }
    
//    var impactOcurredWasCalledCount = 0
//    func impactOcurred() {
//        impactOcurredWasCalledCount += 1
//    }
//    
//    var impactOcurredWithIntensityWasCalledCount = 0
//    var impactOcurredWithIntensityValue: CGFloat?
//    func impactOccurred(intensity: CGFloat) {
//        impactOcurredWithIntensityWasCalledCount += 1
//        impactOcurredWithIntensityValue = intensity
//    }
//    
//    var selectionChangedWasCalledCount = 0
//    func selectionChanged() {
//        selectionChangedWasCalledCount += 1
//    }
//    
//    var notificationOccurredWasCalledCount = 0
//    var notificationOccurredValue: UINotificationFeedbackGenerator.FeedbackType?
//    func notificationOccurred(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
//        notificationOccurredWasCalledCount += 1
//        notificationOccurredValue = feedbackType
//    }
}

extension UVData {
    static var dataToday: UVData = {
        let currentDate = Date()
        let updateTimestamp = currentDate.addingTimeInterval(100)
        return UVData(
            items: [
                UVItem(
                    timestamp: currentDate,
                    updateTimestamp: updateTimestamp,
                    records: [
                        UVDataRecord(
                            value: .zero,
                            timestamp: currentDate
                        )
                    ]
                )
            ],
            apiInfo: .healthy
        )
    }()
    
    static var dataYesterday: UVData = {
        let currentDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let updateTimestamp = currentDate.addingTimeInterval(100)
        return UVData(
            items: [
                UVItem(
                    timestamp: currentDate,
                    updateTimestamp: updateTimestamp,
                    records: [
                        UVDataRecord(
                            value: .zero,
                            timestamp: currentDate
                        )
                    ]
                )
            ],
            apiInfo: .healthy
        )
    }()
}

extension HomeConstants {
    static var testing: HomeConstants {
        HomeConstants(
            loadBufferTime: .zero,
            loadOffset: 30.0
        )
    }
}
