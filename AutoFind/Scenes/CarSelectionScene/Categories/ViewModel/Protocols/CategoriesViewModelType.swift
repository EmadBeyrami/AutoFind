//
//  CategoriesViewModelType.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

typealias PaginatableCategoriesViewModelType = CategoriesViewModelType & paginatableViewModelType

protocol CategoriesViewModelType {
    var loading: DataCompletion<Bool> { get set }
    var successResponseHandler: DataCompletion<[CategoriesViewType]> { get set }
    var errorHandler: DataCompletion<String> { get set }
    func callService()
}

protocol paginatableViewModelType {
    var isFinished: Bool { get set }
    func getNextPageIfValid(index currentIndex: Int, totalItems: Int)
}
extension paginatableViewModelType {
    var isFinished: Bool {
        return false
    }
}
