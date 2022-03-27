//
//  PatchProduct.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/20.
//

import Foundation

struct PatchProduct: Uploadable {
    
    let parameter: Data?
    let images: [Data]?
    
    var asDictionary: [String : Any?] {
        [
            "params": self.parameter,
            "images": self.images
        ]
    }
}
