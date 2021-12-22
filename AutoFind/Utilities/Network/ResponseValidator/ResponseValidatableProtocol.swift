//
//  ResponseValidatableProtocol.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

protocol ResponseValidatableProtocol {
    func validation<T: Codable>(response: HTTPURLResponse?, data: Data?) -> Result<T, RequestError>
}
