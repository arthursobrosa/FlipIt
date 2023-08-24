import Foundation

class UserDefaultsService {
    
//    // MARK: - Set FirstTime
//    static func setFirstTime() {
//        UserDefaults.standard.set(1, forKey: "FirstTime")
//    }
//
//    // MARK: - Get FirstTime
//    static func isFirstTime() -> Bool {
//        return UserDefaults.standard.object(forKey: "FirstTime") == nil
//    }
    
    

    // MARK: - Create Deck
    static func createDeck(_ deck: Deck) {
        var currentDecks = self.getDecks()
        
        currentDecks.append(deck)
        
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
    }
    
    // MARK: - Create Deck By Name
    static func createDeckByName(name: String, number: Int) {
        var currentDecks = self.getDecks()
        
        let lastId = currentDecks.last?.deckId ?? 0
        
        let deck = Deck(deckId: lastId + 1, deckName: name, complete: false, numberPerTest: number, flashcards: [], times: [[]], notificationActive: true, alarm: true, vibrate: true)
        
        currentDecks.append(deck)
        
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
    }
    
    // MARK: - Delete Deck
    static func deleteDeck(_ id: Int) {
        var currentDecks = self.getDecks()
        
        guard let deckIndex = currentDecks.firstIndex(where: { $0.deckId == id }) else {
            return
        }
        
        currentDecks.remove(at: deckIndex)
        
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
    }

    // MARK: - List Decks
    static func getDecks() -> [Deck] {
        guard let data = UserDefaults.standard.data(forKey: "Decks"), let decks = try? JSONDecoder().decode([Deck].self, from: data) else {
            
            return []
        }
        
        return decks
    }
    
    // MARK: - Get Deck by Id
    static func getDeckById(deckId: Int) -> Deck? {
        let currentDecks = self.getDecks()
        
        guard let deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return nil
        }
        
