//
//  UVIndex.swift
//  SGWeatherData
//
//  Created by Henry Javier Serrano Echeverria on 4/10/20.
//

import UIKit

public enum UVIndex {
    case low(Int)
    case moderate(Int)
    case high(Int)
    case veryHigh(Int)
    case extreme(Int)
    
    public init?(from value: Int) {
        guard value >= 0 else { return nil }
        switch value {
        case 0...2: self = .low(value)
        case 3...5: self = .moderate(value)
        case 6...7: self = .high(value)
        case 8...10: self = .veryHigh(value)
        default: self = .extreme(value)
        }
    }
    
    public func color() -> UIColor {
        switch self {
        case .low: return .green
        case .moderate: return .yellow
        case .high: return .orange
        case .veryHigh: return .red
        case .extreme: return .purple
        }
    }
    
    public func name() -> String {
        switch self {
        case .low: return "Low"
        case .moderate: return "Moderate"
        case .high: return "High"
        case .veryHigh: return "Very High"
        case .extreme: return "Extreme"
        }
    }
    
    public func index() -> Int {
        switch self {
        case .low(let value), .moderate(let value), .high(let value), .veryHigh(let value), .extreme(let value):
            return value
        }
    }
}
