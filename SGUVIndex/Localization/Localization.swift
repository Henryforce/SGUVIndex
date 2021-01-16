//
//  Localization.swift
//  StaticWidgetExtension
//
//  Created by Henry Javier Serrano Echeverria on 30/12/20.
//

import Foundation

enum LocalizationKey: String {
    
    case singapore = "singapore_title"
    case uvLevels = "uv_levels"
    case uv = "uv_title"
    case lastUpdated = "last_updated_title"
    
    case dataGovSGOutdatedMessage = "data_gov_sg_outdated"
    case dataGovSGErrorMessage = "data_gov_sg_error"
    case unknownErrorMessage = "unknown_error_message"
    case disclaimerMessage = "disclaimer_message"
    
    case uvLow = "uv_low"
    case uvModerate = "uv_moderate"
    case uvHigh = "uv_high"
    case uvVeryHigh = "uv_very_high"
    case uvExtreme = "uv_extreme"
    
}

struct Localization {
    static func localize(_ key: LocalizationKey, bundle: Bundle = Bundle.main) -> String {
        NSLocalizedString(key.rawValue, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
