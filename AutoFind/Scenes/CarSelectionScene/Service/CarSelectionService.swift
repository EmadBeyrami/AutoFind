//
//  CarSelectionService.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

/*

 This is Car Selection Service, responsible for making api calls of getting Car models and brands.
 
 */

typealias CarBrandsCompletionHandler = DataCompletion<Result<PageableRequestCallback<CarBrands>, RequestError>>
typealias CarModelsCompletionHandler = DataCompletion<Result<PageableRequestCallback<CarBrands>, RequestError>>

protocol CarSelectionServiceProtocol {
    func getBrands(page: Int, pageSize: Int, completionHandler: @escaping CarBrandsCompletionHandler)
    func getModels(page: Int, pageSize: Int, manifactureID: String, completionHandler: @escaping CarModelsCompletionHandler)
}

/*
 CarSelectionEndPoints is URLPath of car Api calls
 */

private enum CarSelectionEndPoints {
    
    case brands(Int, Int)
    case models(Int, Int, String)
    
    var path: String {
        switch self {
        case .brands(let page, let pageSize):
            return "car-types/manufacturer?page=\(page)&pageSize=\(pageSize)"
        case .models(let page, let pageSize, let manifactureID):
            return "car-types/main-types?manufacturer=\(manifactureID)&page=\(page)&pageSize=\(pageSize)"
        }
    }
}

class CarSelectionService: CarSelectionServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    public static let shared: CarSelectionService = CarSelectionService(requestManager: RequestManager.shared)
    
    // We can also inject requestManager for testing purposes.
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getBrands(page: Int, pageSize: Int, completionHandler: @escaping CarBrandsCompletionHandler) {
        self.requestManager.performRequestWith(url: CarSelectionEndPoints.brands(page, pageSize).path, httpMethod: .get) { (result: Result<PageableRequestCallback<CarBrands>, RequestError>) in
            // Taking Data to main thread so we can update UI.
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
    
    func getModels(page: Int, pageSize: Int, manifactureID: String, completionHandler: @escaping CarModelsCompletionHandler) {
        self.requestManager.performRequestWith(url: CarSelectionEndPoints.models(page, pageSize, manifactureID).path, httpMethod: .get) { (result: Result<PageableRequestCallback<CarBrands>, RequestError>) in
            // Taking Data to main thread so we can update UI.
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
}
