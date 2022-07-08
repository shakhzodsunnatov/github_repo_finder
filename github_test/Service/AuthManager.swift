//
//  AuthManager.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    struct Constant {
        static let privateKey = "31b528b0b9f89fccae4e6eaa519a7ee4e93433dd"
        static let clientID = "aee3e71447df2b2e0186"
        static let tokenAPIURL = "https://github.com/login/oauth/access_token"
    }
    
    private init() {}
    
    public var signInUrl: URL? {
        let redirectURI = "https://google.com"
        let base = "https://github.com/login/oauth/authorize"
        let string = "\(base)?client_id=\(Constant.clientID)&redirect_uri=\(redirectURI)&scope=user%20repo_deployment%20repo%20public_repo%20project%20read:packages"
        return URL(string: string)
    }
    
    var isSingedIn: Bool {
        return accessToken != nil
    }
    
     var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    public func exchangeCodeForToken(
        code: String,
        comletion: @escaping ((Bool) -> Void)
    ) {
        guard let url = URL(string: Constant.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "client_id",
                         value: Constant.clientID),
            URLQueryItem(name: "client_secret",
                         value: Constant.privateKey),
            URLQueryItem(name: "code",
                         value: code),
            URLQueryItem(name: "redirect_uri",
                         value: "https://google.com")
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [ "Accept" : "application/json"]
        request.httpBody = components.query?.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode <= 200 && response.statusCode < 300
            else {
                comletion(false)
                return
            }

            do {
            
                let result = try JSONDecoder().decode(TokenModel.self, from: data)
                self.cacheToken(result: result)
                comletion(true)
            } catch {
                print(error.localizedDescription)
                comletion(false)
            }
            
        }.resume()
    }
    
    private func cacheToken(result: TokenModel) {
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
    }
}



