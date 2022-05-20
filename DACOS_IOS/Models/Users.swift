//
//  Users.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 21.05.2022.
//

import Foundation

class Users {
    
    @objc
    static func updateUsers() {
        var request = URLRequest(url: URL(string: "http://\(MainUser.getSuperUser()!.server!.ip!)/users")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let decoder = JSONDecoder()
            do {
                let exists = getUsers()
                let logins = exists.map { (user) -> String in
                    return user.login!
                }
                let users = try decoder.decode(ApiUsers.self, from: data as Data)
                for us in users.users where !logins.contains(us.username){
                    let newUser = User(context: MainUser.context)
                    newUser.login = us.username
                    newUser.server = Servers.getServers().first(where: {$0.ip == us.register_server})
                    newUser.publicKey = us.public_key
                }
                DispatchQueue.main.async {
                    do {
                        try MainUser.context.save()
                    } catch{}
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    public static func getUsers() -> [User]{
        let users = try? MainUser.context.fetch(User.fetchRequest())
        if (users != nil && users?.count != 0) {
            return users!
        } else {
            return []
        }
    }
}
