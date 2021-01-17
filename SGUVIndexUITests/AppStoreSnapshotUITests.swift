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
    
    func testGenerateFastlaneSnapshotsInLightMode() throws {
        let app = XCUIApplication()
        
        // Launch arguments are being setup here as well:
        setupSnapshot(app)
        app.launchArguments.append("-lightMode") // Append instead of replace
        app.launch()
        
        _ = app.textViews["Disclaimer"].waitForExistence(timeout: 1.0)
        
        snapshot("MainLight")
    }
    
    func testGenerateFastlaneSnapshotsInDarkMode() throws {
        let app = XCUIApplication()

        setupSnapshot(app)
        app.launchArguments.append("-darkMode") // Append instead of replace
        app.launch()

        _ = app.textViews["Disclaimer"].waitForExistence(timeout: 1.0)

        snapshot("MainDark")
    }

}
