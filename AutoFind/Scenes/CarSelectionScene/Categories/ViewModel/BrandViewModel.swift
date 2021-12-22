//
//  BrandViewModel.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

final class BrandViewModel: PaginatableCategoriesViewModelType {
    
    private var totalPages: Int?
    private var currentPage = 0
    private var pageSize = 15

    private var service: CarSelectionServiceProtocol!
    init(service: CarSelectionServiceProtocol) {
        self.service = service
    }
    
    var isFinished: Bool = false
    var loading: DataCompletion<Bool> = { _ in }
    var successResponseHandler: DataCompletion<[CategoriesViewType]> = { _ in }
    var errorHandler: DataCompletion<String> = { _ in }
    
    func callService() {
        getBrands()
    }
    
    private func getBrands() {
        loading(true)
        service.getBrands(page: currentPage, pageSize: pageSize) { [weak self] result in
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
    
    func getNextPageIfValid(index currentIndex: Int, totalItems: Int) {
        if currentIndex == totalItems && !self.isFinished {
            callService()
        }
    }
}
