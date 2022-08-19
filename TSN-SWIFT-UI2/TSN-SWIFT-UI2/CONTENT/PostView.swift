//
//  PostView.swift
//  TSN-SWIFT-UI2
//
//  Created by Tales Valente on 17/08/22.
//

import SwiftUI
import Foundation


struct PostView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var posts: [Post] = []
    @State var token: String?
    @State var displayAddPostView = false
    
    
    var body: some View {
        
        //VERIFICA SE TEM TOKEN OU NAO
        //Text(token ?? "[ERROR] TOKEN NOTE FOUND")]
        Text("Logged as: $USERNAME")
        
        NavigationView {
            List {
                ForEach(posts) { post in
                    VStack {
                        Text(post.content)
                        Text(post.user_id)
                        //VERIFICAR IDENFICACAO DE USUARIO
                        
                        .bold()
                    }
                }
            }
            
            .navigationTitle("Listagens Posts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationBarLink
                }
            }
            .sheet(isPresented: $displayAddPostView){
                AddPost(isPresented: $displayAddPostView)
            }
        }
        .navigationBarHidden(true)
        .task {
            posts = await API.default.getAllPosts()
        }
        Button("Logout") {
            Task {
                //await (API.default.logout(token: self.token!)) // TA BUGADO NAO DESLOGA
                if let token = token {
                    await API.default.logout(token: token)
                    dismiss()
                }
            }
            dismiss()
        }
        //CICLO DE VIDA DA VIEW
        .onAppear {
            token = getPassword()
        }
    }
    
    // ADD POST FUCTION ??
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
