import SwiftUI

enum ActiveAlertDeck {
    case emptyText, sameNameText
}

struct CreateDeckView: View {
    @FocusState private var textIsFocused: Bool

    @State private var newDeck: Deck? = nil
    @State private var showingAlert = false
    @State private var showingTextAlert = false
    @State private var showingDeleteAlert = false
    @State private var activeAlert: ActiveAlertDeck = .emptyText
    @State private var presentDeckView = false
    
    @State private var showNotification = false
    @State private var alarme = Date()
    @State private var presentTimerView = false
    @State private var presentTimerViewEdit = false
    @State private var shouldUpdateTimerView = false
    @State private var showingAlarmAlert = false
    @State private var indexEdit = 0
    @State private var alarmsArray: [[Int]] = []

    @Environment(\.dismiss) var dismiss

    var isEditing: Bool
    var deck: Deck
    @Binding private var name: String
    @Binding private var numberPerTest: Int
    @Binding var clickedSaveButton: Bool
    @Binding var clickedDeleteButton: Bool

    init(isEditing: Bool, deck: Deck, name: Binding<String>, numberPerTest: Binding<Int>, clickedSaveButton: Binding<Bool>, clickedDeleteButton: Binding<Bool>) {
        self.isEditing = isEditing
        self.deck = deck
        self._name = name
        self._numberPerTest = numberPerTest
        self._clickedSaveButton = clickedSaveButton
        self._clickedDeleteButton = clickedDeleteButton
    }

