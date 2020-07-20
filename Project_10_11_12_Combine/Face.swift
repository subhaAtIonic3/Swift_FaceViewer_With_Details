//
//  Face.swift
//  Project_10_11_12_Combine
//
//  Created by Subhrajyoti Chakraborty on 21/07/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import UIKit

class Face: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
