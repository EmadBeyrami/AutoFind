//
//  CarModelViewModel.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

final class CarModelViewModel: PaginatableCategoriesViewModelType {
    
    private var totalPages: Int?
    private var currentPage = 0
    private var pageSize = 15
    
    private var selectedManifacture: String!
    private var service: CarSelectionServiceProtocol!
    init(service: CarSelectionServiceProtocol, brand: CategoriesViewType) {
        self.service = service
        self.selectedManifacture = brand.CarID
    }
    
    var isFinished: Bool = false
    var loading: DataCompletion<Bool> = { _ in }
    var successResponseHandler: DataCompletion<[CategoriesViewType]> = { _ in }
    var errorHandler: DataCompletion<String> = { _ in }
    
    func callService() {
        getModels()
    }
    
    private func getModels() {
        loading(true)
        service.getModels(page: currentPage, pageSize: pageSize, manifactureID: selectedManifacture) { [weak self] result in
            guard let self = self else { return }
            self.loading(false)
            switch result {
            case .success(let data):
                self.currentPage += 1
                if data.page == self.totalPages {
                    self.isFinished = true
                }
                self.totalPages = data.totalPageCount ?? 1
                guard let brands = data.result?.brands else {
                    assertionFailure("result not found")
                    return
                }
                self.successResponseHandler(brands)
            case .failure(let error):
                self.errorHandler(error.localizedDescription)
            }
            
        }
    }
    
    func getNextPageIfValid(index CurrentIndex: Int, totalItems: Int) {
        if CurrentIndex == totalItems && !self.isFinished {
            callService()
        }
    }
    
}
