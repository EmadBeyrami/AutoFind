//
//  URLRequestLoggableProtocol.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

protocol URLRequestLoggableProtocol {
    func logResponse(_ response: HTTPURLResponse?, data: Data?, error: Error?, HTTPMethod: String?)
}
