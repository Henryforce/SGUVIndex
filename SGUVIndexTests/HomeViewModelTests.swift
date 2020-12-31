//
//  HomeViewModelTests.swift
//  SGUVIndexTests
//
//  Created by Henry Javier Serrano Echeverria on 24/12/20.
//

import XCTest
import Combine
@testable import SGUVIndex

final class HomeViewModelTests: XCTestCase {

    private var weatherService: MockUVWeatherService!
    private var feedbackGenerator: MockFeedbackGenerator!
    private var sut: HomeViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        weatherService = MockUVWeatherService()
        feedbackGenerator = MockFeedbackGenerator()
        sut = HomeViewModel(
            with: weatherService,
            feedbackGenerator: feedbackGenerator,
            constants: .testing
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        weatherService = nil
        feedbackGenerator = nil
    }

    func testWeatherServiceWithValidDataReturnsAValidDataUIStateWhenScrollReachesThreshold() throws {
        // Given
        let itemsExpectation = expectation(description: "UVItems Expectation")
        var items: [UVWidgetData]?
        
        // When
        sut.$uiState
            .dropFirst()
            .sink(receiveValue: { result in
                guard case .validData(let uvItems) = result else { return }
                items = uvItems
                itemsExpectation.fulfill()
            }).store(in: &cancellables)
        sut.scrollWasUpdated(with: HomeConstants.testing.loadOffset)
        
        // Then
        wait(for: [itemsExpectation], timeout: 0.005)
        XCTAssertFalse(items!.isEmpty)
        XCTAssertEqual(feedbackGenerator.selectionChangedWasCalledCount, 1)
        XCTAssertEqual(feedbackGenerator.notificationOccurredWasCalledCount, 1)
        XCTAssertEqual(feedbackGenerator.notificationOccurredValue!, .success)
    }
    
    func testWeatherServiceWithOutdatedDataReturnsAnErrorUIStateWhenScrollReachesThreshold() throws {
        // Given
        weatherService.data = .dataYesterday // outdated, it should be data from today
        let itemsExpectation = expectation(description: "UVItems Expectation")
        
        // When
        sut.$uiState
            .dropFirst()
            .sink(receiveValue: { result in
                guard case .error = result else { return }
                itemsExpectation.fulfill()
            }).store(in: &cancellables)
        sut.scrollWasUpdated(with: HomeConstants.testing.loadOffset)
        
        // Then
        wait(for: [itemsExpectation], timeout: 0.005)
        XCTAssertEqual(feedbackGenerator.selectionChangedWasCalledCount, 1)
        XCTAssertEqual(feedbackGenerator.notificationOccurredWasCalledCount, 1)
        XCTAssertEqual(feedbackGenerator.notificationOccurredValue!, .error)
    }

}
