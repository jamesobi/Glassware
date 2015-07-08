//
//  HydrateMainScene.swift
//  Glassware
//
//  Created by James Sobieski on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class HydrateMainScene: CCNode, CCPhysicsCollisionDelegate {
    
    weak var myPhysicsNode:CCPhysicsNode!
    weak var crystalsNode:CCNode!
    weak var scoreLabel:CCLabelTTF!
    weak var gameOverMessage:CCLabelTTF!
    weak var victoryMessage:CCLabelTTF!
    weak var colorBar:CCNode!
    weak var retryButton:CCButton!
    weak var menuButton:CCButton!
    weak var badge:CCNode!
    
    
    var timeSinceStart = 1.0
    var largerTimeSinceStart = 1
    var modulator = 5.0
    //mod should be 5
    var isGameOver = false
    var crystals:[CCSprite] =  []
    var whites:[CCSprite] = []
    
    
    func didLoadFromCCB() {
        
        myPhysicsNode.collisionDelegate = self
        
        userInteractionEnabled = true
        multipleTouchEnabled = true
        
        myPhysicsNode.debugDraw = false
        
        
    }
    
    override func update(delta: CCTime) {
        
        for var i = 0; i < crystals.count; i += 1 {
            if crystals[i].position.y > 790 {
                crystals[i].removeFromParent()
                crystals.removeAtIndex(i)
                
            }
        }
        for var j = 0; j < whites.count; j += 1 {
            if whites[j].position.y > 790 {
                whites[j].removeFromParent()
                whites.removeAtIndex(j)
                
            }
        }
        
        if timeSinceStart % modulator == 0.0 {
            spawnRandomCrystal()
            timeSinceStart = 1
            
        }
        if largerTimeSinceStart % 3 == 0 {
            colorBar.position.y = colorBar.position.y - 1.0
            if colorBar.position.y <= 1 {
                if scoreLabel.string.toInt()! >= 30 {
                    triggerVictory()
                }else {
                    triggerGameOver()
                }
            }
            largerTimeSinceStart = 1
            
        }
        deleteLowWhites()
        timeSinceStart += 1
        largerTimeSinceStart += 1
    }
    
    func deleteLowWhites() {
        var i = 0
        while i < whites.count {
            if whites[i].position.y < colorBar.position.y {
                
                let whiteCrystalPoof = CCBReader.load("WhiteCrystalPoof") as! CCParticleSystem
                whiteCrystalPoof.autoRemoveOnFinish = true
                whiteCrystalPoof.position = whites[i].position
                whites[i].parent.addChild(whiteCrystalPoof)
                
                
                whites[i].removeFromParent()
                whites.removeAtIndex(i)
                scoreLabel.string = "\(scoreLabel.string.toInt()! + 1)"
                println(scoreLabel.string)
                
                
                
                
                i -= 1
            }
            i += 1
        }
    }
    
    func spawnRandomCrystal() {
        if !isGameOver {
            var randomColumn = arc4random_uniform(3)
            var chanceOfWhite = arc4random_uniform(10)
            
            if chanceOfWhite <= 2 {
                var temporaryWhite = CCBReader.load("WhiteCrystal") as! CCSprite
                temporaryWhite.scaleX = 0.5
                temporaryWhite.scaleY = 0.5
                temporaryWhite.position = ccp(CGFloat(randomColumn * 110 + 50), CGFloat(630))
                crystalsNode.addChild(temporaryWhite)
                whites.append(temporaryWhite)
                
                
            } else {
                var temporaryBlue = CCBReader.load("WaterCrystal") as! CCSprite
                temporaryBlue.scaleY = 0.5
                temporaryBlue.scaleX = 0.5
                temporaryBlue.position = ccp(CGFloat(randomColumn * 110 + 50), CGFloat(630))
                crystalsNode.addChild(temporaryBlue)
                crystals.append(temporaryBlue)
                
            }
        }
    }
    
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var i = 0
        while i < crystals.count {
            if crystals[i].boundingBox().contains(touch.locationInWorld()) {
                
                let blueCrystalPoof = CCBReader.load("BlueCrystalPoof") as! CCParticleSystem
                blueCrystalPoof.autoRemoveOnFinish = true
                blueCrystalPoof.position = crystals[i].position
                crystals[i].parent.addChild(blueCrystalPoof)
                
                
                crystals[i].removeFromParent()
                crystals.removeAtIndex(i)
                
                //println("something was removed at index \(i)")
                i -= 1
                //println(i)
            }
            i += 1
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, waterCrystal blue: CCNode!, flame fire: CCNode!) -> ObjCBool {
        //println("they collided")
        if let newBlue = blue {
            blue.removeFromParent()
        }
        
        scoreLabel.string = "\(scoreLabel.string.toInt()! + 1)"
        return true
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
    
    func triggerVictory() {
        userInteractionEnabled = false
        crystals.removeAll(keepCapacity: true)
        whites.removeAll(keepCapacity: true)
        //crystalsNode.removeAllChildren()
        isGameOver = true
        victoryMessage.visible = true
        retryButton.visible = true
        menuButton.visible = true
        badge.visible = true
        menuButton.position = ccp(160, 244)
    }
    
    func triggerGameOver() {
        userInteractionEnabled = false
        crystals.removeAll(keepCapacity: true)
        whites.removeAll(keepCapacity: true)
        //crystalsNode.removeAllChildren()
        isGameOver = true
        gameOverMessage.visible = true
        retryButton.visible = true
        menuButton.visible = true
        menuButton.position = ccp(160, 244)
        
    }
    
    func loadLevelScene() {
        var levelScene = CCBReader.loadAsScene("MenuSelect")
        CCDirector.sharedDirector().replaceScene(levelScene)
    }
    
    func retry() {
        //println("retryCalled")

        var hydrateScene = CCBReader.loadAsScene("HydrateMainScene")
        CCDirector.sharedDirector().replaceScene(hydrateScene)
        
//        victoryMessage.visible = false
//        isGameOver = false
//        gameOverMessage.visible = false
//        userInteractionEnabled = true
//        retryButton.visible = false
//        colorBar.position.y = 470
//        scoreLabel.string = "0"
//        badge.visible = false
//        crystalsNode.removeAllChildren()
    }
    
//    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
//        for touch in touches {
//            for flame in flames {
//                if flame.boundingBox().contains(touch.locationInWorld()) {
//                    flame.visible = trues
//                }
//            }
//        }
//    }
}
