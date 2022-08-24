//
//  NewPostView.swift
//  Posts
//
//  Created by Emilly Maia on 10/08/22.
//

import SwiftUI
import Foundation
//
//  Header.swift
//  LaraNotes
//
//  Created by Christian Paulo on 12/05/22.
//

import SwiftUI

struct AddPostView: View {
    @State var token: String?
    // Pra chamar o add do report, tu vai precisar ter um @Binding, ou alguma maneira de referenciar o report aqui
    @Binding var isPresented: Bool

    @State var title : String = ""
    @State var value : Double = 0.0
    
    @State private var buy = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Título"){
                        TextField("Adicionar titulo", text: $title)
                    }
                }
                .listStyle(.insetGrouped)
                .padding(.top, -20)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Spacer()
                        Button {
                            isPresented = false
                            Task {
                                await (API.default.createPost(content: self.title, token: self.token ?? "")) //VERIFICAR ESSAS ASPAS
                            }
                        } label: {
                            Text("Salvar")
                                .font(.system(.body, design: .rounded).weight(.medium))
                        }
                        
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button {
                            isPresented = false
                        } label: {
                            Text("Cancelar")
                                .font(.system(.body, design: .rounded).weight(.medium))
                        }
                        
                    }
                }
            }
            .navigationTitle("Novo Post")
            .navigationBarTitleDisplayMode(.inline)
            
            
        }
        .onAppear {
            token = getPassword()
        }
    }
        
}
