import SwiftUI

struct ResultsView: View {
    @ObservedObject var resultsManager: QuizResultsManager
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.4, green: 0.7, blue: 1.0),
                        Color(red: 0.6, green: 0.8, blue: 1.0),
                        Color(red: 0.9, green: 0.95, blue: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                if resultsManager.results.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "chart.bar.doc.horizontal")
                            .font(.system(size: 80))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No Quiz Results Yet")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        Text("Complete a quiz to see your results here")
                            .font(.body)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(resultsManager.results) { result in
                                ResultCard(result: result)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            resultsManager.deleteResult(result)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Quiz Results")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !resultsManager.results.isEmpty {
                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .alert("Clear All Results?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    resultsManager.clearAllResults()
                }
            } message: {
                Text("This will permanently delete all quiz results.")
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ResultCard: View {
    let result: QuizResult
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    private var scoreColor: Color {
        if result.correctRate >= 90 {
            return .green
        } else if result.correctRate >= 70 {
            return .orange
        } else {
            return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with category and date
            HStack {
                Text(result.categoryName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(UIColor.label))
                
                Spacer()
                
                Text(dateFormatter.string(from: result.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Score display
            HStack {
                Text("\(Int(result.correctRate))%")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(scoreColor)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(result.correctAnswers)/\(result.totalQuestions)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(UIColor.label))
                    Text("Correct")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Quiz settings
            VStack(spacing: 8) {
                SettingRow(icon: "number", label: "Questions", value: "\(result.numberOfQuestions)")
                SettingRow(icon: "square.grid.2x2", label: "Options", value: "\(result.numberOfOptions)")
                SettingRow(icon: "speedometer", label: "Speed", value: result.speechSpeed)
                SettingRow(icon: "speaker.wave.2", label: "Environment", value: result.environment)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct SettingRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color(UIColor.label))
        }
    }
}

#Preview {
    ResultsView(resultsManager: QuizResultsManager())
}
