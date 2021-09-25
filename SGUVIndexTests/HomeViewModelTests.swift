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
    private var userDefaults: MockUserDefaultsManager!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() async throws {
        weatherService = MockUVWeatherService()
        feedbackGenerator = MockFeedbackGenerator()
        userDefaults = MockUserDefaultsManager()
        sut = await HomeViewModel(
            with: weatherService,
            feedbackGenerator: feedbackGenerator,
            userDefaults: userDefaults,
            constants: .testing
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        weatherService = nil
        feedbackGenerator = nil
        userDefaults = nil
    }
    
    func testWeatherServiceWithValidDataReturnsAValidDataUIStateWhenViewDidAppearIsCalledOnlyFirstTime() async throws {
        // Given
        var items: [UVWidgetData]?
        
        // When
        await sut.$uiState
            .dropFirst()
            .sink(receiveValue: { result in
                guard case .validData(let uvItems) = result else { return }
                items = uvItems
            }).store(in: &cancellables)
        await sut.viewDidAppear()
        await sut.viewDidAppear() // Will do nothing
        await sut.viewDidAppear() // Will do nothing
        
        // Then
        XCTAssertFalse(items!.isEmpty)
        XCTAssertEqual(weatherService.fetchUVWasCalledCount, 1)
        XCTAssertEqual(feedbackGenerator.generateEventWasCalledCount, 2)
        XCTAssertEqual(feedbackGenerator.generateEventValueStack.first!, HapticEvent.selectionChanged)
        XCTAssertEqual(feedbackGenerator.generateEventValueStack[1], HapticEvent.successNotification)
        XCTAssertEqual(userDefaults.setValueForKeyWasCalledCount, 1)
        XCTAssertEqual(userDefaults.setValueForKeyDefaultName!, UserDefaultsKeys.lastUVDataUpdated.rawValue)
    }

    func testWeatherServiceWithValidDataReturnsAValidDataUIStateWhenScrollReachesThreshold() async throws {
        // Given
        var items: [UVWidgetData]?
        
        // When
        await sut.$uiState
            .dropFirst()
            .sink(receiveValue: { result in
                guard case .validData(let uvItems) = result else { return }
                items = uvItems
            }).store(in: &cancellables)
        await sut.scrollWasUpdated(with: HomeConstants.testing.loadOffset)
        
        // Then
        XCTAssertFalse(items!.isEmpty)
        XCTAssertEqual(weatherService.fetchUVWasCalledCount, 1)
        XCTAssertEqual(feedbackGenerator.generateEventWasCalledCount, 2)
        XCTAssertEqual(feedbackGenerator.generateEventValueStack.first!, HapticEvent.selectionChanged)
        XCTAssertEqual(feedbackGenerator.generateEventValueStack[1], HapticEvent.successNotification)
        XCTAssertEqual(userDefaults.setValueForKeyWasCalledCount, 1)
        XCTAssertEqual(userDefaults.setValueForKeyDefaultName!, UserDefaultsKeys.lastUVDataUpdated.rawValue)
    }
    
    func testWeatherServiceWithOutdatedDataReturnsAnErrorUIStateWhenScrollReachesThreshold() async throws {
        // Given
        weatherService.data = .dataYesterday // outdated, it should be data from today
        
        // When
        await sut.$uiState
            .dropFirst()
            .sink(receiveValue: { result in
                guard case .error = result else { return }
            }).store(in: &cancellables)
        await sut.scrollWasUpdated(with: HomeConstants.testing.loadOffset)
        
        // Then
        XCTAssertEqual(weatherService.fetchUVWasCalledCount, 1)
        XCTAssertEqual(feedbackGenerator.generateEventWasCalledCount, 2)
        XCTAssertEqual(feedbackGenerator.generateEventValueStack.first!, HapticEvent.selectionChanged)
        XCTAssertEqual(feedbackGenerator.generateEventValueStack[1], HapticEvent.errorNotification)
        XCTAssertEqual(userDefaults.setValueForKeyWasCalledCount, .zero)
        XCTAssertNil(userDefaults.setValueForKeyDefaultName)
    }

}
