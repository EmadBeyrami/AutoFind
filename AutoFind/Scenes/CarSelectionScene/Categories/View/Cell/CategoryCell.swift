//
//  CategoryCell.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .clear
        titleLabel.text = ""
    }
    
    private func initialize() {
        titleLabel.textColor = .white
    }
    
    private func fillCell(_ item: CategoriesViewType) {
        titleLabel.text = item.title
    }
    
    func isOdd(_ isOdd: Bool) {
        self.backgroundColor = isOdd ? .BackGround.paleGrayBlack : .BackGround.paleBlueberryPaleBlack
    }
}
extension CategoryCell: AutoFindTableViewCell {
    
    func configureCellWith(_ item: CategoriesViewType) {
        fillCell(item)
    }
}
