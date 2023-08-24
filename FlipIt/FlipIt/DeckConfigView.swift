import SwiftUI

struct DeckConfigView: View {
    var deck: Deck
    @State private var showNotification = false
    @State private var alarme = Date()
    @State private var presentTimerView = false
    @State private var presentTimerViewEdit = false
    @State private var shouldUpdateTimerView = false
    @State private var showingAlert = false
    @State private var indexEdit = 0
    @State private var alarmsArray: [[Int]] = []
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Alarm")
                                .bold()
                                .font(.title3)
                            
                            Spacer()
                            
                            Button {
                                presentTimerView.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Divider()
                        
                        ForEach(alarmsArray.indices, id: \.self) { index in
                            let textHour = format(alarmsArray[index][0])
                            let textMinute = format(alarmsArray[index][1])
                            VStack {
                                HStack {
                                    Button {
                                        if (indexEdit != index) {
                                            indexEdit = index
                                        } else {
                                            presentTimerViewEdit.toggle()
                                        }
                                    } label: {
                                        VStack{
                                            HStack{
                                                VStack(alignment: .leading) {
                                                    Text("\(textHour):\(textMinute)")
                                                        .font(.title)
                                                        .foregroundColor(.black)
                                                    
                                                    Text("Alarm")
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                Spacer()
                                                
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        alarmsArray.remove(at: index)
                                    } label: {
                                        Image(systemName: "minus")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20)
                                            .foregroundColor(.red)
                                            
                                    }
                                }
                                
                                Divider()
                                
                            }
                        }
                    }
                }
                .padding(.trailing)
            }
            .navigationBarItems(leading:
                Button {
                showingAlert.toggle()
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color("Background"))
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Are you sure you want to quit? Your alarms will not be saved."), message: nil, primaryButton: .destructive( Text("Quit"), action: {
                            dismiss()
                        }),
                        secondaryButton: .cancel(Text("Continue"))
                    )
                }
            )
            .navigationTitle("Notifications")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("Header"), for: .navigationBar)
            .navigationBarItems(trailing:
                Button {
                
                    ReminderNotification.removeNotifications(deckId: deck.deckId) {
                        ReminderNotification.setupNotifications(deckId: deck.deckId, notificationText: deck.deckName, times: alarmsArray)
                            dismiss()
                    }
                
               
                } label : {
                    Text("Save")
                        .foregroundColor(Color("Background"))
                }
            )
            .padding([.top, .leading])
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
                ReminderNotification.listNotifications(deckId: deck.deckId) { alarms in
                        self.alarmsArray = alarms
                }
            }
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

struct DeckConfigView_Previews: PreviewProvider {
    static var previews: some View {
        DeckConfigView(deck: LoadDecksFromJson().decks[0])
    }
}
