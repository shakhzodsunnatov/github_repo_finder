//
//  NewApi.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import Foundation

class NewApi {
    
    static let shared = NewApi()
    
    var baseUrl: String {
        return "https://api.github.com"
    }
    
    var tokenId: String! {
        return AuthManager.shared.accessToken
    }
    
    var authHeaders: [String: String]! {
        get {
            return ["Authorization" : "Bearer \(NewApi.shared.tokenId!)"]
        }
    }

        
    typealias CompletionOnRequest <T> = (Swift.Result< T, Error>) -> Void

    static func dataTask<T:Codable>(with request: URLRequest, completion: @escaping CompletionOnRequest<T>){
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard err == nil else {
                completion(.failure(err!))
                return
            }
            // Get the response data
            guard let responseData = data else {
                let err = RestError.invalidData
                completion(.failure(err))
                return
            }
           
            #if DEBUG
            print("URL: \(request.url?.absoluteString)")
            if let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers),
               let jsonPrettyData = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted) {
                print(String(decoding: jsonPrettyData, as: UTF8.self))
            }
            #endif
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let err = RestError.invalidResponse
                completion(.failure(err))
                return
            }
            
            if let dataReq = request.httpBody {
                let req = String(data: dataReq, encoding: .utf8) ?? ""
                print(req)
            }
            let responseStr = String(data: responseData, encoding: .utf8) ?? ""

            if [200, 201, 204].contains(httpResponse.statusCode) {
                do {
                    let dataFromServer = try JSONDecoder().decode(T.self, from: responseData)
                    completion(.success(dataFromServer))
                    return
                } catch let error {
                    print(error)
                    let responseStr = String(data: responseData, encoding: .utf8) ?? ""
                    let err = RestError.jsonParsingFailure(objAsString: responseStr, httpStatus: httpResponse.statusCode, path: request.url?.path)
                    completion(.failure(err))
                }
            } else if httpResponse.statusCode == 400 {
                let err = RestError.badRequestWithResponse(responseData: responseData)
                    completion(.failure(err))
                    return
            } else if httpResponse.statusCode == 401 {
                do {
                    //                    let errorSimpleResponse = try JSONDecoder().decode(NewApi.SimpleResponse.self, from: responseData)
                    //                    let err = RestError.needAuthorizationErrorWithResponse(responseObject: errorSimpleResponse)
                    completion(.failure(RestError.badRequestWithResponse(responseData: responseData)))
                    return
                } catch {
                    let responseStr = String(data: responseData, encoding: .utf8) ?? ""
                    let err = RestError.jsonParsingFailure(objAsString: responseStr, httpStatus: httpResponse.statusCode, path: request.url?.path)
                    completion(.failure(err))
                }
            } else {
                let unknownErrorStr = "UnknownError"
                let err = RestError.custom(message: unknownErrorStr + "\n \(httpResponse.statusCode)")
                completion(.failure(err))
            }
        }
        
        task.resume()

    }
    
    typealias HttpStatus = Int
    static func dataTaskWithoutResponse(with request: URLRequest, completion: @escaping (Swift.Result<HttpStatus, Error>)->Void){
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard err == nil else {
                completion(.failure(err!))
                return
            }
            // Get the response data
            guard let responseData = data else {
                let err = RestError.invalidData
                completion(.failure(err))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let err = RestError.invalidResponse
                completion(.failure(err))
                return
            }

            if [200, 201, 204].contains(httpResponse.statusCode) {
                
                    completion(.success(httpResponse.statusCode))
                    return
                
            } else if httpResponse.statusCode == 400 {
                    
                let err = RestError.badRequestWithResponse(responseData: responseData)
                //let responseStr = String(data: responseData, encoding: .utf8) ?? ""

                    completion(.failure(err))
                    return
            } else if httpResponse.statusCode == 401 {
                do {
                    //                    let errorSimpleResponse = try JSONDecoder().decode(NewApi.SimpleResponse.self, from: responseData)
                    //                    let err = RestError.needAuthorizationErrorWithResponse(responseObject: errorSimpleResponse)
                    completion(.failure(RestError.badRequestWithResponse(responseData: responseData)))
                    return
                } catch {
                    let responseStr = String(data: responseData, encoding: .utf8) ?? ""
                    let err = RestError.jsonParsingFailure(objAsString: responseStr, httpStatus: httpResponse.statusCode, path: request.url?.path)
                    completion(.failure(err))
                }
            } else {
                let unknownErrorStr = "UnknownError"
                let err = RestError.custom(message: unknownErrorStr + "\n \(httpResponse.statusCode)")
                completion(.failure(err))
            }
        }
        
        task.resume()

    }

    static func get<R:Codable>(route: String, headersToAdd:[String:String]?, completion: @escaping CompletionOnRequest<R>){
        
        guard let urlFromString = URL(string: "\(NewApi.shared.baseUrl+route)") else {
            completion(.failure(RestError.badURL))
            return
        }
        
        var urlRequest = URLRequest(url: urlFromString)

        urlRequest.httpMethod = "GET"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let headersDictionary = headersToAdd {
            urlRequest.allHTTPHeaderFields?.merge(headersDictionary, uniquingKeysWith: { _, keyStrFromSecondDic in
                keyStrFromSecondDic
            })
        }
                        
        Self.dataTask(with: urlRequest, completion: completion)
    }

    static func post<R:Codable>(route: String, headersToAdd:[String:String]?, completion: @escaping CompletionOnRequest<R>){
        
        guard let urlFromString = URL(string: "\(NewApi.shared.baseUrl+route)") else {
            completion(.failure(RestError.badURL))
            return
        }
        
        var urlRequest = URLRequest(url: urlFromString)

        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                
        if let headersDictionary = headersToAdd {
            urlRequest.allHTTPHeaderFields?.merge(headersDictionary, uniquingKeysWith: { _, keyStrFromSecondDic in
                keyStrFromSecondDic
            })
        }
        
        Self.dataTask(with: urlRequest, completion: completion)
    }
    
    static func post<M:Codable, R:Codable>(route: String, model: M, headersToAdd:[String:String]?, completion: @escaping CompletionOnRequest<R>){
        
        var url: URL?
        
            guard let urlFromString = URL(string: "\(NewApi.shared.baseUrl+route)") else {
                completion(.failure(RestError.badURL))
                return
            }
            
            url = urlFromString
        
        
        guard let bodyJsonData = try? JSONEncoder().encode(model) else {
            completion(.failure(RestError.jsonEncodingFailure))
            return
        }

        let bodyJsonDataStr = String(data: bodyJsonData, encoding: .utf8) ?? ""
        print(bodyJsonDataStr)
        

        var urlRequest = URLRequest(url: url!)

        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = bodyJsonData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                
        if let headersDictionary = headersToAdd {
            urlRequest.allHTTPHeaderFields?.merge(headersDictionary, uniquingKeysWith: { _, keyStrFromSecondDic in
                keyStrFromSecondDic
            })
        }
        
        Self.dataTask(with: urlRequest, completion: completion)
    }
    
    static func postWithoutResponse<M:Codable>(route: String, model: M, headersToAdd:[String:String]?, completion: @escaping (Swift.Result<HttpStatus, Error>)->Void) {
        
        guard let urlFromString = URL(string: "\(NewApi.shared.baseUrl+route)") else {
            completion(.failure(RestError.badURL))
            return
        }
        
        guard let bodyJsonData = try? JSONEncoder().encode(model) else {
            completion(.failure(RestError.jsonEncodingFailure))
            return
        }

        let bodyJsonDataStr = String(data: bodyJsonData, encoding: .utf8) ?? ""
        print(bodyJsonDataStr)
        

        var urlRequest = URLRequest(url: urlFromString)

        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = bodyJsonData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                
        if let headersDictionary = headersToAdd {
            urlRequest.allHTTPHeaderFields?.merge(headersDictionary, uniquingKeysWith: { _, keyStrFromSecondDic in
                keyStrFromSecondDic
            })
        }
        
        Self.dataTaskWithoutResponse(with: urlRequest, completion: completion)
    }
    
    static func delete<M:Codable, R:Codable>(route: String, model: M, headersToAdd:[String:String]?, completion: @escaping CompletionOnRequest<R>){
        
        guard let urlFromString = URL(string: "\(NewApi.shared.baseUrl+route)") else {
            completion(.failure(RestError.badURL))
            return
        }
        
        guard let bodyJsonData = try? JSONEncoder().encode(model) else {
            completion(.failure(RestError.jsonEncodingFailure))
            return
        }

        let bodyJsonDataStr = String(data: bodyJsonData, encoding: .utf8) ?? ""
        print(bodyJsonDataStr)
        

        var urlRequest = URLRequest(url: urlFromString)

        urlRequest.httpMethod = "DELETE"
        urlRequest.httpBody = bodyJsonData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                
        if let headersDictionary = headersToAdd {
            urlRequest.allHTTPHeaderFields?.merge(headersDictionary, uniquingKeysWith: { _, keyStrFromSecondDic in
                keyStrFromSecondDic
            })
        }
        
        Self.dataTask(with: urlRequest, completion: completion)
    }
}
