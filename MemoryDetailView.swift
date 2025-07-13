import SwiftUI

struct MemoryDetailView: View {
    let person: Person
    @Environment(\.dismiss) private var dismiss
    @State private var showingReconnectOptions = false
    @State private var isReconnecting = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Image Section
                    VStack(spacing: 16) {
                        ZStack {
                            // Background gradient
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [
                                        person.emotion.color.opacity(0.3),
                                        person.emotion.color.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 200)
                            
                            // Profile image
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 120))
                                .foregroundColor(person.emotion.color)
                        }
                        
                        // Name and emotion
                        VStack(spacing: 8) {
                            Text(person.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 6) {
                                Image(systemName: person.emotion.icon)
                                    .font(.subheadline)
                                    .foregroundColor(person.emotion.color)
                                
                                Text(person.emotion.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(person.emotion.color)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(person.emotion.color.opacity(0.15))
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Memory Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .font(.title3)
                                .foregroundColor(.blue)
                            
                            Text("Memory Insight")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(person.lastMemory)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Text(person.memoryDate)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(person.summary)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal, 20)
                    
                    // AI Suggestion Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .font(.title3)
                                .foregroundColor(.orange)
                            
                            Text("Reconnection Suggestion")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        Text(person.reconnectionSuggestion)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal, 20)
                    
                    // Reconnect Button
                    Button(action: {
                        // Apptics SDK - Track reconnection attempt
                        // AppticSDK.track("reconnect_button_tapped", properties: ["person": person.name])
                        
                        showingReconnectOptions = true
                    }) {
                        HStack(spacing: 12) {
                            if isReconnecting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "phone.fill")
                                    .font(.title3)
                            }
                            
                            Text(isReconnecting ? "Connecting..." : "Reconnect Now")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [person.emotion.color, person.emotion.color.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: person.emotion.color.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(isReconnecting)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .actionSheet(isPresented: $showingReconnectOptions) {
            ActionSheet(
                title: Text("How would you like to reconnect?"),
                buttons: [
                    .default(Text("Call \(person.name)")) {
                        simulateReconnection(method: "call")
                    },
                    .default(Text("Send a Message")) {
                        simulateReconnection(method: "message")
                    },
                    .default(Text("Video Call")) {
                        simulateReconnection(method: "video")
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private func simulateReconnection(method: String) {
        isReconnecting = true
        
        // Apptics SDK - Track reconnection method
        // AppticSDK.track("reconnection_initiated", properties: [
        //     "person": person.name,
        //     "method": method,
        //     "emotion_context": person.emotion.rawValue
        // ])
        
        // Simulate connection delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isReconnecting = false
            
            // In a real app, this would trigger the actual communication
            // For demo purposes, we'll just show a success state
            
            // Apptics SDK - Track successful reconnection
            // AppticSDK.track("reconnection_completed", properties: [
            //     "person": person.name,
            //     "method": method
            // ])
        }
    }
}

#Preview {
    MemoryDetailView(person: mockPeople[0])
}