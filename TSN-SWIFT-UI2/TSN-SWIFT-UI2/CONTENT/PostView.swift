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
        
        Text("Logged as: $USERNAME")
        
        .navigationBarHidden(true)
        
        //Text(token ?? "[ERROR] TOKEN NOTE FOUND")
        //Text(token ?? "[ERROR] TOKEN NOTE FOUND")]

        NavigationView {
            List {
                ForEach(posts) { post in
                    VStack {
                        Text(post.content)
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
                AddPostView(isPresented: $displayAddPostView)
            }
        }
        //SILENT THE WARNINGS ABOUT CONSTRAINTS
        .navigationViewStyle(.stack)

        .task {
            posts = await API.default.getAllPosts()
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
