//
//  DeckView.swift
//  FlipIt
//
//  Created by Arthur Sobrosa on 24/08/23.
//

import SwiftUI

struct DeckView: View {
    @State var deck: Deck
    
    @State var name: String
    
    @State var numberPerTest: Int
    
    @State private var flashcard: Flashcard? = nil

    @State private var flashcardsFromUserDefaults: [Flashcard] = []
    @State private var presentFlashcardView: Bool = false
    @State private var presentCreateFlashcardView: Bool = false
    @State private var presentCreateDeckView: Bool = false
    @State private var editButtonClicked: Bool = false
    @State private var editFlashcard: Bool = false
    @State private var showingAlert: Bool = false
    @State private var showingDeleteAlert: Bool = false
    @State private var clickedSaveButton: Bool = false
    @State private var clickedDeleteButton: Bool = false
    

    @Environment(\.dismiss) var dismiss
    
    let index = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                if flashcardsFromUserDefaults.count == 0 {
                    ForEach(index, id: \.self) { _ in
                        Spacer()
                    }
                    
                    Button {
                        presentCreateFlashcardView.toggle()
                        editFlashcard = false
                    } label: {
                        Rectangle()
                            .frame(width: 125, height: 180)
                            .cornerRadius(8)
                            .foregroundColor(Color("FlashcardColor"))
                            .overlay(
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 51)
                                    .foregroundColor(Color("Color"))
                            )
                    }
                    
                    Text("You haven't added any flashcards yet! Click on the card above to add one.")
                        .foregroundColor(.gray)
                        .font(.custom("Quicksand-Regular", size: 18))
                        .padding(.top)
                        .frame(width: 320)
                } else {
                    LazyVGrid(columns: gridItemLayout, spacing: 24) {
                        ForEach(flashcardsFromUserDefaults, id: \.self) { flashcard in
                            Button {
                                self.flashcard = flashcard
                                editFlashcard = true
                                presentCreateFlashcardView.toggle()
                                
                            } label: {
                                ZStack(alignment: .bottomTrailing) {
                                    Rectangle().fill(Color("FlashcardColor").gradient)
                                        .frame(width: 173, height: 250)
                                        .cornerRadius(4)
//                                        .foregroundColor(Color("FlashcardColor"))
//                                        .shadow(color: .gray, radius: 4, x: 0, y: 4)
                                        .overlay(
                                            VStack(alignment: .trailing) {
                                                Text(flashcard.question)
                                                    .foregroundColor(.black)
                                                    .frame(width: 160)
                                                    .font(.custom("Quicksand-Regular", size: 15))
                                                    .lineLimit(2)
                                            }
                                        )
                                    
                                    Text("\(flashcard.flashcardId)")
                                        .offset(x: -5, y: -5)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top)

            VStack {
                if flashcardsFromUserDefaults.count != 0 {
                    HStack(spacing: 100) {
                        Button {
                            presentCreateFlashcardView.toggle()
                            editFlashcard = false
                        } label: {
                            Text("Add Card")
                                .foregroundColor(Color("ButtonAction"))
                                .font(.custom("Quicksand-Regular", size: 18))
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(lineWidth: 1)
                                        .frame(width: 160)
                                        .foregroundColor(Color("ButtonAction"))
                                )
                        }
                        
                        Button {
                            if flashcardsFromUserDefaults.count < deck.numberPerTest {
                                showingAlert.toggle()
                            } else {
                                presentFlashcardView.toggle()
                            }
                        } label: {
                            Text("Practice")
                                .foregroundColor(Color("ButtonAction"))
                                .font(.custom("Quicksand-Regular", size: 18))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20).fill(Color("Header").gradient)
                                        .frame(width: 160)
                                )
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("You don't have enough cards to practice"), dismissButton: .default(Text("Try again")))
                        }
                    }
                }
            }
            .navigationTitle(name)
//            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button {
                    presentCreateDeckView.toggle()
                } label: {
                    Text("Edit")
                        .foregroundColor(Color("ButtonAction"))
                }
            )
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                flashcardsFromUserDefaults = UserDefaultsService.getFlashcards(deckId: deck.deckId)
                
                editFlashcard = false
            }
            .onChange(of: presentCreateFlashcardView) { _ in
                flashcardsFromUserDefaults = UserDefaultsService.getFlashcards(deckId: deck.deckId)
                
                deck.flashcards = flashcardsFromUserDefaults
            }
            .onChange(of: presentCreateDeckView) { _ in
                if clickedSaveButton {
                    deck.numberPerTest = numberPerTest + 1
                }
            }
            .sheet(isPresented: $presentFlashcardView) {
                FlashcardView(flashcards: Array(deck.flashcards.shuffled().prefix(deck.numberPerTest)), deck: deck)
            }
            .sheet(isPresented: $presentCreateFlashcardView) {
                if editFlashcard {
                    CreateFlashcardView(deck: deck, isEditing: true, flashcard: flashcard)
                } else {
                    CreateFlashcardView(deck: deck)
                }
            }
            .sheet(isPresented: $presentCreateDeckView, onDismiss: {
                if !clickedSaveButton {
                    name = deck.deckName
                }
                
                if clickedDeleteButton {
                    dismiss()
                }
            }) {
                CreateDeckView(isEditing: true, deck: deck, name: $name, numberPerTest: $numberPerTest, clickedSaveButton: $clickedSaveButton, clickedDeleteButton: $clickedDeleteButton)
            }
//            .toolbarBackground(.visible, for: .navigationBar)
//            .toolbarBackground(Color("Header"), for: .navigationBar)
        }
        .preferredColorScheme(.light)
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(deck: LoadDecksFromJson().decks[1], name: LoadDecksFromJson().decks[1].deckName, numberPerTest: LoadDecksFromJson().decks[1].numberPerTest)
    }
}
