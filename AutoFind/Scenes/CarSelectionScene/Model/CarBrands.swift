//
//  CarBrands.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

struct CarBrands: Codable {
    var brands: [Car]?
    
    struct CustomCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    // because we are having a custom keyed objects it's better to decode manually
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        self.brands = [Car]()
        for key in container.allKeys {
            let customKey = CustomCodingKeys(stringValue: key.stringValue)!
            let value = try container.decode(String.self, forKey: customKey)
            self.brands?.append(Car(brandId: key.stringValue, name: value))
        }
    }
}

struct Car: Codable {
    var brandId: String?
    var name: String?
}
extension Car: CategoriesViewType {
    var title: String {
        return name ?? "-"
    }
    var CarID: String {
        return brandId ?? "0"
    }
}
