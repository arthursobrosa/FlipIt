//
//  CreateFlashcardView.swift
//  FlipIt
//
//  Created by Arthur Sobrosa on 24/08/23.
//

import SwiftUI

enum ActiveAlert {
    case questionAlert, answerAlert, bothAlert
}

struct CreateFlashcardView: View {
    var deck: Deck
    var isEditing: Bool
    var flashcard: Flashcard?
    
    init(deck: Deck) {
        self.deck = deck
        isEditing = false
        flashcard = nil
    }
    
    init(deck: Deck, isEditing: Bool, flashcard: Flashcard?) {
        self.deck = deck
        self.isEditing = isEditing
        self.flashcard = flashcard
    }

    @State private var decksFromUserDefaults: [Deck] = UserDefaultsService.getDecks()
    
    @FocusState private var textIsFocused: Bool
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var flipped = false
    @State private var reveal = false
    @State private var showFlashmark = false
    @State private var showingAlert = false
    @State private var showingDeleteAlert = false
    @State private var showingTextAlert = false
    @State private var activeAlert: ActiveAlert = .questionAlert
    @State private var hideTop = false
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            if !hideTop {
                HStack {
                    Button {
                        showingAlert.toggle()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color("ButtonAction"))
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(isEditing ? "Are you sure you want to quit editing? Your alterations will be dismissed." : "Are you sure you want to quit this creation? Your alterations will be dismissed."), message: nil, primaryButton: .destructive( Text("Quit"), action: {
                                dismiss()
                            }),
                              secondaryButton: .cancel(Text("Stay"))
                        )
                    }
                    
                    Spacer()
                    
                    Text(isEditing ? "Edit flashcard \(flashcard!.flashcardId)" : "Create flashcard")
                        .foregroundColor(.black)
                        .bold()
                        .padding()
                    
                    Spacer()
                    
                    Button {
                        let q = checkForEmptyText(question)
                        let a = checkForEmptyText(answer)
                        
                        if !q && !a {
                            if isEditing {
                                UserDefaultsService.modifyFlashcardQA(deckId: deck.deckId, flashcardId: flashcard!.flashcardId, question: question, answer: answer)
                                
                                decksFromUserDefaults = UserDefaultsService.getDecks()
                                
                                dismiss()
                                showingTextAlert.toggle()
                            
                            } else {
                                UserDefaultsService.addFlashcard(question: question, answer: answer, deckId: deck.deckId)
                                
                                decksFromUserDefaults = UserDefaultsService.getDecks()
                                
                                dismiss()
                                showingTextAlert.toggle()
                            }
                        } else if q && !a {
                            activeAlert = .questionAlert
                        } else if !q && a {
                            activeAlert = .answerAlert
                        } else {
                            activeAlert = .bothAlert
                        }
                        
                        showingTextAlert.toggle()
                    } label: {
                        Text("Save")
                            .foregroundColor(Color("ButtonAction"))
                    }
                    .alert(isPresented: $showingTextAlert) {
                        switch activeAlert {
                        case .questionAlert:
                            return Alert(title: Text("You haven't typed in your question!"), dismissButton: .default(Text("Try again")))
                        case .answerAlert:
                            return Alert(title: Text("You haven't typed in your answer!"), dismissButton: .default(Text("Try again")))
                        case .bothAlert:
                            return Alert(title: Text("You haven't typed anything in!"), dismissButton: .default(Text("Try again")))
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            ZStack {
                Rectangle().fill(Color("FlashcardColor").gradient)
                    .frame(width: 342, height: 430)
                    .cornerRadius(8)
                    .onTapGesture {
                        if !hideTop {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                flipped.toggle()
                            }
                            reveal.toggle()
                        } else {
                            textIsFocused = false
                            hideTop = false
                        }
                    }
                    .overlay(
                        Text(reveal ? "Answer" : "Question")
                            .offset(y: -190)
                            .font(.custom("Quicksand-Regular", size: 18))
                            .rotation3DEffect(.degrees(reveal ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    )
                    
                if !flipped {
                    TextField("Question", text: $question, axis: .vertical)
                        .onTapGesture {
                            hideTop = true
                        }
                        .onChange(of: question) { newvalue in
                            if question.count > 100 {
                                question = String(question.prefix(100))
                            }
                        }
                        .frame(width: 300)
                        .font(.custom("Quicksand-Regular", size: 20))
                        .disableAutocorrection(true)
                        .focused($textIsFocused)
                        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                } else {
                    TextField("Answer", text: $answer, axis: .vertical)
                        .onTapGesture {
                            hideTop = true
                        }
                        .onChange(of: answer) { newvalue in
                            if answer.count > 100 {
                                answer = String(answer.prefix(100))
                            }
                        }
                        .frame(width: 300)
                        .font(.custom("Quicksand-Regular", size: 20))
                        .disableAutocorrection(true)
                        .focused($textIsFocused)
                        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                }
            }
            .rotation3DEffect(.degrees(flipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
            
            Text("Tap card to flip")
                .padding(.top)
                .font(.custom("Quicksand-Regular", size: 16))
                .foregroundColor(.gray)
            
            if isEditing {
                Text("or click the text to edit")
                    .font(.custom("Quicksand-Regular", size: 16))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 100) {
                 if isEditing {
                    Button {
                        showingDeleteAlert.toggle()
                    } label: {
                        Text("Delete Flashcard")
                            .frame(width: 200)
                            .foregroundColor(Color("ButtonAction"))
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 1)
                                    .frame(width: 200)
                                    .foregroundColor(Color("ButtonAction"))
                        )
                    }
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(title: Text("Are you sure you want to delete this flashcard?"), message: nil, primaryButton: .destructive(Text("Delete"), action: {
                                UserDefaultsService.deleteFlashcard(flashcardId: flashcard!.flashcardId, deckId: deck.deckId)
                                dismiss()
                            }),
                              secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                }
            }
        }
        .onTapGesture {
            textIsFocused = false
            hideTop = false
        }
        .onAppear {
            if (flashcard != nil) {
                question = self.flashcard?.question ?? " "
                answer = self.flashcard?.answer ?? " "
            }
        }
        .preferredColorScheme(.light)
    }
}

struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFlashcardView(deck: LoadDecksFromJson().decks[0])
    }
}
