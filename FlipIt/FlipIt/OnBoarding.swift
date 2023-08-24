//
//  OnBoarding.swift
//  FlipIt
//
//  Created by Arthur Sobrosa on 23/08/23.
//

import SwiftUI

struct OnBoarding: View {
    @State private var presentContentView = false
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color("Header").gradient)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image("Cards")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                
                Spacer()
                
                Spacer()
                
                Button {
                    presentContentView.toggle()
                } label: {
                    Text("Get Started")
                        .foregroundColor(Color("ButtonAction"))
                        .font(.custom("Quicksand-Regular", size: 18))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 320)
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .fullScreenCover(isPresented: $presentContentView) {
            ContentView()
        }
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding()
    }
}
