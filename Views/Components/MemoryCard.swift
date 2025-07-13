import SwiftUI

struct MemoryCard: View {
    let memory: MemoryInsight
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                EmotionIndicator(emotion: memory.emotion, size: .small)
                
                Spacer()
                
                if memory.aiGenerated {
                    HStack(spacing: 4) {
                        Image(systemName: "brain.head.profile")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        
                        Text("AI")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                }
                
                Text(formatDate(memory.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Content
            Text(memory.content)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(isExpanded ? nil : 3)
                .animation(.easeInOut(duration: 0.3), value: isExpanded)
            
            // Confidence indicator (if AI generated)
            if memory.aiGenerated {
                HStack {
                    Text("Confidence:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    ProgressView(value: memory.confidence)
                        .progressViewStyle(LinearProgressViewStyle(tint: memory.emotion.color))
                        .frame(width: 60)
                    
                    Text("\(Int(memory.confidence * 100))%")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Expand/Collapse indicator
            if !isExpanded {
                HStack {
                    Spacer()
                    Text("Tap to expand")
                        .font(.caption2)
                        .foregroundColor(.tertiary)
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.tertiary)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .onTapGesture {
            onTap()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct MemoryTimeline: View {
    let memories: [MemoryInsight]
    @State private var expandedMemoryId: UUID?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                Text("Memory Timeline")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(memories.sorted(by: { $0.date > $1.date })) { memory in
                    MemoryCard(
                        memory: memory,
                        isExpanded: expandedMemoryId == memory.id
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            expandedMemoryId = expandedMemoryId == memory.id ? nil : memory.id
                        }
                    }
                }
            }
        }
    }
}

struct MemoryInsightView: View {
    let insight: MemoryInsight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.title3)
                    .foregroundColor(.orange)
                
                Text("Memory Insight")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                EmotionIndicator(emotion: insight.emotion, size: .small)
            }
            
            Text(insight.content)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
            
            if insight.aiGenerated {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("Generated by Apple Intelligence")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Confidence: \(Int(insight.confidence * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            MemoryCard(
                memory: MemoryInsight(
                    content: "You and your friend shared an incredible sunset moment during your beach trip. The laughter and joy from that evening created a lasting bond.",
                    date: Date().addingTimeInterval(-86400 * 7),
                    emotion: .joy,
                    confidence: 0.92
                ),
                isExpanded: false
            ) {
                print("Memory tapped")
            }
            
            MemoryInsightView(
                insight: MemoryInsight(
                    content: "This memory represents a significant moment of connection and shared happiness that strengthened your relationship.",
                    date: Date(),
                    emotion: .gratitude,
                    confidence: 0.88
                )
            )
            
            MemoryTimeline(memories: [
                MemoryInsight(content: "Great conversation", date: Date(), emotion: .comfort),
                MemoryInsight(content: "Shared laughter", date: Date().addingTimeInterval(-86400), emotion: .joy),
                MemoryInsight(content: "Meaningful support", date: Date().addingTimeInterval(-86400 * 2), emotion: .gratitude)
            ])
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}