//
//  PostView.swift
//  TSN-SWIFT-UI2
//
//  Created by Tales Valente on 17/08/22.
//

import SwiftUI
import Foundation

struct UserView: View {
    
    @State var user: User?
    
    let userID: String
    
    var body: some View {
        Text("\(user?.name ?? "Nil")")
            .bold()
            .task {
                self.user = await API.default.getUserByID(id: userID)
            }
    }
    
}


struct PostView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var posts: [Post] = []
    @State var token: String?
    @State var displayAddPostView = false
    @State var userName: String?
    
    var body: some View {
        
        Text("Logged as: \(userName ?? "None")")
        .navigationBarHidden(true)

        NavigationView {
            List {
                ForEach(posts) { post in
                    VStack {
                        
                        Text(post.id)
                        Text(post.content)
                        Text(post.user_id)
                        Text(post.created_at)
                        Text(post.updated_at)
                        UserView(userID: post.user_id)
                    }
                   //POST TEM USER_ID
                    //COMO CHAMAR A FUNCÃO PARA PEGAR O USERNAME COM O USER_ID
                    //PODE PEGAR O USERNAME SÓ COM USER_ID (SEM TOKEN) ?
                    
                    
                }
            }
            
            .navigationTitle("Listagens Posts")

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationBarLink
                }
            }
            
            .sheet(
                isPresented: $displayAddPostView,
                onDismiss: {
                    Task {
                        posts = await API.default.getAllPosts()
                    }
                }
            ){
                AddPostView(isPresented: $displayAddPostView)
            }
        }
        //SILENT THE WARNINGS ABOUT CONSTRAINTS
        .navigationViewStyle(.stack)

        .task {
            posts    = await API.default.getAllPosts()

            userName = await API.default.getUserByToken(token: self.token!)?.name
        }
        
        Button("Logout") {
            Task {
                if (await API.default.logout(token: self.token!) != nil) {
                    dismiss()
                }
                else {
                    
                }
            }
        }
        .onAppear {
            self.token = getPassword()
        }
    }
    private var navigationBarLink: some View {
            HStack{
                Button {
                    displayAddPostView = true
                } label: {
                    Image(systemName: "plus")
                        .labelStyle(.titleAndIcon)
                        .font(.system(.body, design: .rounded).weight(.medium))
                }
                Spacer()
            }
    }

}



struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}


//VERIFICAR API FUNCAO DE PEGAR USARIO PELO ID E IDENTIFICAR O NOME
//http://127.0.0.1:8080/users/
//LEMBRAR QUE EXISTE USUARIO VAZIO
// VERIFICA SE userName é optional ou nao
//        if let userName = userName {
//            Text("Logged as: \(userName)")
//        }
//
//let user = await API.default.getUserByToken(token: self.token!)
//userName = user?.name
