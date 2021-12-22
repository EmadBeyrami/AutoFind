//
//  AutoFindTableViewCell.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/21/21.
//

import UIKit

public protocol AutoFindTableViewCell: UITableViewCell {
    
    associatedtype CellViewModel
    
    func configureCellWith(_ item: CellViewModel)
    
}
