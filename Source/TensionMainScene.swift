//
//  TensionMainScene.swift
//  Glassware
//
//  Created by James Sobieski on 7/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class TensionMainScene: CCScene, CCPhysicsCollisionDelegate {
    weak var daStarfish:CCSprite!
    weak var shieldsNode:CCNode!
    weak var objectsNode:CCNode!
    weak var myPhysicsNode:CCPhysicsNode!
    weak var goldLabel:CCLabelTTF!
    weak var gameOverMessage:CCLabelTTF!
    weak var menuButton:CCButton!
    weak var retryButton:CCButton!
    weak var victoryMessage:CCLabelTTF!
    
    
    var shield = [ccp(0,0), ccp(0,0)]
    var timeSinceStart = 1
    var isGameOver = false
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        myPhysicsNode.collisionDelegate = self
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        shield[0] = ccp(touch.locationInWorld().x, touch.locationInWorld().y)
        shield[1] = ccp(touch.locationInWorld().x, touch.locationInWorld().y)
        
        updateShield()
        println(shield)
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        shield[1] = ccp(touch.locationInWorld().x, touch.locationInWorld().y)
        updateShield()
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        shield = [ccp(0.0,0.0), ccp(0.0,0.0)]
        updateShield()
    }
    override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        shield = [ccp(0.0,0.0), ccp(0.0,0.0)]
        updateShield()
    }
    
    func storeShield(place:String, x:CGFloat, y:CGFloat) {
        if place == "start" {
            shield[0] = ccp(x,y)
        } else {
            shield[1] = ccp(x,y)
        }
        
        updateShield()
        
        println("shield stored")
    }
    
    override func update(delta: CCTime) {
        if !isGameOver {
            if timeSinceStart % 55 == 0 {
                spawnAnObject()
                
                
                timeSinceStart = 1
            }
            if timeSinceStart % 10 == 0 {
                daStarfish.position.x += 1.0
                if daStarfish.position.x >= 277 {
                    if goldLabel.string.toInt()! >= 10 {
                        triggerVictory()
                    }else {
                        triggerGameOver()
                    }
                }
                
            }
            
            timeSinceStart += 1
        }
    }
    
    func spawnAnObject() {
        println("Should be spawning")
        var randomNumberForTreasure = arc4random_uniform(10)
        var randomCol = CGFloat(arc4random_uniform(5) * 60 + 40)
        if randomNumberForTreasure <= 3 {
            var temporaryObject = CCBReader.load("Treasure")
            temporaryObject.scale = 0.4
            temporaryObject.position = ccp(randomCol, 630)
            objectsNode.addChild(temporaryObject)
            println("spawned treasure")
        } else {
            var temporaryObject = CCBReader.load("Anchor")
            temporaryObject.scale = 0.4
            temporaryObject.position = ccp(randomCol, 630)
            objectsNode.addChild(temporaryObject)
            println("spawned anchor")
        }
    }
    
    func updateShield() {
        if !(shield[1].x - shield[0].x == 0.0 && shield[1].y - shield[0].y == 0.0) {
            var slope = Float((shield[1].y - shield[0].y) / (shield[1].x - shield[0].x))
            var rotation = Float(90.0)
            if shield[1].x - shield[0].x > 0 {
                rotation = Float(90 - (360 * Float(atan(slope))) / Float(2.0 * M_PI))
            } else {
                rotation = Float(90 - (360 * Float(atan(slope))) / Float(2.0 * M_PI)) + 180
            }
            
            
            var length = sqrt((pow((shield[1].y - shield[0].y), 2) + pow((shield[1].x - shield[0].x), 2)))
            var scale = Float(length / 600.0)
            
            var temporaryShield = CCBReader.load("Shield") as! CCSprite
            temporaryShield.rotation = rotation
            temporaryShield.position = shield[0]
            temporaryShield.scaleY = scale
            temporaryShield.scaleX = 0.25
            
            
            shieldsNode.removeAllChildren()
            shieldsNode.addChild(temporaryShield)
            
            //println(atan(90.0))
            println("-----")
            println(slope)
            println(rotation)
    //        println(Float(90.0 - (Float((2.0 * M_PI)) * Float(atan(slope)))))
    //        println((Float((2.0 * M_PI)) * Float(atan(slope))))
            println("-----")
        } else {
            shieldsNode.removeAllChildren()
        }
        
        //println("\(temporaryShield.rotation) is the new rotation")
        
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, anchor anAnchor: CCNode!, starfish fish: CCNode!) -> ObjCBool {
        
        anAnchor.removeFromParent()
        goldLabel.string = "0"
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, treasure aChest: CCNode!, starfish fish: CCNode!) -> ObjCBool {
        
        aChest.removeFromParent()
        goldLabel.string = "\(goldLabel.string.toInt()! + 1)"
        return true
    }
    func triggerGameOver() {
        userInteractionEnabled = false
        isGameOver = true
        objectsNode.removeAllChildren()
        gameOverMessage.visible = true
        retryButton.visible = true
        
        menuButton.position = ccp(160, 256)
    }
    
    func triggerVictory() {
        userInteractionEnabled = false
        isGameOver = true
        objectsNode.removeAllChildren()
        victoryMessage.visible = true
        retryButton.visible = true
        menuButton.position = ccp(160, 25)
    }
    
    func retry() {
        var tensionScene = CCBReader.loadAsScene("TensionMainScene")
        CCDirector.sharedDirector().replaceScene(tensionScene)
    }
    
    
    func loadMenu() {
        var menuScene = CCBReader.loadAsScene("MenuSelect")
        CCDirector.sharedDirector().replaceScene(menuScene)
    }
    
}
