//
//  SGWeatherApp.swift
//  SGWeather
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import SwiftUI
import Combine

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    var viewModel: HomeViewModel!
    var weatherService: UVWeatherService!
    var feedbackGenerator: HapticFeedbackGenerator!
    var userDefaultsManager: UserDefaultsManager!
    var colorScheme: ColorScheme?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        if CommandLine.arguments.contains("-app_snapshot") {
            weatherService = SnapshotMockUVWeatherService()
        } else {
            weatherService = StandardUVWeatherService()
        }
        feedbackGenerator = StandardHapticFeedbackGenerator()
        userDefaultsManager = StandardUserDefaultsManager()
        
        viewModel = HomeViewModel(
            with: weatherService,
            feedbackGenerator: feedbackGenerator,
            userDefaults: userDefaultsManager,
            constants: .standard
        )
        
        loadColorScheme()
        
        return true
    }
    
    private func loadColorScheme() {
        if CommandLine.arguments.contains("-lightMode") {
            colorScheme = .light
        } else if CommandLine.arguments.contains("-darkMode") {
            colorScheme = .dark
        }
    }
}

@main
struct SGWeatherApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(with: appDelegate.viewModel, constants: .standard)
                .edgesIgnoringSafeArea(.all)
                .modifier(ColorSchemeModifier(colorScheme: appDelegate.colorScheme))
        }
    }
}

struct ColorSchemeModifier: ViewModifier {
    
    let colorScheme: ColorScheme?
    
    func body(content: Content) -> some View {
        Group {
            if let colorScheme = colorScheme {
                content
                    .environment(\.colorScheme, colorScheme)
            } else {
                content
            }
        }
    }
}
