//
//  MockUserDefaultsManager.swift
//  SGUVIndexTests
//
//  Created by Henry Javier Serrano Echeverria on 31/12/20.
//

import Foundation
@testable import SGUVIndex

final class MockUserDefaultsManager: UserDefaultsManager {
    var objectForKeyWasCalledCount = 0
    var objectForKeyDefaultName: String?
    var objectForKeyValue: Any?
    func object(forKey defaultName: String) -> Any? {
        objectForKeyWasCalledCount += 1
        objectForKeyDefaultName = defaultName
        return objectForKeyValue
    }
    
    var setValueForKeyWasCalledCount = 0
    var setValueForKeyDefaultName: String?
    func set(_ value: Any?, forKey defaultName: String) {
        setValueForKeyWasCalledCount += 1
        setValueForKeyDefaultName = defaultName
    }
    
    var removeObjectWasCalledCount = 0
    var removeObjectDefaultName: String?
    func removeObject(forKey defaultName: String) {
        removeObjectWasCalledCount += 1
        removeObjectDefaultName = defaultName
    }
}
