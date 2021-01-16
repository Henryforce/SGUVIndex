//
//  UserDefaultsManager.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 31/12/20.
//

import Foundation

public protocol UserDefaultsManager {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
    func removeObject(forKey defaultName: String)
}

final class StandardUserDefaultsManager: UserDefaultsManager {
    
    private let userDefaults: UserDefaults
    private static let appGroupName = "group.com.henryforce.sguvindex"
    
    init(
        userDefaults: UserDefaults
    ) {
        self.userDefaults = userDefaults
    }
    
    convenience init(suiteName: String = appGroupName) {
        self.init(userDefaults: UserDefaults.init(suiteName: suiteName)!)
    }
    
    func object(forKey defaultName: String) -> Any? {
        userDefaults.object(forKey: defaultName)
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
    }
    
    func removeObject(forKey defaultName: String) {
        userDefaults.removeObject(forKey: defaultName)
    }
    
}

enum UserDefaultsKeys: String {
    case lastUVDataUpdated = "LastUVDataUpdated"
}
