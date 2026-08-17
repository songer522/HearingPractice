import SwiftUI
import MessageUI
import FoundationModels

struct RandomQuizSettingsView: View {
    @Binding var selectedCategory: Category
    @Binding var numberOfOptions: Int
    @Binding var speechSpeed: SpeechSpeed
    @Binding var numberOfQuestions: Int
    @Binding var environment: ListeningEnvironment
    @ObservedObject var resultsManager: QuizResultsManager
    @Binding var aiPackQuestions: [QuizQuestion]
    @Binding var aiPackTitle: String
    @Binding var usingAIPack: Bool
    @Binding var aiPackRevision: Int
    @Environment(\.dismiss) var dismiss
    @State private var showResults = false
    @State private var showMailComposer = false
    @State private var showMailAlert = false
    @State private var showTipJar = false
    @State private var showAIPackCreator = false
    
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Quiz Settings")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    Picker("Number of Options", selection: $numberOfOptions) {
                        ForEach([2, 3, 4, 5, 6], id: \.self) { number in
                            Text("\(number) options").tag(number)
                        }
                    }
                    
                    Picker("Number of Questions", selection: $numberOfQuestions) {
                        ForEach([10, 25, 50], id: \.self) { number in
                            Text("\(number) questions").tag(number)
                        }
                    }
                    
                    Picker("Speech Speed", selection: $speechSpeed) {
                        ForEach(SpeechSpeed.allCases, id: \.self) { speed in
                            Text(speed.rawValue).tag(speed)
                        }
                    }
                    
                    Picker("Environment", selection: $environment) {
                        ForEach(ListeningEnvironment.allCases, id: \.self) { env in
                            Text(env.rawValue).tag(env)
                        }
                    }
                }
                
                Section(header: Text("Results")) {
                    Button(action: {
                        showResults = true
                    }) {
                        HStack {
                            Image(systemName: "chart.bar.doc.horizontal")
                                .foregroundColor(.blue)
                            Text("View Quiz Results")
                                .foregroundColor(Color(UIColor.label))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                }

                Section(header: Text("AI Topic Packs")) {
                    if #available(iOS 26.0, *) {
                        FoundationModelAvailabilityRow()
                        Button("Create AI Topic Pack") { showAIPackCreator = true }
                    } else {
                        Label("Requires a newer version of iOS", systemImage: "iphone.slash")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        showTipJar = true
                    }) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                            Text("Send Tip")
                                .foregroundColor(Color(UIColor.label))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            showMailComposer = true
                        } else {
                            showMailAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.blue)
                            Text("Give Feedback")
                                .foregroundColor(Color(UIColor.label))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .scrollContentBackground(.hidden)
            .safeAreaInset(edge: .top, spacing: 0) {
                Color.clear.frame(height: 0)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear.frame(height: 20)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showResults) {
                ResultsView(resultsManager: resultsManager)
            }
            .sheet(isPresented: $showMailComposer) {
                MailComposeView(recipient: "rewind.feedback@gmail.com", subject: "Hearing Practice Feedback")
            }
            .sheet(isPresented: $showTipJar) {
                TipJarView()
            }
            .sheet(isPresented: $showAIPackCreator) {
                if #available(iOS 26.0, *) {
                    AITopicPackCreatorView { title, questions in
                        aiPackTitle = title
                        aiPackQuestions = questions
                        usingAIPack = true
                        aiPackRevision += 1
                        showAIPackCreator = false
                        dismiss()
                    }
                }
            }
            .alert("Cannot Send Email", isPresented: $showMailAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your device is not configured to send email. Please set up Mail app or contact us at rewind.feedback@gmail.com")
            }
        }
        .navigationViewStyle(.stack)
    }
}

