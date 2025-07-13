import SwiftUI

// MARK: - Data Models

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let lastMemory: String
    let memoryDate: String
    let summary: String
    let emotion: EmotionType
    let reconnectionSuggestion: String
}

enum EmotionType: String, CaseIterable {
    case joy = "Joy"
    case gratitude = "Gratitude"
    case nostalgia = "Nostalgia"
    case love = "Love"
    case comfort = "Comfort"
    
    var color: Color {
        switch self {
        case .joy: return .yellow
        case .gratitude: return .green
        case .nostalgia: return .purple
        case .love: return .pink
        case .comfort: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .joy: return "sun.max.fill"
        case .gratitude: return "heart.fill"
        case .nostalgia: return "clock.fill"
        case .love: return "heart.circle.fill"
        case .comfort: return "house.fill"
        }
    }
}

// MARK: - Mock Data

let mockPeople = [
    Person(
        name: "Mom",
        imageName: "mom",
        lastMemory: "Diwali celebration at home",
        memoryDate: "November 2023",
        summary: "You and Mom shared beautiful moments during Diwali 2023. The warmth of family traditions, the joy of cooking together, and the comfort of being home created lasting memories filled with love and gratitude.",
        emotion: .gratitude,
        reconnectionSuggestion: "Share a photo from that day or ask about her favorite Diwali memory"
    ),
    Person(
        name: "Dad",
        imageName: "dad",
        lastMemory: "Deep conversation on January 12th",
        memoryDate: "January 2024",
        summary: "During your long phone call, you and Dad reconnected on a deeper level. His wisdom and your openness created a moment of genuine understanding that strengthened your bond.",
        emotion: .comfort,
        reconnectionSuggestion: "Call him to continue that meaningful conversation"
    ),
    Person(
        name: "Best Friend",
        imageName: "friend",
        lastMemory: "Goa adventure photos",
        memoryDate: "December 2023",
        summary: "Your Goa trip was filled with laughter, spontaneous adventures, and the kind of carefree joy that defines true friendship. Those sunset photos capture more than a moment—they capture a feeling.",
        emotion: .joy,
        reconnectionSuggestion: "Plan your next adventure together or share a funny memory from the trip"
    )
]

// MARK: - Main Content View

struct ContentView: View {
    @State private var selectedPerson: Person?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("LOOP")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    Text("Your most important connections")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // People List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(mockPeople) { person in
                            PersonCard(person: person)
                                .onTapGesture {
                                    selectedPerson = person
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Footer
                VStack(spacing: 4) {
                    Text("Powered by Apple Intelligence & Journal API")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("• Apptics SDK Integration •")
                        .font(.caption2)
                        .foregroundColor(.tertiary)
                }
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground))
            .sheet(item: $selectedPerson) { person in
                MemoryDetailView(person: person)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Person Card Component

struct PersonCard: View {
    let person: Person
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content
            HStack(spacing: 16) {
                // Profile Image
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [person.emotion.color.opacity(0.3), person.emotion.color.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(person.emotion.color)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(person.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Emotion Indicator
                        HStack(spacing: 4) {
                            Image(systemName: person.emotion.icon)
                                .font(.caption)
                                .foregroundColor(person.emotion.color)
                            
                            Text(person.emotion.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(person.emotion.color)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(person.emotion.color.opacity(0.15))
                        .cornerRadius(12)
                    }
                    
                    Text(person.lastMemory)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(person.memoryDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.tertiary)
            }
            .padding(20)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}