import SwiftUI

struct QuizQuestion: Identifiable {
    let id = UUID()
    let options: [String]
    let correctAnswer: String?

    init(options: [String], correctAnswer: String? = nil) {
        self.options = options
        self.correctAnswer = correctAnswer
    }
}
