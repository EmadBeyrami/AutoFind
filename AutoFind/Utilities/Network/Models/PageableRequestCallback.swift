//
//  PageableRequestCallback.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation
struct PageableRequestCallback<T: Codable>: Codable {
    let page, pageSize, totalPageCount: Int?
    let result: T?
    
    enum CodingKeys: String, CodingKey {
        case page, pageSize, totalPageCount
        case result = "wkda"
    }
}
