

import SwiftUI

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let lastMemory: String
    let summary: String
    let emotion: String
}

let people = [
    Person(name: "Mom", imageName: "mom", lastMemory: "Diwali 2023 at home", summary: "You and Mom shared many happy moments in Diwali 2023.", emotion: "Joy"),
    Person(name: "Dad", imageName: "dad", lastMemory: "Long phone call on Jan 12", summary: "You reconnected deeply during that call.", emotion: "Gratitude"),
    Person(name: "Best Friend", imageName: "friend", lastMemory: "Photos from Goa trip", summary: "You laughed a lot during the Goa trip.", emotion: "Nostalgia")
]

struct ContentView: View {
    var body: some View {
        NavigationView {
            List(people) { person in
                NavigationLink(destination: MemoryDetailView(person: person)) {
                    HStack(spacing: 16) {
                        Image(person.imageName)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 4)

                        VStack(alignment: .leading) {
                            Text(person.name)
                                .font(.title2).bold()
                            Text(person.lastMemory)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Your People")
        }
    }
}

struct MemoryDetailView: View {
    let person: Person

    var body: some View {
        VStack(spacing: 20) {
            Image(person.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .clipped()
                .cornerRadius(20)

            Text(person.summary)
                .font(.body)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

            Text("Emotion: \(person.emotion)")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Button(action: {
                // Placeholder: reconnect action
            }) {
                Text("Reconnect Now")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .navigationTitle(person.name)
    }
}

#Preview {
    ContentView()
}