@available(iOS 26.0, *)
private struct AITopicPackCreatorView: View {
    let onUse: (String, [QuizQuestion]) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var topic = ""
    @State private var generatedPack: GeneratedTopicPack?
    @State private var isGenerating = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Topic") {
                    TextField("For example: TV shows", text: $topic)
                    Text("Creates 10 short, natural listening questions entirely on your device.")
                        .font(.footnote).foregroundColor(.secondary)
                }
                Section("About AI-generated packs") {
                    Label("AI-generated choices may vary in quality. Review each pack before using it.", systemImage: "exclamationmark.triangle")
                    Label("Generation availability and usage limits depend on Apple Intelligence, your device, and current system conditions.", systemImage: "gauge.with.dots.needle.33percent")
                }
                if let pack = generatedPack {
                    Section(pack.title) {
                        ForEach(pack.questions.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Set \(index + 1)")
                                    .font(.headline)
                                ForEach(pack.questions[index].choices, id: \.self) { choice in
                                    Text(choice)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        Button("Use This Pack") { onUse(pack.title, quizQuestions(from: pack)) }
                            .disabled(quizQuestions(from: pack).isEmpty)
                    }
                }
                if let errorMessage { Section { Text(errorMessage).foregroundColor(.red) } }
            }
            .navigationTitle("AI Topic Pack")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(isGenerating ? "Generating…" : "Generate") { generate() }
                        .disabled(topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isGenerating)
                }
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            }
        }
    }

    private func generate() {
        isGenerating = true; errorMessage = nil
        Task {
            do {
                let session = LanguageModelSession(instructions: """
                Create safe, natural U.S. English listening-practice choice sets for a cochlear implant user. Choose the most natural format for the requested topic: character topics should use character names only; vocabulary topics should use single words or short names; actions, situations, and everyday topics can use short phrases or sentences. Every set must use the same format and have four distinct, plausible choices. Never create a question, instruction, heading, or phrase ending in a question mark. If a named fictional franchise is requested, use only character names; do not reproduce dialogue, plot text, or long copyrighted text. Avoid unsafe, adult, medical, or political content.
                """)
                let response = try await session.respond(generating: GeneratedTopicPack.self) {
                    "Generate exactly 10 four-option listening choice sets about: \(topic)."
                }
                let pack = response.content
                guard quizQuestions(from: pack).count == 10 else {
                    errorMessage = "This draft included an incomplete choice set. Please generate it again."
                    generatedPack = nil
                    isGenerating = false
                    return
                }
                generatedPack = pack
            } catch {
                errorMessage = "Could not create this pack. Try a different topic."
            }
            isGenerating = false
        }
    }

    private func quizQuestions(from pack: GeneratedTopicPack) -> [QuizQuestion] {
        pack.questions.compactMap { choiceSet in
            let choices = choiceSet.choices.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            guard choices.count == 4, Set(choices).count == 4, let spoken = choices.first, !spoken.isEmpty else { return nil }
            return QuizQuestion(options: choices.shuffled(), correctAnswer: spoken)
        }
    }
}

@available(iOS 26.0, *)
@Generable(description: "A listening-practice topic pack made of choice sets")
private struct GeneratedTopicPack {
    @Guide(description: "A short title for the topic pack") var title: String
    @Guide(description: "Exactly ten choice sets", .count(10)) var questions: [GeneratedTopicChoiceSet]
}

@available(iOS 26.0, *)
@Generable(description: "Four listening choices in the format that best fits the requested topic, with no question or instruction")
private struct GeneratedTopicChoiceSet {
    @Guide(description: "Exactly four unique choices. Use names only for character topics, words for vocabulary topics, and short phrases or sentences when appropriate. The first choice is the one the app speaks. Never create a question or instruction.", .count(4)) var choices: [String]
}

@available(iOS 26.0, *)
private struct FoundationModelAvailabilityRow: View {
    private let model = SystemLanguageModel.default

    var body: some View {
        switch model.availability {
        case .available:
            Label("On-device AI is ready", systemImage: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .unavailable(let reason):
            Label("On-device AI unavailable: \(availabilityDescription(for: reason))", systemImage: "exclamationmark.circle")
                .foregroundColor(.secondary)
        @unknown default:
            Label("On-device AI status is unknown", systemImage: "questionmark.circle")
                .foregroundColor(.secondary)
        }
    }

    private func availabilityDescription(for reason: SystemLanguageModel.Availability.UnavailableReason) -> String {
        switch reason {
        case .appleIntelligenceNotEnabled:
            return "Apple Intelligence is turned off"
        case .deviceNotEligible:
            return "this device is not eligible"
        case .modelNotReady:
            return "the model is still downloading"
        @unknown default:
            return "unknown reason"
        }
    }
}

// MARK: - Mail Compose View
struct MailComposeView: UIViewControllerRepresentable {
    let recipient: String
    let subject: String
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setToRecipients([recipient])
        composer.setSubject(subject)
        
        // Add device and app info to help with debugging
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        let deviceModel = UIDevice.current.model
        let systemVersion = UIDevice.current.systemVersion
        
        let messageBody = """
        
        
        ---
        App Version: \(appVersion) (\(build))
        Device: \(deviceModel)
        iOS Version: \(systemVersion)
        """
        
        composer.setMessageBody(messageBody, isHTML: false)
        
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.dismiss()
        }
    }
}

#Preview {
    RandomQuizSettingsView(selectedCategory: .constant(.food), numberOfOptions: .constant(4), speechSpeed: .constant(.normal), numberOfQuestions: .constant(25), environment: .constant(.quiet), resultsManager: QuizResultsManager(), aiPackQuestions: .constant([]), aiPackTitle: .constant("AI Topic Pack"), usingAIPack: .constant(false), aiPackRevision: .constant(0))
}
