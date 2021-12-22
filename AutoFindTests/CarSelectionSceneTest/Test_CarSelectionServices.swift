//
//  Test_CarSelectionServices.swift
//  AutoFindTests
//
//  Created by Emad Bayramy on 12/22/21.
//

import XCTest
@testable import AutoFind

final class CarSelectionServicesTest: XCTestCase {
    
    var sut: CarSelectionService?
    var brandsJson: Data?
    var modelsJson: Data?
    
    override func setUp() {
        let bundle = Bundle(for: type(of: self))
        autoreleasepool {
            if let path = bundle.path(forResource: "Brands", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    self.brandsJson = data
                } catch {
                    
                }
            }
            
            if let path = bundle.path(forResource: "Models", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    self.modelsJson = data
                } catch {
                    
                }
            }
        }
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_getBrands() {
        
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = brandsJson
        let mockRequestManager = RequestManagerMock(session: urlSessionMock, validator: MockResponseValidator())
        sut = CarSelectionService(requestManager: mockRequestManager)
        let expectation = XCTestExpectation(description: "Async Movies test")
        var brands: [Car] = []
        
        // When
        sut?.getBrands(page: 0, pageSize: 15, completionHandler: { (result) in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(let data):
                brands = data.result!.brands!
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(brands.count == 15)
    }
    
    func test_getModels() {
        
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = modelsJson
        let mockRequestManager = RequestManagerMock(session: urlSessionMock, validator: MockResponseValidator())
        sut = CarSelectionService(requestManager: mockRequestManager)
        let expectation = XCTestExpectation(description: "Async Movies test")
        var models: [Car] = []
        
        // When
        sut?.getModels(page: 0, pageSize: 15, manifactureID: "057", completionHandler: { (result) in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(let data):
                models = data.result!.brands!
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(models.count == 9)
    }
}
