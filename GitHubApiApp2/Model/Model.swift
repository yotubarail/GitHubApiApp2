//
//  Model.swift
//  GitHubApiApp2
//
//  Created by 滝浪翔太 on 2020/10/06.
//

import Foundation

struct SearchResult: Codable {
    
    var items: [UserData]
    
    struct UserData: Codable, Identifiable, Equatable {
        
        var id: Int
        var login: String!
        var avatarUrl: String!
        var type: String!
        var url: String!
        
        
        enum CodingKeys: String, CodingKey {
            
            case id = "id"
            case login = "login"
            case avatarUrl = "avatar_url"
            case type = "type"
            case url = "html_url"
        }
    }
}

class UserModel {
    
    //MARK: - Vars
    var userData = [SearchResult.UserData]()
    
    //MARK: - Fetch GitHubUser Data
    func fetchUserData(text: String, completion: @escaping ([SearchResult.UserData]) -> Void) {
        
        let urlString = "https://api.github.com/search/users?q=\(text.trimmingCharacters(in: .whitespaces))"
        let encode = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encode) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                do {
                    let searchedUserData = try JSONDecoder().decode(SearchResult.self, from: data).items
                    DispatchQueue.main.async {
                        self.userData = searchedUserData
                        dump(self.userData)
                        completion(self.userData)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
}
