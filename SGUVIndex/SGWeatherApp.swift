//
//  SGWeatherApp.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    var viewModel: HomeViewModel!
    var weatherService: UVWeatherService!
    var feedbackGenerator: HapticFeedbackGenerator!
    var userDefaultsManager: UserDefaultsManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        weatherService = StandardUVWeatherService()
        feedbackGenerator = StandardHapticFeedbackGenerator()
        userDefaultsManager = StandardUserDefaultsManager()
        
        viewModel = HomeViewModel(
            with: weatherService,
            feedbackGenerator: feedbackGenerator,
            userDefaults: userDefaultsManager,
            constants: .standard
        )
        
        return true
    }
}

@main
struct SGWeatherApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(with: appDelegate.viewModel, constants: .standard)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
