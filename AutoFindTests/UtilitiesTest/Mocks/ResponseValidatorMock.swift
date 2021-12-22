//
//  ResponseValidatorMock.swift
//  AutoFindTests
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation
@testable import AutoFind

struct MockResponseValidator: ResponseValidatableProtocol {
    
    func validation<T: Codable>(response: HTTPURLResponse? = nil, data: Data?) -> (Result<T, RequestError>) {
        guard let data = data else {
            return .failure(RequestError.invalidRequest)
        }
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return .success(model)
        } catch {
            print("JSON Parse Error")
            print(error)
            return .failure(.jsonParseError)
        }
    }
}
