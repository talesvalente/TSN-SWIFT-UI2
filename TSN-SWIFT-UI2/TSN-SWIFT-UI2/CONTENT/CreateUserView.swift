//
//  ContentView.swift
//  TSN-SWIFT-UI2
//
//  Created by Tales Valente on 16/08/22.
//

import SwiftUI
import Foundation


struct CreateUserView: View {
    
    //Design Patter @State
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var accountExistsAlert = false
    @State private var accountCreationSucessful = false
    //@State private var teste = 0
    @ObservedObject private var userViewModel = FormViewModel()
    @State private var isPasswordVisible: Bool = false
    
    
    init() {
        UITableView.appearance().sectionFooterHeight = 0
    }
    
    @Environment(\.dismiss) var dismiss
    
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
                    
                    Text("Registration Screen")
                    
//                    TextField("Name", text: $name)
//                        .padding()
//                        .frame(width: 300, height: 50)
//                        .background(Color.black.opacity(0.05))
//                        .cornerRadius(10)
//                        .alert("User already registered!", isPresented: $accountExistsAlert) {
//                            Button("OK", role: .cancel){}}
//                        .alert("User registration sucessful!", isPresented: $accountCreationSucessful) {
//                            Button("Sign-in Now!", role: .cancel) { dismiss() }}
//
//                    TextField("Email", text: $email)
//                        .padding()
//                        .frame(width: 300, height: 50)
//                        .background(Color.black.opacity(0.05))
//                        .cornerRadius(10)
                    Form() {
                        
                        Section(header: Text("Inform your name").font(.caption)) {
                            HStack {
                                TextField("Name", text: $name)
                                .alert("User already registered!", isPresented: $accountExistsAlert) {
                                    Button("OK", role: .cancel){}}
                                .alert("User registration sucessful!", isPresented: $accountCreationSucessful) {
                                    Button("Sign-in Now!", role: .cancel) { dismiss() }}
                            }
                        }
                        Section(header: Text("Inform your email").font(.caption)) {
                            HStack {
                                TextField("Email", text: $email)
                                .alert("User already registered!", isPresented: $accountExistsAlert) {
                                    Button("OK", role: .cancel){}}
                                .alert("User registration sucessful!", isPresented: $accountCreationSucessful) {
                                    Button("Sign-in Now!", role: .cancel) { dismiss() }}
                            }
                        }
                        
                        Section(header: Text("Create your password").font(.caption)) {
                            HStack {
                                if isPasswordVisible {
                                    TextField("Password", text: $userViewModel.password)
                                } else {
                                    SecureField("Password", text: $userViewModel.password)
                                }
                                
                                Spacer().frame(width: 10)
                                
                                Button(action: {}, label: {
                                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                        .foregroundColor( isPasswordVisible ? .green : .gray)
                                        .frame(width: 20, height: 20, alignment: .center)
                                })
                                .onTapGesture { self.isPasswordVisible.toggle() }
                            }
                            
                            List(userViewModel.validations) { validation in
                                HStack {
                                    Image(systemName: validation.state == .success ? "checkmark.circle.fill" : "checkmark.circle")
                                        .foregroundColor(validation.state == .success ? Color.green : Color.gray.opacity(0.3))
                                    Text(validation.validationType.message(fieldName: validation.field.rawValue))
                                        .strikethrough(validation.state == .success)
                                        .font(Font.caption)
                                        .foregroundColor(validation.state == .success ? Color.gray : .black)
                                }
                                .padding([.leading], 15)
                            }
                        }
                        
                        Section {
                            Button(action: {
                                // Action...
                            }){
                                HStack(alignment: .center) {
                                    Spacer()
                                    Image(systemName: userViewModel.isValid ? "lock.open.fill" : "lock.fill")
                                    Text("Create")
                                    Spacer()
                                }
                            }
                            .disabled(!userViewModel.isValid)
                            .animation(.default)
                        }
                    }
                    .listStyle(GroupedListStyle())
                
                    
//                    SecureField("Password", text: $password)
//                        .padding()
//                        .frame(width: 300, height: 50)
//                        .background(Color.black.opacity(0.05))
//                        .cornerRadius(10)
                    
//                    Button("Create User") {
//                        Task {
//                            if ((await API.default.createUser(name: self.name, email: self.email, password: self.password)) == nil) {
//                                accountExistsAlert = true
//                            }
//                            //TODO VALIDATION
//                            //https://betterprogramming.pub/how-to-validate-complex-passwords-in-swiftui-b982cd326912#:~:text=Validation%20Rules,-For%20this%20example&text=Password%20must%20not%20be%20empty,at%20least%20one%20uppercase%20letter.
//                            else {
//                                accountCreationSucessful = true
//                            }
//                        }
//                    }
//                    .foregroundColor(.white)
//                    .frame(width: 300, height: 50)
//                    .background(Color.red)
//                    .cornerRadius(10)
//                    .navigationBarHidden(true)

                    HStack {
                        Text("Do you have a account?")
                        Button("Sign In") {
                            dismiss()
                        }
                    }
                    
                    .navigationBarHidden(true)
                }
                .navigationBarHidden(true)
            }
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)

    }

}
struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
    
