//
//  arrowRowClass.swift
//  Glassware
//
//  Created by James Sobieski on 7/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class arrowRowClass: CCSprite {
    
    func moveRight() {
        self.position.x + 2.0
    }
    
    func moveLeft() {
        self.position.x - 2.0
    }
}
