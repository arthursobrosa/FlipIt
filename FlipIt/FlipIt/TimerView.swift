import SwiftUI

struct TimerView: View {
    @State private var alarme = Date()
    @State private var show = false
    @State private var showingAlert = false
    var hourRecieved: Int
    var minuteRecieved: Int
    var index: Int
    var isEditing: Bool
    
    @Environment(\.dismiss) var dismiss
    @Binding var alarmsArray: [[Int]]
    
    init(alarmsArray: Binding<[[Int]]>) {
        self._alarmsArray = alarmsArray
        hourRecieved = 19
        minuteRecieved = 30
        index = 0
        isEditing = false
    }
    
    init(alarmsArray: Binding<[[Int]]>, hourRecieved: Int, minuteRecieved: Int, index: Int) {
        self._alarmsArray = alarmsArray
        self.hourRecieved = hourRecieved
        self.minuteRecieved = minuteRecieved
        self.index = index
        isEditing = true
    }
    
    var numero = 15
    
    var body: some View {
        NavigationStack{
            VStack {
                DatePicker("", selection: $alarme, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()

                
                ZStack {
                    RoundedRectangle(cornerRadius: 20).fill(Color("Header").gradient)
                        .frame(width: 320, height: 150)
                    
                    Text("When you set an alarm for your deck, the app notifies at that chosen time so you can practice and memorize the contents of its flashcards.")
                        .font(.custom("Quicksand-Regular", size: 18))
                        .frame(width: 300)
                    .foregroundColor(Color("ButtonAction"))
                }
                
                Spacer()
                
                Spacer()
                                
                HStack {
                    if isEditing {
                        Button {
                            alarmsArray.remove(at: index)
                            dismiss()
                        } label: {
                            Text("Delete Alarm")
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
                    }
                }
            }
            .onAppear {
                var components = DateComponents()
                components.hour = hourRecieved
                components.minute = minuteRecieved
                
                alarme = Calendar.current.date(from: components)!
            }
            .navigationTitle("Add alarm")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                Button {
                    showingAlert = true
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color("ButtonAction"))
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Are you sure you want to go back?"), message: nil, primaryButton: .destructive( Text("Yes"), action: {
                        dismiss()
                    }),
                          secondaryButton: .cancel(Text("No"))
                    )
                }
            )
            .navigationBarItems(trailing:
                Button {
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: alarme)
                    let minute = calendar.component(.minute, from: alarme)

                    if !isEditing {
                        let hourAndMinute: [Int] = [hour, minute]
                        alarmsArray.append(hourAndMinute)
                    } else {
                        alarmsArray[index][0] = hour
                        alarmsArray[index][1] = minute
                    }

                    dismiss()
                } label: {
                    Text("Save")
                        .foregroundColor(Color("ButtonAction"))
                }
            )
        }
        .preferredColorScheme(.light)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(alarmsArray: .constant([[1, 2]]))
    }
}
