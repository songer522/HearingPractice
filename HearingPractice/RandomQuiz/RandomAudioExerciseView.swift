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
    @State private var showWrongAnswerSheet = false
    
    @ObservedObject private var audioPlayer = AudioPlayer()
    @ObservedObject private var resultsManager = QuizResultsManager()

    // New state variable to hold the selected category
    @State private var selectedCategory: Category = Category.allCases.randomElement() ?? .food
    
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
    
    // Dynamic scaling based on screen size (both width and height)
    private func scaleFactor(for size: CGSize) -> CGFloat {
        let width = size.width
        let height = size.height
        
        // iPhone portrait: ~390-430 width, ~800+ height
        // iPhone landscape: ~800+ width, ~390-430 height
        // iPad: both dimensions are large
        
        // If height is very limited (landscape mode), use conservative scaling
        if height < 500 {
            return 1.0 // Landscape on small devices - keep original size
        }
        
        // Otherwise scale based on width
        if width < 500 {
            return 1.0 // iPhone portrait
        } else if width < 700 {
            return 1.15 // iPad split view or small window
        } else if width < 900 {
            return 1.3 // iPad medium
        } else {
            return 1.5 // iPad full screen
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
            // Colorful gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.7, blue: 1.0),  // Light blue
                    Color(red: 0.6, green: 0.8, blue: 1.0),  // Lighter blue
                    Color(red: 0.9, green: 0.95, blue: 1.0)  // Very light blue
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Overlay background color for correct/wrong feedback
            backgroundColor
                .opacity(backgroundColor == Color(UIColor.systemBackground) ? 0 : 0.3)
                .edgesIgnoringSafeArea(.all)

            GeometryReader { geometry in
                let scale = scaleFactor(for: geometry.size)
                let shouldCenter = geometry.size.width >= 700 && geometry.size.height > 600
                let isLandscapeCompact = geometry.size.height < 500
                
                ScrollView {
                    VStack(spacing: 0) {
                        if shouldCenter {
                            Spacer(minLength: 0)
                        }
                    if currentQuestionIndex < questions.count {
                        let currentQuestion = questions[currentQuestionIndex]
                        
                        VStack(spacing: isLandscapeCompact ? 4 : 12 * scale) {
                            Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                                .font(.system(size: 28 * scale, weight: .semibold))
                                .foregroundColor(Color(UIColor.label))
                            
                            // Show current score and correct rate
                            if currentQuestionIndex > 0 {
                                let percentage = Int((Double(score) / Double(currentQuestionIndex)) * 100)
                                Text("\(score) of \(currentQuestionIndex), \(percentage)% correct")
                                    .font(.system(size: 22 * scale, weight: .medium))
                                    .foregroundColor(Color(UIColor.label))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, isLandscapeCompact ? 8 : 20)
                        .padding(.top, isLandscapeCompact ? 4 : 20 * scale)

                        Button(action: {
                            playPhrase(from: currentQuestion)
                        }) {
                            HStack(spacing: isLandscapeCompact ? 10 : 15 * scale) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: isLandscapeCompact ? 28 : 36 * scale))
                                Text("Play Phrase")
                                    .font(.system(size: isLandscapeCompact ? 20 : 28 * scale, weight: .semibold))
                            }
                            .padding(.horizontal, isLandscapeCompact ? 30 : 40 * scale)
                            .padding(.vertical, isLandscapeCompact ? 12 : 20 * scale)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(isLandscapeCompact ? 15 : 20 * scale)
                            .shadow(color: .purple.opacity(0.4), radius: isLandscapeCompact ? 6 : 10 * scale, x: 0, y: isLandscapeCompact ? 3 : 5 * scale)
                        }
                        .padding(.bottom, isLandscapeCompact ? 15 : 40 * scale)

                        FlowLayout(spacing: isLandscapeCompact ? 8 : 15 * scale) {
                            ForEach(currentQuestion.options, id: \.self) { option in
                                Button(action: {
                                    if !isAnswerLocked {
                                        selectedAnswer = option
                                        checkAnswer(for: currentQuestion, selectedOption: option)
                                    }
                                }) {
                                    Text(option)
                                        .font(.system(size: isLandscapeCompact ? 18 : 22 * scale, weight: .medium))
                                        .padding(.horizontal, isLandscapeCompact ? 16 : 20 * scale)
                                        .padding(.vertical, isLandscapeCompact ? 10 : 16 * scale)
                                        .background(
                                            selectedAnswer == option 
                                            ? Color.orange
                                            : Color(UIColor.systemBackground)
                                        )
                                        .foregroundColor(
                                            selectedAnswer == option 
                                            ? .white 
                                            : Color(UIColor.label)
                                        )
                                        .cornerRadius(15 * scale)
                                        .shadow(color: .black.opacity(0.2), radius: 5 * scale, x: 0, y: 3 * scale)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15 * scale)
                                                .stroke(
                                                    selectedAnswer == option ? Color.orange : Color.blue,
                                                    lineWidth: 3 * scale
                                                )
                                        )
                                }
                                .disabled(isAnswerLocked)
                                .opacity(isAnswerLocked ? 0.6 : 1.0)
                            }
                        }
                        .padding(.horizontal, isLandscapeCompact ? 20 : 30 * scale)
                        .padding(.bottom, isLandscapeCompact ? 20 : 60 * scale)
                    } else {
                        VStack(spacing: 20 * scale) {
                            Text("Quiz Completed")
                                .font(.system(size: 34 * scale, weight: .bold))
                                .foregroundColor(Color(UIColor.label))
                                .padding()
                            Text("Your Score: \(score) / \(questions.count)")
                                .font(.system(size: 28 * scale, weight: .semibold))
                                .foregroundColor(Color(UIColor.label))
                                .padding()
                            
                            let percentage = questions.count > 0 ? Int((Double(score) / Double(questions.count)) * 100) : 0
                            Text("\(percentage)% Correct")
                                .font(.system(size: 22 * scale, weight: .medium))
                                .foregroundColor(Color(UIColor.label))
                            
                            Button(action: {
                                resetQuiz()
                            }) {
                                Text("Restart Quiz")
                                    .font(.system(size: 28 * scale, weight: .semibold))
                                    .padding(.horizontal, 40 * scale)
                                    .padding(.vertical, 20 * scale)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(15 * scale)
                            }
                            .padding()
                        }
                        .padding(.top, 40 * scale)
                    }
                    
                    if shouldCenter {
                        Spacer(minLength: 0)
                    }
                }
                .frame(minHeight: shouldCenter ? geometry.size.height : nil)
                .frame(maxWidth: .infinity)
                .padding()
                }
            }
            .onAppear(perform: loadQuestions)
            .onChange(of: currentQuestionIndex) { newIndex in
                // Save result when quiz is completed
                if newIndex >= questions.count && questions.count > 0 {
                    saveQuizResult()
                }
            }
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
                RandomQuizSettingsView(selectedCategory: $selectedCategory, numberOfOptions: $numberOfOptions, speechSpeed: $speechSpeed, numberOfQuestions: $numberOfQuestions, environment: $environment, resultsManager: resultsManager)
                    .presentationDetents([.large])
                    .presentationBackgroundInteraction(.disabled)
            }
            .sheet(isPresented: $showWrongAnswerSheet, onDismiss: {
                // Ensure we move to next question when sheet is dismissed
                // Only call if we haven't already advanced (check if correctAnswer is still set)
                if correctAnswer != nil {
                    nextQuestion()
                }
            }) {
                WrongAnswerFeedbackView(
                    correctAnswer: correctAnswer ?? "",
                    onRepeat: {
                        repeatCorrectAnswer()
                    },
                    onNext: {
                        showWrongAnswerSheet = false
                        // nextQuestion() will be called in onDismiss
                    }
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
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
        .navigationViewStyle(.stack)
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
        let selectedQuestions = Array(shuffledQuestions.prefix(numberOfQuestions))
        
        // Adjust the number of options for each question if needed
        var adjustedQuestions: [QuizQuestion] = []
        for question in selectedQuestions {
            if question.options.count >= numberOfOptions {
                // If question has enough options, randomly select the required number
                let selectedOptions = Array(question.options.shuffled().prefix(numberOfOptions))
                adjustedQuestions.append(QuizQuestion(options: selectedOptions))
            } else {
                // If not enough options, use all available options
                adjustedQuestions.append(question)
            }
        }
        
        questions = adjustedQuestions
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
        // Ensure we have a correct answer set (in case user didn't play the phrase)
        if lastPlayedPhrase == nil {
            lastPlayedPhrase = question.options.randomElement()
        }
        
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
            // Show the wrong answer feedback sheet
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.backgroundColor = Color(UIColor.systemBackground)
                self.showWrongAnswerSheet = true
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
    
    func saveQuizResult() {
        let result = QuizResult(
            categoryName: selectedCategory.rawValue,
            numberOfQuestions: numberOfQuestions,
            numberOfOptions: numberOfOptions,
            correctAnswers: score,
            totalQuestions: questions.count,
            speechSpeed: speechSpeed.rawValue,
            environment: environment.rawValue
        )
        resultsManager.saveResult(result)
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

// MARK: - Wrong Answer Feedback View
struct WrongAnswerFeedbackView: View {
    let correctAnswer: String
    let onRepeat: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let scale = scaleFactor(for: geometry.size)
            
            VStack(spacing: 25 * scale) {
                // Header
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 34 * scale))
                        .foregroundColor(.orange)
                    Text("Wrong Answer")
                        .font(.system(size: 28 * scale, weight: .bold))
                }
                .padding(.top, 30 * scale)
                
                // Correct answer display
                VStack(spacing: 10 * scale) {
                    Text("Correct Answer:")
                        .font(.system(size: 17 * scale, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    Text(correctAnswer)
                        .font(.system(size: 34 * scale, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30 * scale)
                        .padding(.vertical, 20 * scale)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15 * scale)
                        .shadow(color: .green.opacity(0.4), radius: 10 * scale, x: 0, y: 5 * scale)
                }
                .padding(.vertical, 20 * scale)
                
                // Action buttons
                VStack(spacing: 15 * scale) {
                    Button(action: onRepeat) {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 22 * scale))
                            Text("Repeat Answer")
                                .font(.system(size: 20 * scale, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 30 * scale)
                        .padding(.vertical, 16 * scale)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15 * scale)
                        .shadow(color: .blue.opacity(0.3), radius: 8 * scale, x: 0, y: 4 * scale)
                    }
                    
                    Button(action: onNext) {
                        HStack {
                            Text("Next Question")
                                .font(.system(size: 20 * scale, weight: .semibold))
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 22 * scale))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 30 * scale)
                        .padding(.vertical, 16 * scale)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15 * scale)
                        .shadow(color: .green.opacity(0.3), radius: 8 * scale, x: 0, y: 4 * scale)
                    }
                }
                .padding(.horizontal, 30 * scale)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
        }
    }
    
    // Same scaling function as main view
    private func scaleFactor(for size: CGSize) -> CGFloat {
        let width = size.width
        let height = size.height
        
        if height < 500 {
            return 1.0
        }
        
        if width < 500 {
            return 1.0
        } else if width < 700 {
            return 1.15
        } else if width < 900 {
            return 1.3
        } else {
            return 1.5
        }
    }
}

#Preview {
    RandomAudioExerciseView()
}
