//
//  TSN_SWIFT_UI2App.swift
//  TSN-SWIFT-UI2
//
//  Created by Tales Valente on 16/08/22.
//

import SwiftUI

@main
struct TSN_SWIFT_UI2App: App {
   
    @State var isNotConnected = true
    
    var body: some Scene {
        WindowGroup {
            PostView()
                .fullScreenCover(isPresented: $isNotConnected) {
                    LoginView()
                }
                .onAppear {
                    if let token = getPassword() {
                        isNotConnected = false
                    }
                }
        }
    }
}

//JUNK
//.onAppear {
//     API.default.checkConection()
//
// }
