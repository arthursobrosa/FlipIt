import SwiftUI

enum PossibleErrors: Error {
    case emptyText
    case sameName
}

func checkForEmptyTextError(_ text: String) throws {
    if text == "" {
        throw PossibleErrors.emptyText
    }
}

func checkForEmptyText(_ text: String) -> Bool {
    let text1 = text.trimmingCharacters(in: .whitespacesAndNewlines)

    do {
        try checkForEmptyTextError(text1)
        return false
    } catch {
        return true
    }
}

func checkForSameNameError(_ text: String) throws {
    let decks = UserDefaultsService.getDecks()
    
    for deck in decks {
        if text == deck.deckName {
            throw PossibleErrors.sameName
        }
    }
}

func checkForSameName(_ text: String) -> Bool {
    do {
        try checkForSameNameError(text)
        return false
    } catch {
        return true
    }
}

func checkForSameId(_ id: Int, _ name: String) -> Bool {
    let decks = UserDefaultsService.getDecks()
    
    for deck in decks {
        if name == deck.deckName {
            if id == deck.deckId {
                return true
            } else {
                return false
            }
        }
    }
    return true
}
