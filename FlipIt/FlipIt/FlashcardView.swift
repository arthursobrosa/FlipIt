//
//  FlashcardView.swift
//  FlipIt
//
//  Created by Arthur Sobrosa on 24/08/23.
//

import SwiftUI

struct FlashcardView: View {
    var flashcards: [Flashcard]
    var deck: Deck
    
    @State var currentIndex = 0

    @State private var flipped = false
    @State private var reveal = false
    @State private var showFlashmark = false
    @State private var showingAlert = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            TabView(selection: $currentIndex) {
                ForEach(flashcards.indices, id: \.self) { index in
                    VStack {
                        ZStack {
                            Rectangle().fill(Color("FlashcardColor").gradient)
                                .frame(width: 342, height: 430)
                                .cornerRadius(8)
                                .overlay(
                                    Text(reveal ? "Answer" : "Question")
                                        .offset(y: -190)
                                        .font(.custom("Quicksand-Regular", size: 18))
                                        .rotation3DEffect(.degrees(reveal ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                                )

                            if !flipped {
                                Text(flashcards[index].question)
                                    .frame(width: 300)
                                    .font(.custom("Quicksand-Regular", size: 20))
                                    .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                            } else {
                                Text(flashcards[index].answer)
                                    .frame(width: 300)
                                    .font(.custom("Quicksand-Regular", size: 20))
                                    .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                flipped.toggle()
                            }
                            reveal.toggle()
                        }
                        .rotation3DEffect(.degrees(flipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))

                        Text("Tap card to flip")
                            .padding(.top)
                            .font(.custom("Quicksand-Regular", size: 16))
                            .foregroundColor(.gray)

                        Spacer()
                        
                        if reveal {
                            Button {
                                currentIndex = updatedIndex(currentIndex)
                                flipped.toggle()
                                reveal.toggle()

                            } label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 100, height: 70)
                                        .cornerRadius(10)
                                        .foregroundColor(Color("ButtonAction"))
                                    Text("Next")
                                        .font(.custom("Quicksand-Regular", size: 25))
                                    .foregroundColor(.white)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(.top)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button {
                    showingAlert.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                }
                .foregroundColor(.gray)
                .offset(x: 10)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Are you sure you want to go back? Your progress will be lost."), message: nil, primaryButton: .destructive( Text("Quit"), action: {
                            dismiss()
                        }),
                        secondaryButton: .cancel(Text("Stay"))
                    )
                }
            )
        }
        .preferredColorScheme(.light)
    }

    func updatedIndex(_ index: Int) -> Int {
        if index == deck.numberPerTest - 1 {
            dismiss()
            return index % deck.numberPerTest
        }
        return index + 1
    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(flashcards: LoadDecksFromJson().decks[0].flashcards, deck: LoadDecksFromJson().decks[0])
    }
}