        return deckWithId
    }

    // MARK: - Create Flashcard
    static func addFlashcard(question: String, answer: String, deckId: Int) {
        var currentDecks = self.getDecks()
        
        guard var deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return
        }
        let index = currentDecks.firstIndex(where: { $0.deckId == deckId }) ?? 0
        
        let lastId  = deckWithId.flashcards.last?.flashcardId ?? 0
        
        let flashcard = Flashcard(flashcardId: lastId + 1, question: question, answer: answer)
        
        deckWithId.flashcards.append(flashcard)
        
        currentDecks[index] = deckWithId
                
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
    }
    
    // MARK: - Delete Flashcard
    static func deleteFlashcard(flashcardId: Int, deckId: Int) {
        var currentDecks = self.getDecks()
        
        guard var deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return
        }
        
        let index = currentDecks.firstIndex(where: { $0.deckId == deckId }) ?? 0
        
        guard let indexFlashcard = deckWithId.flashcards.firstIndex(where: { $0.flashcardId == flashcardId }) else {
            return
        }
        
        deckWithId.flashcards.remove(at: indexFlashcard)
        
        currentDecks[index] = deckWithId
                
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
    }
    
    // MARK: - Get Flashcard by Id
    static func getFlashcardById(flashcardId: Int, deckId: Int) -> Flashcard? {
        let currentDecks = self.getDecks()
        
        guard let deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return nil
        }
        
        guard let indexFlashcard = deckWithId.flashcards.firstIndex(where: { $0.flashcardId == flashcardId }) else {
            return nil
        }
        
        return deckWithId.flashcards[indexFlashcard]
    }
    
    // MARK: - Get Deck by Name
       static func getDeckByName(deckName: String) -> Deck? {
           let currentDecks = self.getDecks()
           
           guard let deckWithName = currentDecks.first(where: { $0.deckName == deckName }) else {
               return nil
           }
           
           return deckWithName
       }
    
    // MARK: - List Flashcards
    static func getFlashcards(deckId: Int) -> [Flashcard] {
        let currentDecks = self.getDecks()
        
        guard let deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return []
        }
        
        return deckWithId.flashcards
    }

    // MARK: - Modify Deck Name
    static func modifyDeckName(deckId: Int, value: String) {
        
        var currentDecks = self.getDecks()
        
        guard let deckIndex = currentDecks.firstIndex(where: { $0.deckId == deckId }) else {
            return
        }
        
        guard var deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return
        }
        
        deckWithId.deckName = value
        
        currentDecks[deckIndex] = deckWithId
        
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
    }
    
    // MARK: - Modify Flashcard Question and Answer
    static func modifyFlashcardQA(deckId: Int, flashcardId: Int, question: String, answer: String) {

        var currentFlashcards = getFlashcards(deckId: deckId)
        
        guard let flashcardIndex = currentFlashcards.firstIndex(where: { $0.flashcardId == flashcardId }) else {
            return
        }
        
        guard var flashcard = getFlashcardById(flashcardId: flashcardId, deckId: deckId) else {
            return
        }
        
        flashcard.question = question
        flashcard.answer = answer
        
        currentFlashcards[flashcardIndex] = flashcard
        
        var currentDecks = getDecks()
        
        guard let deckIndex = currentDecks.firstIndex(where: { $0.deckId == deckId }) else {
            return
        }
        
        guard var deckWithId  = currentDecks.first(where: { $0.deckId == deckId }) else {
            return
        }
        
        deckWithId.flashcards = currentFlashcards
        
        currentDecks[deckIndex] = deckWithId
        
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
    }
    
    // MARK: - Modify Deck Complete
    static func modifyDeckComplete(deckId: Int, value: Bool) {
        
        var currentDecks = self.getDecks()
        
        guard let deckIndex = currentDecks.firstIndex(where: { $0.deckId == deckId }) else {
            return
        }
        
        guard var deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return
        }
        
        deckWithId.complete = value
        
        currentDecks[deckIndex] = deckWithId
        
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
    }
    
    // MARK: - Modify Deck NumberPerTest
    static func modifyDeckNumberPerTest(deckId: Int, value: Int) {
        
        var currentDecks = self.getDecks()
        
        guard let deckIndex = currentDecks.firstIndex(where: { $0.deckId == deckId }) else {
            return
        }
        
        guard var deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return
        }
        
        deckWithId.numberPerTest = value
        
        currentDecks[deckIndex] = deckWithId
        
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
        
    }
    
    // MARK: - Modify Deck NotificationActive
    static func modifyDeckNotificationActive(deckId: Int, value: Bool) {
        
        var currentDecks = self.getDecks()
        
        guard let deckIndex = currentDecks.firstIndex(where: { $0.deckId == deckId }) else {
            return
        }
        
        guard var deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return
        }
        
        deckWithId.notificationActive = value
        
        currentDecks[deckIndex] = deckWithId
        
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
        
    }
    
    // MARK: - Modify Deck Vibrate
    static func modifyDeckVibrate(deckId: Int, value: Bool) {
        
        var currentDecks = self.getDecks()
        
        guard let deckIndex = currentDecks.firstIndex(where: { $0.deckId == deckId }) else {
            return
        }
        
        guard var deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return
        }
        
        deckWithId.vibrate = value
        
        currentDecks[deckIndex] = deckWithId
        
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
        
    }
    
    // MARK: - Modify Deck Alarm
    static func modifyDeckAlarm(deckId: Int, value: Bool) {
        
        var currentDecks = self.getDecks()
        
        guard let deckIndex = currentDecks.firstIndex(where: { $0.deckId == deckId }) else {
            return
        }
        
        guard var deckWithId = currentDecks.first(where: { $0.deckId == deckId }) else {
            return
        }
        
        deckWithId.alarm = value
        
        currentDecks[deckIndex] = deckWithId
        
        if let data = try? JSONEncoder().encode(currentDecks) {
            UserDefaults.standard.set(data, forKey: "Decks")
        }
        
    }
}
