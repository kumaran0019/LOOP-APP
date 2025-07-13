import SwiftUI

struct EmotionIndicator: View {
    let emotion: EmotionType
    let size: EmotionSize
    let showLabel: Bool
    
    enum EmotionSize {
        case small, medium, large
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 24
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 8
            case .large: return 12
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 10
            case .large: return 14
            }
        }
    }
    
    init(emotion: EmotionType, size: EmotionSize = .medium, showLabel: Bool = true) {
        self.emotion = emotion
        self.size = size
        self.showLabel = showLabel
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: emotion.icon)
                .font(.system(size: size.iconSize, weight: .medium))
                .foregroundColor(emotion.color)
            
            if showLabel {
                Text(emotion.rawValue)
                    .font(.system(size: size.iconSize, weight: .medium))
                    .foregroundColor(emotion.color)
            }
        }
        .padding(.horizontal, size.padding)
        .padding(.vertical, size.padding * 0.6)
        .background(emotion.color.opacity(0.15))
        .cornerRadius(size.cornerRadius)
    }
}

struct AnimatedEmotionIndicator: View {
    let emotion: EmotionType
    @State private var isAnimating = false
    
    var body: some View {
        EmotionIndicator(emotion: emotion, size: .medium)
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

struct EmotionSpectrum: View {
    let emotions: [EmotionType]
    let selectedEmotion: EmotionType?
    let onEmotionSelected: (EmotionType) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(emotions, id: \.self) { emotion in
                    Button(action: {
                        onEmotionSelected(emotion)
                    }) {
                        EmotionIndicator(
                            emotion: emotion,
                            size: selectedEmotion == emotion ? .large : .medium
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(selectedEmotion == emotion ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedEmotion)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        EmotionIndicator(emotion: .joy, size: .small)
        EmotionIndicator(emotion: .gratitude, size: .medium)
        EmotionIndicator(emotion: .nostalgia, size: .large)
        
        AnimatedEmotionIndicator(emotion: .love)
        
        EmotionSpectrum(
            emotions: EmotionType.allCases,
            selectedEmotion: .joy
        ) { emotion in
            print("Selected: \(emotion)")
        }
    }
    .padding()
}