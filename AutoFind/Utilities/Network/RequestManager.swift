//
//  RequestManager.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

/*
 This is the network layer that I wrote for my apps, it is super duper light and no need for adding alamofire or such to the app :)
 */

typealias CodableResponse<T: Codable> = (Result<T, RequestError>) -> Void

final class RequestManager: NSObject, URLSessionDelegate {
    
    private let baseAPIPrefix = Bundle.main.info(for: InfoPlistKey.baseAPIURL)!
    private let baseAPIVersion = Bundle.main.info(for: InfoPlistKey.baseAPIVersion)!
    var baseApi: String
    
    var session: URLSession!
    
    var responseValidator: ResponseValidatableProtocol
    
    var reponseLog: URLRequestLoggableProtocol?
    
    var cacheManager: CacheManagable!
    
    typealias Headers = [String: String]
    
    private override init() {
        self.baseApi = baseAPIPrefix + baseAPIVersion
        self.reponseLog = AutoFindResponseLog()
        self.responseValidator = AutoFindResponseValidator()
        self.cacheManager = AutoFindCacheManager.standard
        super.init()
        self.session = URLSession(configuration: cacheManager.cacheConfig(), delegate: self, delegateQueue: OperationQueue.main)
    }
    
    public init(session: URLSession, validator: ResponseValidatableProtocol) {
        self.baseApi = baseAPIPrefix + baseAPIVersion
        self.session = session
        self.responseValidator = validator
    }
    
    static let shared = RequestManager()
    
}

extension RequestManager: RequestManagerProtocol {
    
    var timeOutInterval: Double {
        return 40
    }
    
    var accessToken: String? {
        return UserDefaultData.accessToken
    }
    
    func performRequestWith<T: Codable>(url: String, httpMethod: HTTPMethod, completionHandler: @escaping CodableResponse<T>) {
        
        let headers = headerBuilder()
        
        let urlRequest = urlRequestBuilder(url: url, header: headers, httpMethod: httpMethod)
        
        performURLRequest(urlRequest, completionHandler: completionHandler)
    }
    
    private func headerBuilder() -> Headers {
        let headers = [
            "Content-Type": "application/json"
        ]
        return headers 
    }
    
    private func urlRequestBuilder(url: String, header: Headers, httpMethod: HTTPMethod) -> URLRequest {
        // of course I have to use a better way like URL Componnent but for now its fine!
        let fullUrl = httpMethod == .get ? baseApi + url + "&wa_key=\(accessToken!)" : baseApi + url
        var urlRequest = URLRequest(url: URL(string: fullUrl)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeOutInterval)
        urlRequest.allHTTPHeaderFields = header
        
        urlRequest.httpMethod = httpMethod.rawValue
        return urlRequest
    }
    
    private func performURLRequest<T: Codable>(_ request: URLRequest, completionHandler: @escaping CodableResponse<T>) {
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            self.reponseLog?.logResponse(response as? HTTPURLResponse, data: data, error: error, HTTPMethod: request.httpMethod)
            if error != nil {
                guard let cachedResponse = self.cacheManager.cachedResponse(for: request) else {
                    return completionHandler(.failure(RequestError.connectionError))
                }
                
                if let cachedResp = cachedResponse.data as? T {
                    let validationResult: (Result<T, RequestError>) = self.responseValidator.validation(response: cachedResp as? HTTPURLResponse, data: data)
                    return completionHandler(validationResult)
                } else {
                    return completionHandler(Result.failure(.notFound))
                }
            } else {
                let validationResult: (Result<T, RequestError>) = self.responseValidator.validation(response: response as? HTTPURLResponse, data: data)
                return completionHandler(validationResult)
            }
        }.resume()
    }
    
}
