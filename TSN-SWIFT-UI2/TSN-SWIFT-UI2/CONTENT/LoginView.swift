//
//  ContentView.swift
//  TSN-SWIFT-UI2
//
//  Created by Tales Valente on 16/08/22.
//

import SwiftUI
import Foundation


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showingLoginScreen = false
    @State private var showingAlert = false
    @State private var wrongEmail = 0
    @State private var wrongPassword = 0
    
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
                        .border(.red, width: CGFloat(wrongEmail))
                    
                        .alert("Usuário ou Senha Incorreta", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { wrongEmail = 0; wrongPassword = 0;}
                                }
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button("Login") {
                        Task {
                            if ((await API.default.login(email: self.email, password: self.password)) != nil) {
                                showingLoginScreen = true
                            } else {
                                print ("[DEBUG] SENHA INCORRETA")
                                wrongPassword = 2
                                wrongEmail = 2
                                showingAlert = true
                            }
                    
                        }
                    }
          
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
                    
                    .navigationBarHidden(true)

                    
                    HStack {
                        Text("Don't have an account yet?")
                        NavigationLink( "Sign Up", destination: CreateUserView())
                        
                         
                    }

                    //CORRIGIR ESTA BOSTA
                    NavigationLink(destination: PostView(), isActive: $showingLoginScreen) { EmptyView() }
                    
                    .navigationBarHidden(true)

                }
                .navigationBarHidden(true)

            }
            .navigationBarHidden(true)

        }
        .navigationBarHidden(true)

    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
    
