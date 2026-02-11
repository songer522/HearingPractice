import SwiftUI

enum SpeechSpeed: String, CaseIterable {
    case slow = "Slow"
    case normal = "Normal"
    case fast = "Fast"
    
    var rate: Float {
        switch self {
        case .slow: return 0.35
        case .normal: return 0.45
        case .fast: return 0.55
        }
    }
}

enum ListeningEnvironment: String, CaseIterable {
    case quiet = "Quiet"
    case backgroundNoise = "Background Noise"
}

struct RandomAudioExerciseView: View {
    @State private var questions: [QuizQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showAlert = false
    @State private var score = 0
    @State private var lastPlayedPhrase: String?
    @State private var backgroundColor = Color(UIColor.systemBackground)
    @State private var correctAnswer: String?
    @State private var isAnswerLocked = false
    
    @ObservedObject private var audioPlayer = AudioPlayer()

    // New state variable to hold the selected category
    @State private var selectedCategory: Category = .food
    
    // Configurable number of options per question
    @State private var numberOfOptions: Int = 4
    
    // Configurable speech speed
    @State private var speechSpeed: SpeechSpeed = .normal
    
    // Configurable number of questions
    @State private var numberOfQuestions: Int = 25
    
    // Configurable environment
    @State private var environment: ListeningEnvironment = .quiet
    
    // State to control settings sheet
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    if currentQuestionIndex < questions.count {
                        let currentQuestion = questions[currentQuestionIndex]
                        
                        Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                            .font(.title2)
                            .padding()

                        Button(action: {
                            playPhrase(from: currentQuestion)
                        }) {
                            HStack {
                                Image(systemName: "play.circle.fill")
                                    .font(.title)
                                Text("Play Phrase")
                            }
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding()

                        FlowLayout(spacing: 10) {
                            ForEach(currentQuestion.options, id: \.self) { option in
                                Button(action: {
                                    if !isAnswerLocked {
                                        selectedAnswer = option
                                        checkAnswer(for: currentQuestion, selectedOption: option)
                                    }
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
                                .disabled(isAnswerLocked)
                                .opacity(isAnswerLocked ? 0.6 : 1.0)
                            }
                        }
                        .padding(.horizontal)
                        
                        if let correctAnswer = correctAnswer, selectedAnswer != correctAnswer {
                            VStack(spacing: 15) {
                                Text("Correct Answer: \(correctAnswer)")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                    .padding(.top, 20)
                                
                                HStack(spacing: 20) {
                                    Button(action: {
                                        repeatCorrectAnswer()
                                    }) {
                                        HStack {
                                            Image(systemName: "speaker.wave.2.fill")
                                            Text("Repeat Answer")
                                        }
                                        .font(.title3)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
                                    
                                    Button(action: {
                                        nextQuestion()
                                    }) {
                                        HStack {
                                            Text("Next Question")
                                            Image(systemName: "arrow.right")
                                        }
                                        .font(.title3)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                        
                        // Show current score and correct rate
                        if currentQuestionIndex > 0 {
                            let percentage = Int((Double(score) / Double(currentQuestionIndex)) * 100)
                            Text("\(score) of \(currentQuestionIndex), \(percentage)% correct")
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .padding(.top, 20)
                                .padding(.bottom, 20)
                        }
                    } else {
                        VStack(spacing: 20) {
                            Text("Quiz Completed")
                                .font(.largeTitle)
                                .padding()
                            Text("Your Score: \(score) / \(questions.count)")
                                .font(.title)
                                .padding()
                            
                            let percentage = questions.count > 0 ? Int((Double(score) / Double(questions.count)) * 100) : 0
                            Text("\(percentage)% Correct")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
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
                        .padding(.top, 40)
                    }
                }
                .padding()
            }
            .onAppear(perform: loadQuestions)
            .animation(.easeInOut, value: backgroundColor)
            }
            .navigationTitle(selectedCategory.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        resetQuiz()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gear")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                RandomQuizSettingsView(selectedCategory: $selectedCategory, numberOfOptions: $numberOfOptions, speechSpeed: $speechSpeed, numberOfQuestions: $numberOfQuestions, environment: $environment)
            }
            .onChange(of: selectedCategory) { _ in
                resetQuiz()
            }
            .onChange(of: numberOfOptions) { _ in
                resetQuiz()
            }
            .onChange(of: numberOfQuestions) { _ in
                resetQuiz()
            }
        }
    }

    // Load questions from a string array
    func loadQuestions(from items: [String]) {
        var generatedQuestions = [QuizQuestion]()
        
        // Calculate maximum possible questions with unique words
        let maxPossibleQuestions = items.count / numberOfOptions
        let actualQuestions = min(numberOfQuestions, maxPossibleQuestions)
        
        // If we can't create enough questions, allow word reuse across questions
        if actualQuestions < numberOfQuestions {
            // Allow word reuse - each question has unique options, but words can repeat across questions
            for _ in 1...numberOfQuestions {
                var options = [String]()
                var usedInQuestion = Set<String>()
                
                while options.count < numberOfOptions {
                    if let randomWord = items.randomElement(), !usedInQuestion.contains(randomWord) {
                        options.append(randomWord)
                        usedInQuestion.insert(randomWord)
                    }
                }
                generatedQuestions.append(QuizQuestion(options: options.shuffled()))
            }
        } else {
            // Original logic - use unique words across all questions
            var usedWords = Set<String>()
            
            for _ in 1...numberOfQuestions {
                var options = [String]()
                while options.count < numberOfOptions {
                    if let randomWord = items.randomElement(), !usedWords.contains(randomWord) {
                        options.append(randomWord)
                        usedWords.insert(randomWord)
                    }
                }
                generatedQuestions.append(QuizQuestion(options: options.shuffled()))
            }
        }

        questions = generatedQuestions
    }

    // Load questions from a QuizQuestion array
    func loadQuestions(from quizQuestions: [QuizQuestion]) {
        // Shuffle the questions and take only the number needed
        let shuffledQuestions = quizQuestions.shuffled()
        questions = Array(shuffledQuestions.prefix(numberOfQuestions))
    }

    func loadQuestions() {
        switch selectedCategory {
        case .food:
            loadQuestions(from: foodItems)
        case .animals:
            loadQuestions(from: animalItems)
        case .disney:
            loadQuestions(from: disneyItems)
        case .phrases:
            loadQuestions(from: phrases)
        case .initialConsonants:
            // Randomly pick one consonant group for the entire quiz
            if let randomGroup = initialConsonantsGroups.randomElement() {
                loadQuestions(from: randomGroup)
            }
        case .medialVowels:
            // Randomly pick one vowel group for the entire quiz
            if let randomGroup = medialVowelsGroups.randomElement() {
                loadQuestions(from: randomGroup)
            }
        case .finalConsonants:
            // Randomly pick one ending consonant group for the entire quiz
            if let randomGroup = finalConsonantsGroups.randomElement() {
                loadQuestions(from: randomGroup)
            }
        case .colors:
            loadQuestions(from: colorsAndShapes)
        case .actions:
            loadQuestions(from: actionWords)
        case .places:
            loadQuestions(from: places)
        case .everyday:
            loadQuestions(from: everydayObjects)
        case .nature:
            loadQuestions(from: natureAndWeather)
        }
    }

    func playPhrase(from question: QuizQuestion) {
        if lastPlayedPhrase == nil {
            lastPlayedPhrase = question.options.randomElement()
        }
        if let phrase = lastPlayedPhrase {
            // Start background noise if environment is set to background noise
            if environment == .backgroundNoise {
                audioPlayer.startBackgroundNoise()
            }
            
            audioPlayer.speak(text: phrase, language: "en-US", rate: speechSpeed.rate)
            
            // Stop background noise after speech (delayed by estimated speech duration)
            if environment == .backgroundNoise {
                let estimatedDuration = Double(phrase.count) / Double(speechSpeed.rate) / 10.0
                DispatchQueue.main.asyncAfter(deadline: .now() + estimatedDuration + 1.0) {
                    self.audioPlayer.stopBackgroundNoise()
                }
            }
        }
    }

    func checkAnswer(for question: QuizQuestion, selectedOption: String) {
        if selectedOption == lastPlayedPhrase {
            score += 1
            backgroundColor = Color.green
            isAnswerLocked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.nextQuestion()
                self.backgroundColor = Color(UIColor.systemBackground)
            }
        } else {
            backgroundColor = Color.red
            correctAnswer = lastPlayedPhrase
            isAnswerLocked = true
            // Don't auto-advance - let user control when to move on
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.backgroundColor = Color(UIColor.systemBackground)
            }
        }
    }
    
    func repeatCorrectAnswer() {
        if let answer = correctAnswer {
            audioPlayer.speak(text: answer, language: "en-US", rate: speechSpeed.rate)
        }
    }

    func nextQuestion() {
        selectedAnswer = nil
        lastPlayedPhrase = nil
        correctAnswer = nil
        isAnswerLocked = false
        currentQuestionIndex += 1
    }

    func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        lastPlayedPhrase = nil
        correctAnswer = nil
        isAnswerLocked = false
        backgroundColor = Color(UIColor.systemBackground)
        loadQuestions()
    }
}

// MARK: - Flow Layout for flexible button arrangement
struct FlowLayout: Layout {
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var rows: [[Int]] = [[]]
            var rowWidths: [CGFloat] = [0]
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            var currentRow = 0
            
            // Initialize positions array with correct size
            var tempPositions: [CGPoint] = Array(repeating: .zero, count: subviews.count)
            
            // First pass: organize subviews into rows and calculate row widths
            for (index, subview) in subviews.enumerated() {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    // Move to next line
                    currentRow += 1
                    rows.append([])
                    rowWidths.append(0)
                    x = 0
                }
                
                rows[currentRow].append(index)
                rowWidths[currentRow] = x + size.width
                x += size.width + spacing
            }
            
            // Second pass: position subviews with centering
            y = 0
            for (rowIndex, row) in rows.enumerated() {
                let rowWidth = rowWidths[rowIndex]
                let offset = (maxWidth - rowWidth) / 2
                x = offset
                lineHeight = 0
                
                for subviewIndex in row {
                    let subview = subviews[subviewIndex]
                    let size = subview.sizeThatFits(.unspecified)
                    
                    tempPositions[subviewIndex] = CGPoint(x: x, y: y)
                    lineHeight = max(lineHeight, size.height)
                    x += size.width + spacing
                }
                
                y += lineHeight + spacing
            }
            
            // Adjust final height (remove extra spacing)
            if !rows.isEmpty {
                y -= spacing
            }
            
            self.positions = tempPositions
            self.size = CGSize(width: maxWidth, height: y)
        }
    }
}

#Preview {
    RandomAudioExerciseView()
}
