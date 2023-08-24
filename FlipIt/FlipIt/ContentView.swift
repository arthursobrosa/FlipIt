//
//  ContentView.swift
//  FlipIt
//
//  Created by Arthur Sobrosa on 23/08/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingPopup = false
    @State private var decksFromUserDefaults: [Deck] = []
    @State private var presentCreateDeckView = false
    @State private var name = ""
    let index = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if decksFromUserDefaults != [] {
                    VStack(spacing: 5) {
                        ForEach(decksFromUserDefaults, id: \.self) { deck in
                            NavigationLink(destination: DeckView(deck: deck, name: deck.deckName, numberPerTest: deck.numberPerTest - 1)) {
                                DeckListView(deck: deck)
                            }
                            .padding([.top, .leading, .trailing])
                        }
                    }
                } else {
                    ForEach(index, id:\.self) { _ in
                        Spacer()
                    }
                    
                    VStack {
                        Image("Cards")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                        
                        Text("It looks like you haven't added any deck of flashcards yet! Try clicking on the plus button above.")
                            .foregroundColor(.gray)
                            .frame(width: 320)
                            .font(.custom("Quicksand-Regular", size: 20))
                    }
                }
            }
            .navigationTitle("My decks")
            .navigationBarItems(trailing:
                Button {
                    presentCreateDeckView.toggle()
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12)
                        .foregroundColor(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color("LightGray"))
                                .frame(width: 30, height: 30)
                        )
                }
                .padding(.trailing, 6.0)
            )
            .navigationBarTitleDisplayMode(.inline)
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                decksFromUserDefaults = UserDefaultsService.getDecks()
                presentCreateDeckView = false
                name = ""
                
            }
            .navigationDestination(isPresented: $presentCreateDeckView) {
                CreateDeckView(name: $name, numberPerTest: .constant(0), clickedSaveButton: .constant(false), clickedDeleteButton: .constant(false))
            }
            
//            .toolbarBackground(.visible, for: .navigationBar)
//            .toolbarBackground(Color("Header"), for: .navigationBar)
//            .toolbarColorScheme(.dark, for: .navigationBar)
            
        }
        .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
