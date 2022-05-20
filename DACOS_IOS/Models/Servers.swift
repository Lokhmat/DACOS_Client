//
//  Servers.swift
//  DACOS_IOS
//
//  Created by Sergey Lokhmatikov on 10.05.2022.
//

import Foundation
import CoreData

class Servers {
    
    static func updateServers(errorCallback: @escaping(() -> ())) {
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "http://localhost:8000/servers")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                errorCallback()
                semaphore.signal()
                return
            }
            let decoder = JSONDecoder()
            do {
                let exists = getServers()
                let ips = exists.map { (server) -> String in
                    return server.ip!
                }
                let servers = try decoder.decode(ApiServers.self, from: data as Data)
                for sv in servers.servers where !ips.contains(sv.url){
                    let newSv = Server(context: MainUser.context)
                    newSv.ip = sv.url
                    newSv.publicKey = sv.public_key
                }
                DispatchQueue.main.async {
                    do {
                        try MainUser.context.save()
                    } catch{}
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    static func registerOnServer(login: String, pk: String, server: String, errorCallback: @escaping((_ msg: String) -> ())){
        let semaphore = DispatchSemaphore (value: 0)
        
        let parameters = "{\n    \"username\": \"\(login)\",\n    \"server\":  \"\(server)\",\n    \"public_key\": \"\(pk)\"\n\n}"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "http://localhost:8000/users/register")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                DispatchQueue.main.async {
                    errorCallback("Error when registering")
                }
                semaphore.signal()
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode != 200{
                    DispatchQueue.main.async {
                        errorCallback("Error when registering")
                    }
                    return
                }
            }
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    public static func getServers() -> [Server]{
        let servers = try? MainUser.context.fetch(Server.fetchRequest())
        if (servers != nil && servers?.count != 0) {
            return servers!
        } else {
            return []
        }
    }
}
