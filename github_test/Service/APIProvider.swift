//
//  APIProvider.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import Foundation

class APIProvider {
    
    static let shared = APIProvider()
    
    private init() {}
    
    func getAllRepo(lastID: Int = 0, completion: @escaping NewApi.CompletionOnRequest<Repositorie>) {
        
        NewApi.get(route: "/repositories?since=\(lastID)", headersToAdd: NewApi.shared.authHeaders, completion: completion)
    }
    
    func searchRepo(by str: String, pageIndex index: Int = 1, completion: @escaping NewApi.CompletionOnRequest<RepoItems>) {
        let customCompletion: NewApi.CompletionOnRequest<SearchRepoModel> = { result in
            switch result {
            case .success(let model):
                completion(.success(model.items ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        var url: String!
        
        if str.contains("+") {
            let textArr = str.components(separatedBy: "+")
            let searchText = textArr.first ?? ""
            let langText = textArr.last ?? ""
            url = "/search/repositories?q=\(searchText)+language:\(langText)&sort=updated&order=desc&page=\(index)&per_page=50"
        } else {
            url = "/search/repositories?q=\(str)&sort=updated&order=desc&page=\(index)&per_page=50"
        }
        
        NewApi.get(route: url, headersToAdd: NewApi.shared.authHeaders, completion: customCompletion)
    }
    
    func getLanguage(byUrlStr urlstr: String, completion: @escaping NewApi.CompletionOnRequest<[[String:Int]]>) {
        guard let url = URL(string: urlstr) else {
            completion(.failure(RestError.custom(message: "ERROR URL: \(urlstr)")))
            return
        }
        
        let request = URLRequest(url: url)
        NewApi.dataTask(with: request, completion: completion)
    }
    
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
