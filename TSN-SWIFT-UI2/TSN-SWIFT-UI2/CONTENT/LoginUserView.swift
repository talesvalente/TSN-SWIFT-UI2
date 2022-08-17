//
//  ContentView.swift
//  TSN-SWIFT-UI2
//
//  Created by Tales Valente on 16/08/22.
//

import SwiftUI
import Foundation


struct LoginUserView: View {
    @State private var email = ""
    @State private var password = ""
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                VStack {
                    Text("The Social Network")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    Text("Login Screen")
                     
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                    
                    Button("Login") {
                        Task {
                            await API.login(email: self.email, password: self.password)
                        }
                    }
                    NavigationLink(destination: Text("You are logged in@\(self.email)"), isActive: $showingLoginScreen) {
                        EmptyView()
                    }
                        
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
                    
                    .navigationBarHidden(true)

                }
            }
        }
    }
}
struct LoginUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
    
