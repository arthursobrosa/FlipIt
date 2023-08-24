//
//  DeckListView.swift
//  FlipIt
//
//  Created by Arthur Sobrosa on 24/08/23.
//

import SwiftUI

struct DeckListView: View {
    var deck: Deck
    var body: some View {
        Rectangle().fill(Color("Header").gradient)
            .frame(height: 100)
            .cornerRadius(12)
            .overlay(
                VStack(alignment: .leading, spacing: 17) {
                    Text(deck.deckName)
                        .font(.custom("Quicksand-Regular", size: 25))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("ButtonAction"))
                        .lineLimit(1)
                    
                    if deck.flashcards.count == 1 {
                        Text("\(deck.flashcards.count) card")
                            .font(.custom("Quicksand-Regular", size: 18))
                            .foregroundColor(.white)
                    } else {
                        Text("\(deck.flashcards.count) cards")
                            .font(.custom("Quicksand-Regular", size: 18))
                            .foregroundColor(.white)
                    }
                }
                    .padding(.leading)
        )
    }
}

struct DeckListView_Previews: PreviewProvider {
    static var previews: some View {
        DeckListView(deck: LoadDecksFromJson().decks[0])
    }
}
