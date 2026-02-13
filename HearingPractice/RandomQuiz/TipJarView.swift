import SwiftUI
import StoreKit

struct TipJarView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var storeManager = StoreManager()
    
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
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Header
                        VStack(spacing: 15) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.pink)
                                .padding(.top, 20)
                            
                            Text("Support Development")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color(UIColor.label))
                            
                            Text("Your support helps keep this app free and ad-free for everyone!")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Tip options
                        if storeManager.isLoading {
                            ProgressView()
                                .padding()
                        } else if let error = storeManager.errorMessage {
                            VStack(spacing: 15) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 40))
                                    .foregroundColor(.orange)
                                Text(error)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .padding()
                        } else {
                            VStack(spacing: 15) {
                                TipButton(
                                    title: "Small Tip",
                                    amount: "$0.99",
                                    icon: "cup.and.saucer.fill",
                                    color: .blue
                                ) {
                                    storeManager.purchaseTip(amount: .small)
                                }
                                
                                TipButton(
                                    title: "Medium Tip",
                                    amount: "$2.99",
                                    icon: "mug.fill",
                                    color: .green
                                ) {
                                    storeManager.purchaseTip(amount: .medium)
                                }
                                
                                TipButton(
                                    title: "Large Tip",
                                    amount: "$4.99",
                                    icon: "takeoutbag.and.cup.and.straw.fill",
                                    color: .orange
                                ) {
                                    storeManager.purchaseTip(amount: .large)
                                }
                                
                                TipButton(
                                    title: "Generous Tip",
                                    amount: "$9.99",
                                    icon: "gift.fill",
                                    color: .pink
                                ) {
                                    storeManager.purchaseTip(amount: .generous)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Thank you message
                        if storeManager.purchaseSuccess {
                            VStack(spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.green)
                                Text("Thank You!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(UIColor.label))
                                Text("Your support means the world to us!")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Tip Jar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct TipButton: View {
    let title: String
    let amount: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color(UIColor.label))
                    Text(amount)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(color)
                    .font(.title2)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

// MARK: - Store Manager
enum TipAmount: String, CaseIterable {
    case small = "com.hearingpractice.tip.small"
    case medium = "com.hearingpractice.tip.medium"
    case large = "com.hearingpractice.tip.large"
    case generous = "com.hearingpractice.tip.generous"
}
//songer522@sina.com.cn
//Test@2026
class StoreManager: NSObject, ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var purchaseSuccess = false
    
    private var products: [Product] = []
    
    override init() {
        super.init()
        Task {
            await loadProducts()
        }
    }
    
    @MainActor
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        
        // For now, we'll simulate the store
        // In production, you would configure these products in App Store Connect
        // and use:
        
        do {
            products = try await Product.products(for: TipAmount.allCases.map { $0.rawValue })
        } catch {
            errorMessage = "Unable to load tips. Please try again."
        }
        
        // Simulated mode - tips are not actually charged
//        errorMessage = "Tip functionality is currently in demo mode. In-app purchases will be available in a future update."
    }
    
    func purchaseTip(amount: TipAmount) {
        Task {
            await purchase(amount: amount)
        }
    }
    
    @MainActor
    private func purchase(amount: TipAmount) async {
        guard let product = products.first(where: { $0.id == amount.rawValue }) else {
            errorMessage = "Product not found. Please try again."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Verify the transaction
                switch verification {
                case .verified(let transaction):
                    // Transaction is verified, grant the tip
                    purchaseSuccess = true
                    
                    // Finish the transaction
                    await transaction.finish()
                    
                    // Hide success message after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.purchaseSuccess = false
                    }
                    
                case .unverified:
                    errorMessage = "Transaction could not be verified. Please try again."
                }
                
            case .userCancelled:
                // User cancelled, no action needed
                break
                
            case .pending:
                errorMessage = "Purchase is pending approval."
                
            @unknown default:
                errorMessage = "Unknown error occurred."
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

#Preview {
    TipJarView()
}
