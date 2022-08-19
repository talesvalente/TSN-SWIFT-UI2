//
//  TSN_SWIFT_UI2App.swift
//  TSN-SWIFT-UI2
//
//  Created by Tales Valente on 16/08/22.
//

import SwiftUI

@main
struct TSN_SWIFT_UI2App: App {
   
    //@State var isNotConnected = false
    
    var body: some Scene {
        WindowGroup {
            LoginView()

        }
    }
}

//JUNK
//.onAppear {
//     API.default.checkConection()
//
// }

/*
PostView(isNotConnected: $isNotConnected)
    .fullScreenCover(isPresented: $isNotConnected) {
        LoginView(isNotConnected: $isNotConnected)
    }
    .onAppear {
        if getPassword() ==  nil {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                isNotConnected = true
            }
        }
    }
 */
