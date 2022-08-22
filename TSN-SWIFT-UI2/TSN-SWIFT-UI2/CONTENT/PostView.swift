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

        Button("Logout") {
            Task {
                if (await API.default.logout(token: self.token!) != nil) {
                    dismiss()
                }
                else {
                    
                }
            }
        }
        //CICLO DE VIDA DA VIEW
        .onAppear {
            self.token = getPassword()
        }
    }

}



struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
