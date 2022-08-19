import Foundation

//DEFINE IF APPLICATION IS RUNNING LOCAL OR CLOUD
//TODO UPGRADE THIS TO AUTOCHECK IF CLOUD OR LOCAL
//MAYBE A FUNCTION THAT RETURNS TRUE OR FALSE ?

//FOR LOCAL SERVER
//let serverPath: String = "http://127.0.0.1:8080/"

//FOR CLOUD SERVER
//let serverPath: String = "http://adaspace.local/"

class API {
    
    static var `default` = API(serverPath: "http://adaspace.local/")
    //static var `default` = API(serverPath: "http://127.0.0.1:8080/")
    
    var serverPath: String
    
    init(serverPath: String) {
        self.serverPath = serverPath
    }
    
    func getAllPosts() async -> [Post] {
        var urlRequest = URLRequest(url: URL(string: serverPath+"posts")!)
        urlRequest.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let allPostsDecoded = try JSONDecoder().decode([Post].self, from: data)
            
            return allPostsDecoded
        } catch {
            print(error)
        }
        return []
    }
    
    func getAllUsers() async -> [GetUser] {
        var urlRequest = URLRequest(url: URL(string: serverPath+"users")!)
        urlRequest.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let allUsersDecoded = try JSONDecoder().decode([GetUser].self, from: data)
            
            return allUsersDecoded
        } catch {
            print(error)
        }
        return []
    }
    
    func createUser(name: String, email: String,password: String) async -> UserSession?{
        var urlRequest = URLRequest(url: URL(string: serverPath+"users")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String:Any] = ["name": name, "email": email, "password": password]
        
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do{
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let userdata = try JSONDecoder().decode(UserSession.self, from: data)
            
            let stringResponse = String(data: data, encoding: .utf8)!
            print(stringResponse)
            return userdata
        }
        catch{
            print(error)
        }
        return nil
    }

    
    func login(email:String, password:String) async -> UserSession? {
        
        let login: String = "\(email):\(password)"
        let logindata = login.data(using: String.Encoding.utf8)!
        let base64 = logindata.base64EncodedString()
        
        var urlRequest = URLRequest(url: URL(string: serverPath+"users/login")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        
        do{
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let session = try JSONDecoder().decode(UserSession.self, from: data)
            
            let stringResponse = String(data: data, encoding: .utf8)!
            print(stringResponse)
            
            //VERIFICAR ESSE SAVE DO CHRISTIAN
            save(token: session.token)
            return session
        }
        catch{
            print(error)
        }
        return nil
    }
    
    func logout(token: String) async -> UserSession?{
        var urlRequest = URLRequest(url: URL(string: serverPath+"users/logout")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        

        do{
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let session = try JSONDecoder().decode(UserSession.self, from: data)
            let stringResponse = String(data: data, encoding: .utf8)!
            print(stringResponse)
            print("Logout Successful")
            delete(service: "Apple.Developer.Academy.TSN-SWIFT-UI2", account: "academy")
            return session
        }
        catch{
            print("\n[DEBUG] ERROR IN FUNCTION LOGOUT. SOMETHING GOES WRONG!\n", error)
        }
        return nil
    }
    
    func createPost(content: String, token: String) async -> Post?{
            var urlRequest = URLRequest(url: URL(string: serverPath+"posts")!)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("text/plain", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = content.data(using: .utf8)!
            
            do{
                let (data, _) = try await URLSession.shared.data(for: urlRequest)
                
                let stringResponse = String(data: data, encoding: .utf8)!
                print(stringResponse)
                
                let userdata = try JSONDecoder().decode(Post.self, from: data)
                
                return userdata
            }
            catch{
                print(error)
            }
            return nil
    }
}
