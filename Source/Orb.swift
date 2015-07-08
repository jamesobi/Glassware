//
//  Orb.swift
//  Glassware
//
//  Created by James Sobieski on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit


class Orb: CCSprite {
    var type = 0
    
    init(aType:Int) {
        super.init()
        type = aType;
        switch type
        {
        case 0:
            self = CCBReader.load("RedOrb") as! Orb
            break;
        default:
            break;
        }
    }
    
}
