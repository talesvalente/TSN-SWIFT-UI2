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
    
    @State var token: String?
    
    var body: some View {
        
        //VERIFICA SE TEM TOKEN OU NAO
        Text(token ?? "[ERROR] TOKEN NOTE FOUND")
        
        Button("Logout") {
            Task {
                //await (API.default.logout(token: self.token!))
                await (API.default.logout(token: token!))
                dismiss()
            }
            dismiss()
        }
        
        //CICLO DE VIDA DA VIEW
        .onAppear {
            token = getPassword()
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
