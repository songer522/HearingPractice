import Foundation

struct QuizResult: Identifiable, Codable {
    let id: UUID
    let date: Date
    let categoryName: String
    let numberOfQuestions: Int
    let numberOfOptions: Int
    let correctAnswers: Int
    let totalQuestions: Int
    let correctRate: Double // Percentage (0-100)
    let speechSpeed: String
    let environment: String
    
    init(date: Date = Date(),
         categoryName: String,
         numberOfQuestions: Int,
         numberOfOptions: Int,
         correctAnswers: Int,
         totalQuestions: Int,
         speechSpeed: String,
         environment: String) {
        self.id = UUID()
        self.date = date
        self.categoryName = categoryName
        self.numberOfQuestions = numberOfQuestions
        self.numberOfOptions = numberOfOptions
        self.correctAnswers = correctAnswers
        self.totalQuestions = totalQuestions
        self.correctRate = totalQuestions > 0 ? (Double(correctAnswers) / Double(totalQuestions)) * 100 : 0
        self.speechSpeed = speechSpeed
        self.environment = environment
    }
}

// Manager to handle saving and loading results
class QuizResultsManager: ObservableObject {
    @Published var results: [QuizResult] = []
    
    private let saveKey = "SavedQuizResults"
    
    init() {
        loadResults()
    }
    
    func saveResult(_ result: QuizResult) {
        results.insert(result, at: 0) // Add to beginning so newest is first
        saveResults()
    }
    
    func deleteResult(_ result: QuizResult) {
        results.removeAll { $0.id == result.id }
        saveResults()
    }
    
    func clearAllResults() {
        results.removeAll()
        saveResults()
    }
    
    private func saveResults() {
        if let encoded = try? JSONEncoder().encode(results) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadResults() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([QuizResult].self, from: data) {
            results = decoded
        }
    }
}
