
import SwiftUI
import Foundation

struct PostViewTemp: View {
    @State var posts: [Post] = []
    var body: some View {
        NavigationView {
            List {
                ForEach(posts) { post in
                    VStack {
                        
         
                            Text(post.content)
                            .bold()
                        
                    }
                    .padding(3)
                    
                }
            }
            .navigationTitle("Listagens Posts")
            .task {
                posts = await API.default.getAllPosts()
            }
        }
    }
    
}
struct PostViewTemp_Previews: PreviewProvider {
    static var previews: some View {
        PostViewTemp()
    }
}
