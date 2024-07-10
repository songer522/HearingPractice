import SwiftUI

struct QuizQuestion: Identifiable {
    let id = UUID()
    let options: [String]
}
