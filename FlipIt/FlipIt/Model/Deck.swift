//
//  Deck.swift
//  FlipIt
//
//  Created by Arthur Sobrosa on 24/08/23.
//

import Foundation
import SwiftUI

struct Deck: Hashable, Codable {
    var deckId: Int
    var deckName: String
    var complete: Bool
    var numberPerTest: Int
    var flashcards: [Flashcard]
    var times: [[Int]]
    var notificationActive: Bool
    var alarm: Bool
    var vibrate: Bool
}

struct Flashcard: Hashable, Codable {
    var flashcardId: Int
    var question: String
    var answer: String
}
