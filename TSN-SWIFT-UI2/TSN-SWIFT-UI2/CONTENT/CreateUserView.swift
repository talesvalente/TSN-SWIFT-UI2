//
//  ContentView.swift
//  TSN-SWIFT-UI2
//
//  Created by Tales Valente on 16/08/22.
//

import SwiftUI
import Foundation

//TODO MATRICULA/REGISTRY can not be empty
//TODO MATRICULA/REGISTRY MUST BE ONLY NUMBERS
//TODO the password cannot contain the username


struct CreateUserView: View {
    
    //Design Patter @State
    @State private var name = ""
    @State private var registry = ""
    @State private var password = ""
    @State private var accountExistsAlert = false
    @State private var accountCreationSucessful = false
    //@State private var teste = 0
    @ObservedObject private var userViewModel = FormViewModel()
    @State private var isPasswordVisible: Bool = false
    
    
    @State private var showRedAlert = 0

    init() {
        UITableView.appearance().sectionFooterHeight = 0
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("AVISOS - IFCE")
                        .font(.largeTitle)
                        .bold()
                    Text("Cadastro de Usuários")
                    
                
                    Form() {

                        Section(header: Text("Informe seu nome").font(.caption)) {
                            HStack {
                                TextField("Nome", text: $name)
                            }
                        }
                        
                        Section(header: Text("Informe sua Matrícula").font(.caption)) {
                            HStack {
                                TextField("Matrícula", text: $registry)
                            }
                            .border(.red, width: CGFloat(showRedAlert))

                        }

                        Section(header: Text("Crie sua senha").font(.caption)) {
                            HStack {
                                if isPasswordVisible {
                                    TextField("Senha", text: $userViewModel.password)
                                } else {
                                    SecureField("Senha", text: $userViewModel.password)
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
                            Button(action: { Task {
                                if ((await API.default.createUser(name: self.name, registry: self.registry, password: self.password)) == nil) {
                                    accountExistsAlert = true
                                    showRedAlert = 2
                                }
                                else {
                                    accountCreationSucessful = true
                                }
                            }}){
                                HStack(alignment: .center) {
                                    Spacer()
                                    Image(systemName: userViewModel.isValid ? "lock.open.fill" : "lock.fill")
                                    Text("Criar Usuário")
                                    Spacer()
                                }
                            }
                        }//TIPOGRAFIA RIG
                        .disabled(!userViewModel.isValid)
                        .animation(.default)
                       
                            
                    }
                
                    .listStyle(GroupedListStyle())
                    
                    .alert("Usário já registrado!", isPresented: $accountExistsAlert) {
                        Button("Tentar Novamente", role: .cancel){ showRedAlert = 0}}
                    
                    .alert("Usuário Registrado com sucesso!", isPresented: $accountCreationSucessful) {
                        Button("Fazer log-in!", role: .cancel) { dismiss() }}
                    

                    HStack {
                        Text("Você já tem uma conta?")
                        Button("Fazer login") {
                            dismiss()
                        }
                    }
                    
                }
            }// END OF V STACK
            .navigationBarHidden(true)
        } //END OF Z STACK
        .navigationBarHidden(true)
    }

}
struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
    