    init(name: Binding<String>, numberPerTest: Binding<Int>, clickedSaveButton: Binding<Bool>, clickedDeleteButton: Binding<Bool>) {
        isEditing = false
        deck = LoadDecksFromJson().decks[0]
        self._name = name
        self._numberPerTest = numberPerTest
        self._clickedSaveButton = clickedSaveButton
        self._clickedDeleteButton = clickedDeleteButton
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                
                VStack(alignment: .leading) {
                    
                    HStack(spacing: geometry.size.width * 0.25) {
                        
                        VStack(alignment: .leading, spacing: 30) {
                            if isEditing && deck.flashcards.count != 0 {
                                Text("Name of the deck")
                                    .font(.custom("Quicksand-Regular", size: 16))
                                    .padding(.top, 24.0)
                            } else {
                                Text("Name of the deck")
                                    .font(.custom("Quicksand-Regular", size: 16))
                            }
                                
                            if isEditing && deck.flashcards.count != 0 {
                                Text("Number per test")
                                    .font(.custom("Quicksand-Regular", size: 16))
                                    .padding(.bottom)
                            }
                        }

                        VStack {
                            
                            ZStack {
                                Rectangle()
                                    .frame(width: geometry.size.width * 0.35, height: 40)
                                    .foregroundColor(Color("Header"))
                                    .cornerRadius(10)
                                
                                TextField("", text: $name)
                                    .onChange(of: name) { _ in
                                        if name.count > 100 {
                                            name = String(name.prefix(100))
                                        }
                                    }
                                    .padding()
                                    .disableAutocorrection(true)
                                    .focused($textIsFocused)
                                    .foregroundColor(Color("ButtonAction"))
                                    .font(.custom("Quicksand-Regular", size: 16))
                            }
                            
                            if isEditing && deck.flashcards.count != 0 {
                                ZStack {
                                    Rectangle()
                                        .frame(width: geometry.size.width * 0.35, height: 40)
                                        .foregroundColor(Color("Header"))
                                        .cornerRadius(10)
                                    
                                    if isEditing {
                                        if deck.flashcards.count == 0 {
                                            Picker("Number per test", selection: $numberPerTest) {
                                                ForEach(1 ..< 11) {
                                                    if $0 == 1 {
                                                        Text("\($0) flashcard")
                                                            .font(.custom("Quicksand-Regular", size: 16))
                                                    } else {
                                                        Text("\($0) flashcards")
                                                            .font(.custom("Quicksand-Regular", size: 16))
                                                    }
                                                }
                                            }
                                        } else {
                                            Picker("Number per test", selection: $numberPerTest) {
                                                ForEach(1 ..< deck.flashcards.count + 1) {
                                                    if $0 == 1 {
                                                        Text("\($0) flashcard")
                                                            .font(.custom("Quicksand-Regular", size: 16))
                                                    } else {
                                                        Text("\($0) flashcards")
                                                            .font(.custom("Quicksand-Regular", size: 16))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.trailing)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Alarms")
                                .font(.custom("Quicksand-Regular", size: 16))
                                .bold()
                            
                            Spacer()
                            
                            Button {
                                presentTimerView.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.038)
                                    .foregroundColor(Color("ButtonAction"))
                            }
                            .padding(.trailing)
                        }
                        .padding(.top)
                        
                        if alarmsArray.count != 0 {
                            ForEach(alarmsArray.indices, id: \.self) { index in
                                let textHour = format(alarmsArray[index][0])
                                let textMinute = format(alarmsArray[index][1])

                                Button {
                                    if indexEdit != index {
                                        indexEdit = index
                                    } else {
                                        presentTimerViewEdit.toggle()
                                    }
                                } label: {
                                    Text("\(textHour):\(textMinute)")
                                        .font(.title)
                                        .foregroundColor(Color("ButtonAction"))
                                }
                                
                                if index + 1 != alarmsArray.count {
                                    Divider()
                                }
                            }
                            .padding(.trailing)
                        } else {
                            HStack(alignment: .center) {
                                Image("AlarmImage")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120)
                                
                                Spacer()
                                
                                Text("Add an alarm to be notified when to practice this deck! Try clicking on the plus button above.")
                                    .foregroundColor(.gray)
                                    .font(.custom("Quicksand-Regular", size: 16))
                                    .padding(.trailing)
                                    .frame(width: 210)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if isEditing {
                        HStack {
                            Spacer()
                            
                            Button {
                                showingDeleteAlert.toggle()
                                clickedDeleteButton.toggle()
                            } label: {
                                Text("Delete Deck")
                                    .frame(width: 109)
                                    .foregroundColor(Color("ButtonAction"))
                                    .font(.custom("Quicksand-Regular", size: 18))
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 1)
                                            .frame(width: 200)
                                            .foregroundColor(Color("ButtonAction"))
                                )
                            }
                            .alert(isPresented: $showingDeleteAlert) {
                                Alert(title: Text("Are you sure you want to delete this deck?"), message: nil, primaryButton: .destructive(Text("Delete"), action: {
                                    UserDefaultsService.deleteDeck(deck.deckId)
                                    
                                    ReminderNotification.removeNotifications(deckId: deck.deckId) {
                                    }
                                    
                                    dismiss()
                                    
                                    }),
                                      secondaryButton: .cancel(Text("Cancel"))
                                )
                            }
                            
                            Spacer()
                        }
                        .padding(.trailing)
                    }
                    
                }
                .padding(.leading)
                .navigationTitle(isEditing ? "Edit deck" : "Create deck")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(trailing:
                    Button {
                        let empty = checkForEmptyText(name)
                        let sameName = checkForSameName(name)
                            
                        if !empty && !sameName {
                                if !isEditing {
                                    UserDefaultsService.createDeckByName(name: name, number: 1)
                                    newDeck = UserDefaultsService.getDeckByName(deckName: name)
                                    
                                    ReminderNotification.setupNotifications(deckId: newDeck!.deckId, notificationText: newDeck!.deckName, times: alarmsArray)
                                    
                                    dismiss()
                                } else {
                                    UserDefaultsService.modifyDeckName(deckId: deck.deckId, value: name)
                                    
                                    UserDefaultsService.modifyDeckNumberPerTest(deckId: deck.deckId, value: numberPerTest + 1)
                                   
                                    ReminderNotification.removeNotifications(deckId: deck.deckId) {
                                        ReminderNotification.setupNotifications(deckId: deck.deckId, notificationText: deck.deckName, times: alarmsArray)
                                    }
                                    
                                    clickedSaveButton = true
                                    
                                    dismiss()
                                }
                            
                        } else if empty && !sameName {
                            activeAlert = .emptyText
                            showingTextAlert = true
                        } else if !empty && sameName {
                            if !isEditing {
                                activeAlert = .sameNameText
                                showingTextAlert = true
                            } else {
                                if checkForSameId(deck.deckId, name) {
                                    UserDefaultsService.modifyDeckName(deckId: deck.deckId, value: name)
                                    
                                    UserDefaultsService.modifyDeckNumberPerTest(deckId: deck.deckId, value: numberPerTest + 1)
                                    
                                    ReminderNotification.removeNotifications(deckId: deck.deckId) {
                                        ReminderNotification.setupNotifications(deckId: deck.deckId, notificationText: deck.deckName, times: alarmsArray)
                                    }
                                    
                                    clickedSaveButton = true
                                    
                                    dismiss()
                                } else {
                                    activeAlert = .sameNameText
                                    showingTextAlert = true
                                }
                            }
                        }
                    } label: {
                        Text("Save")
                            .foregroundColor(Color("ButtonAction"))
                    }
                    .alert(isPresented: $showingTextAlert) {
                        switch activeAlert {
                        case .emptyText:
                            return Alert(title: Text("Please, choose a name for the deck"), dismissButton: .default(Text("Try again")))
                        case .sameNameText:
                            return Alert(title: Text("This deck name already exists"), dismissButton: .default(Text("Try again")))
                        }
                    }
                    .foregroundColor(isEditing ? Color("ButtonAction") : Color("AccentColor"))
                    
                )
                .navigationBarItems(leading:
                    Button {
                        if !isEditing {
                            showingAlert.toggle()
                        } else {
                            dismiss()
                        }
                    } label: {
                        if !isEditing {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("ButtonAction"))
                        } else {
                            Text("Cancel")
                                .foregroundColor(Color("ButtonAction"))
                        }
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(isEditing ? "Are you sure you want to quit editing? Your alterations will be dismissed." : "Are you sure you want to quit this creation? Your alterations will be dismissed."), message: nil, primaryButton: .destructive( Text("Quit"), action: {
                                dismiss()
                            }),
                              secondaryButton: .cancel(Text("Stay"))
                        )
                    }
                    .foregroundColor(isEditing ? Color("ButtonAction") : Color("AccentColor"))
                )
            }
        }
        .fullScreenCover(isPresented: $presentTimerView) {
            TimerView(alarmsArray: $alarmsArray)
        }
        .onChange(of: indexEdit) { _ in
            presentTimerViewEdit.toggle()
        }
        .fullScreenCover(isPresented: $presentTimerViewEdit) {
            TimerView(alarmsArray: $alarmsArray, hourRecieved: alarmsArray[indexEdit][0], minuteRecieved: alarmsArray[indexEdit][1], index: indexEdit)
                .id(shouldUpdateTimerView)
        }
        .onAppear {
            if isEditing {
                ReminderNotification.listNotifications(deckId: deck.deckId) { alarms in
                    self.alarmsArray = alarms
                }
            }
            
            clickedSaveButton = false
            clickedDeleteButton = false
        }
        .preferredColorScheme(.light)
    }
    
    func format(_ number: Int) -> String {
        if number < 10 {
            return "0\(number)"
        }
        return "\(number)"
    }
}

struct CreateDeckView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDeckView(name: .constant(""), numberPerTest: .constant(1), clickedSaveButton: .constant(false), clickedDeleteButton: .constant(false))
    }
}
