//
//  FeedbackGenerator.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 26/12/20.
//

import UIKit

public enum HapticEvent: Equatable {
    case impact(CGFloat?)
    case selectionChanged
    case successNotification
    case warningNotification
    case errorNotification
}

public protocol HapticFeedbackGenerator {
    func generate(_ event: HapticEvent)
}

final class StandardHapticFeedbackGenerator: HapticFeedbackGenerator {
    private let impactFeedbackGenerator: UIImpactFeedbackGenerator
    private let selectionFeedbackGenerator: UISelectionFeedbackGenerator
    private let notificationFeedbackGenerator: UINotificationFeedbackGenerator
    
    init(
        impactFeedbackGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(),
        selectionFeedbackGenerator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator(),
        notificationFeedbackGenerator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    ) {
        self.impactFeedbackGenerator = impactFeedbackGenerator
        self.selectionFeedbackGenerator = selectionFeedbackGenerator
        self.notificationFeedbackGenerator = notificationFeedbackGenerator
    }
    
    func generate(_ event: HapticEvent) {
        switch event {
        case .impact(let intensity):
            if let intensity = intensity {
                impactFeedbackGenerator.impactOccurred(intensity: intensity)
            } else {
                impactFeedbackGenerator.impactOccurred()
            }
        case .selectionChanged:
            selectionFeedbackGenerator.selectionChanged()
        case .successNotification:
            notificationFeedbackGenerator.notificationOccurred(.success)
        case .warningNotification:
            notificationFeedbackGenerator.notificationOccurred(.warning)
        case .errorNotification:
            notificationFeedbackGenerator.notificationOccurred(.error)
        }
    }
}
