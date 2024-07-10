import SwiftUI

struct RandomAudioExerciseView: View {
    @State private var questions: [QuizQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showAlert = false
    @State private var score = 0
    @State private var lastPlayedPhrase: String?
    @State private var backgroundColor = Color(UIColor.systemBackground)
    @State private var correctAnswer: String?
    
    @ObservedObject private var audioPlayer = AudioPlayer()

    // New state variable to hold the selected category
    @State private var selectedCategory: Category = .food

    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Picker to select the category
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: selectedCategory) { _ in
                    resetQuiz()
                }

                if currentQuestionIndex < questions.count {
                    let currentQuestion = questions[currentQuestionIndex]
                    
                    Text("Question \(currentQuestionIndex + 1)")
                        .font(.largeTitle)
                        .padding()

                    Button(action: {
                        playPhrase(from: currentQuestion)
                    }) {
                        Text("Play Phrase")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    ForEach(currentQuestion.options, id: \.self) { option in
                        Button(action: {
                            selectedAnswer = option
                            checkAnswer(for: currentQuestion, selectedOption: option)
                        }) {
                            Text(option)
                                .font(.title2)
                                .padding()
                                .background(selectedAnswer == option ? Color.gray : Color(UIColor.systemBackground))
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                        }
                        .padding(.vertical, 5)
                    }
                    
                    if let correctAnswer = correctAnswer, selectedAnswer != correctAnswer {
                        Text("Correct Answer: \(correctAnswer)")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding(.top, 20)
                    }

                    Spacer()
                } else {
                    Text("Quiz Completed")
                        .font(.largeTitle)
                        .padding()
                    Text("Your Score: \(score) / \(questions.count)")
                        .font(.title)
                        .padding()
                    Button(action: {
                        resetQuiz()
                    }) {
                        Text("Restart Quiz")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .padding()
            .onAppear(perform: loadQuestions)
            .animation(.easeInOut, value: backgroundColor)
        }
    }

    func loadQuestions() {
        var items: [String]

        switch selectedCategory {
        case .food:
            items = foodItems
        case .animals:
            items = animalItems
        case .disney:
            items = disneyItems
        }

        var generatedQuestions = [QuizQuestion]()
        var usedWords = Set<String>()

        for _ in 1...25 {
            var options = [String]()
            while options.count < 4 {
                if let randomWord = items.randomElement(), !usedWords.contains(randomWord) {
                    options.append(randomWord)
                    usedWords.insert(randomWord)
                }
            }
            generatedQuestions.append(QuizQuestion(options: options.shuffled()))
        }

        questions = generatedQuestions
    }

    func playPhrase(from question: QuizQuestion) {
        if lastPlayedPhrase == nil {
            lastPlayedPhrase = question.options.randomElement()
        }
        if let phrase = lastPlayedPhrase {
            audioPlayer.speak(text: phrase, language: "en-US")
        }
    }

    func checkAnswer(for question: QuizQuestion, selectedOption: String) {
        if selectedOption == lastPlayedPhrase {
            score += 1
            backgroundColor = Color.green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.nextQuestion()
                self.backgroundColor = Color(UIColor.systemBackground)
            }
        } else {
            backgroundColor = Color.red
            correctAnswer = lastPlayedPhrase
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.nextQuestion()
                self.backgroundColor = Color(UIColor.systemBackground)
            }
        }
    }

    func nextQuestion() {
        selectedAnswer = nil
        lastPlayedPhrase = nil
        correctAnswer = nil
        currentQuestionIndex += 1
    }

    func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        lastPlayedPhrase = nil
        backgroundColor = Color(UIColor.systemBackground)
        loadQuestions()
    }
}
