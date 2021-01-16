//
//  AppStoreSnapshotUITests.swift
//  SGUVIndexUITests
//
//  Created by Henry Javier Serrano Echeverria on 16/1/21.
//

import SwiftUI
import Combine
import SGUVIndex
import XCTest

class AppStoreSnapshotUITests: XCTestCase {
    
    func testExample() throws {
        let app = XCUIApplication()
        
        setupSnapshot(app)
        
        app.launch()
        
        _ = app.textViews["Disclaimer"].waitForExistence(timeout: 1.0)
        
        snapshot("01UserEntries")
    }
    
//    func testView() {
//        XCUIApplication().launch()
////        let storyboard = UIStoryboard(name: "MainStoryboard", bundle: Bundle.mainBundle())
////        let controller = storyboard.instantiateViewControllerWithIdentifier("LanguageSelectController")
//        let constants = HomeConstants.standard
//        let homeViewModel = HomeViewModel(
//            with: MockUVWeatherService(),
//            feedbackGenerator: MockHapticFeedbackGenerator(),
//            userDefaults: MockUserDefaults(),
//            constants: constants)
//        let viewController = UIHostingController(
//            rootView: ContentView(
//                with: homeViewModel,
//                constants: constants
//            )
//        )
//        UIApplication.shared.keyWindow?.rootViewController = viewController
//    }
//    
//    final class MockUVWeatherService: UVWeatherService {
//        func fetchUV() -> AnyPublisher<UVData, Error> {
//            Just(
//                UVData(
//                    items: [
//                        
//                    ],
//                    apiInfo: APIInfo(status: "ACTIVE")
//                )
//            )
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//        }
//    }
//    
//    final class MockHapticFeedbackGenerator: HapticFeedbackGenerator {
//        func generate(_ event: HapticEvent) { }
//    }
//    
//    final class MockUserDefaults: UserDefaultsManager {
//        func object(forKey defaultName: String) -> Any? { nil }
//        
//        func set(_ value: Any?, forKey defaultName: String) { }
//        
//        func removeObject(forKey defaultName: String) { }
//    }

}
