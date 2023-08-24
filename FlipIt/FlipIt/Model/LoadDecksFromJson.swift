//
//  LoadDecksFromJson.swift
//  FlipIt
//
//  Created by Arthur Sobrosa on 24/08/23.
//

import Foundation
import Combine
import SwiftUI

final class LoadDecksFromJson {
    var decks: [Deck] {
//        if UserDefaultsService.isFirstTime() {
//            putDecksFromJsonInUserDefaults()
//            UserDefaultsService.setFirstTime()
//        }
        
        return loadArrayOfDecksFromJson()
    }
}

func loadArrayOfDecksFromJson() -> [Deck] {
    guard let jsonUrl = Bundle.main.url(forResource: "deckData", withExtension: "json") else {
        fatalError("Cannot find data.json file")
    }
    
    guard let jsonData = try? Data(contentsOf: jsonUrl) else {
        fatalError("Cannot find data.json file")
    }
    
    let decoder = JSONDecoder()
    
    do {
        let decks = try decoder.decode([Deck].self, from: jsonData)
        return decks
    } catch {
        print("Error decoding JSON: \(error)")
    }
    return []
}

func putDecksFromJsonInUserDefaults() {
    let decks = loadArrayOfDecksFromJson()
    
    for deck in decks {
        UserDefaultsService.createDeck(deck)
    }
}
