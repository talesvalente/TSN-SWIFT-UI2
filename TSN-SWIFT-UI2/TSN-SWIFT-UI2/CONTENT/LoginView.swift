//
//  ContentView.swift
//  TSN-SWIFT-UI2
//
//  Created by Tales Valente on 16/08/22.
//

import SwiftUI
import Foundation


struct LoginView: View {
    
    @State private var wrongUserPass = 0
    @State private var registry = "" //MATRICULA
    @State private var password = ""
    @State private var showingAlert = false
    @State private var loginSuccessful = false

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
                    Text("AVISOS - IFCE")
                        .font(.largeTitle)
                        .bold()
                        //.padding()
                    
                    Text("Login - Campus Maracanaú")
                     
                    TextField("Matricula", text: $registry)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUserPass))
                    
                    SecureField("Senha", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUserPass))
                    
                    Button(action: {
                        Task {
                            let createUserResults = await API.default.login(registry: self.registry, password: self.password)
                            if (createUserResults != nil) {
                                loginSuccessful = true
                            }
                            else {
                                wrongUserPass = 2;
                                showingAlert = true
                            }
                        }
                    }) {
                        Text("Login")
                            .frame(width: 300, height: 50)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    

                    .navigationBarHidden(true)
                    
                    //Mostrar um alerta em caso de:
                    //Usuário Incorreto ou Senha Incorreta
                    //TIP: API DOENST SUPPORT UserLogin or UserPass check
                    .alert("Usuário ou Senha Incorreta", isPresented: $showingAlert) {
                        Button("Tente novamente!", role: .cancel) { wrongUserPass = 0}
                    }
                    
                    HStack {
                        Text("Ainda não tem uma conta?")
                        NavigationLink( "Cadastre-se", destination: CreateUserView())
                    }
                    
                    NavigationLink("", destination: PostView(), isActive: $loginSuccessful)
                }
            }
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
    
