//
//  FeedbackGenerator.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 26/12/20.
//

import UIKit

protocol FeedbackGenerator {
    func impactOcurred()
    func impactOccurred(intensity: CGFloat)
    func selectionChanged()
    func notificationOccurred(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType)
}

final class StandardFeedbackGenerator: FeedbackGenerator {
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
    
    func impactOcurred() {
        impactFeedbackGenerator.impactOccurred()
    }
    
    func impactOccurred(intensity: CGFloat) {
        impactFeedbackGenerator.impactOccurred(intensity: intensity)
    }
    
    func selectionChanged() {
        selectionFeedbackGenerator.selectionChanged()
    }
    
    func notificationOccurred(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedbackGenerator.notificationOccurred(feedbackType)
    }
}
