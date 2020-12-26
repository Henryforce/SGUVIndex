//
//  FeedbackGenerator.swift
//  SGUVIndex
//
//  Created by Henry Javier Serrano Echeverria on 26/12/20.
//

import UIKit

protocol FeedbackGenerator {
    func generate(when feedbackType: UINotificationFeedbackGenerator.FeedbackType)
}

final class StandardFeedbackGenerator: FeedbackGenerator {
    private let generator: UINotificationFeedbackGenerator
    
    init(generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()) {
        self.generator = generator
    }
    
    func generate(when feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(feedbackType)
    }
}
