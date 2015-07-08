//
//  ChromatographyMainScene.swift
//  Glassware
//
//  Created by James Sobieski on 7/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

enum Direction {
    case Stopped, Left, Right
}

class ChromatographyMainScene: CCScene {
    weak var myPhysicsNode:CCPhysicsNode!
    weak var firstArrowRow:arrowRowClass!
    weak var secondArrowRow:arrowRowClass!
    weak var dyeNode:CCNode!
    
    var currentDirection:Direction = .Stopped
    var moveCounter = 0
    var distanceArray = [ccp(0,0), ccp(0,0)]
    var setable = false
    var initialPosition = ccp(0,0)
    var timeSinceStart = 1
    var orbs:[CCSprite] = []
    var colors:[String] = ["RedOrb","OrangeOrb","YellowOrb","GreenOrb","BlueOrb"]
    
    //red, orange, yellow, green, blue
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        //setupGestures()
        myPhysicsNode.debugDraw = true
    }
    
    func spawnRandomDye() {
        var randomColor = Int(arc4random_uniform(5))
        
        var randomCol = arc4random_uniform(4)
        var xPosition = randomCol * 80 + 40
        var temporaryDye = CCBReader.load(colors[randomColor]) as! CCSprite
        temporaryDye.position = ccp(CGFloat(xPosition), 40.0)
        temporaryDye.scale = 0.15
        println("something was added at \(temporaryDye.position)")
        dyeNode.addChild(temporaryDye)
        orbs.append(temporaryDye)
        //var impulse:cpVect = cpv(0.0, -1.0)
        orbs[orbs.count - 1].physicsBody.applyImpulse(CGPoint(x: 0,y: 100))
        //applyImpulse(CGPoint(x: 0,y: 300))
    }
    
    
    override func update(delta: CCTime) {
        if timeSinceStart % 50 == 0 {
            spawnRandomDye()
            timeSinceStart = 1
        }
        timeSinceStart += 1
    }
    
    
    func loadInArrowAtLocation(place: CGPoint) {
        println("load arrow function")
    }
    
    
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        distanceArray[0] = ccp(touch.locationInWorld().x, touch.locationInWorld().y)
        distanceArray[1] = ccp(touch.locationInWorld().x, touch.locationInWorld().y)
        initialPosition = firstArrowRow.position
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        distanceArray[1] = ccp(touch.locationInWorld().x, touch.locationInWorld().y)
        var distance = distanceArray[1].x - distanceArray[0].x
        firstArrowRow.position.x = initialPosition.x + distance
        
        println("-----")
        println(firstArrowRow.position.x)
        
        if firstArrowRow.position.x >= 400 {
            firstArrowRow.position.x = -400
        } else if firstArrowRow.position.x <= -400 {
            firstArrowRow.position.x = 400
        }
        
        
        if firstArrowRow.position.x > 0 {
            secondArrowRow.position.x = firstArrowRow.position.x - 400.0
        } else {
            secondArrowRow.position.x = firstArrowRow.position.x + 400.0
        }
        
        //println(distanceArray)
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        distanceArray = [ccp(0,0), ccp(0,0)]
        setable = true
        println("setable = true")
    }
    
}
