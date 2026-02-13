import SwiftUI
import MessageUI

struct RandomQuizSettingsView: View {
    @Binding var selectedCategory: Category
    @Binding var numberOfOptions: Int
    @Binding var speechSpeed: SpeechSpeed
    @Binding var numberOfQuestions: Int
    @Binding var environment: ListeningEnvironment
    @ObservedObject var resultsManager: QuizResultsManager
    @Environment(\.dismiss) var dismiss
    @State private var showResults = false
    @State private var showMailComposer = false
    @State private var showMailAlert = false
    @State private var showTipJar = false
    
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
            .alert("Cannot Send Email", isPresented: $showMailAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your device is not configured to send email. Please set up Mail app or contact us at rewind.feedback@gmail.com")
            }
        }
        .navigationViewStyle(.stack)
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
    RandomQuizSettingsView(selectedCategory: .constant(.food), numberOfOptions: .constant(4), speechSpeed: .constant(.normal), numberOfQuestions: .constant(25), environment: .constant(.quiet), resultsManager: QuizResultsManager())
}
