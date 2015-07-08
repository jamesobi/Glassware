//
//  buretMainScene.swift
//  Glassware
//
//  Created by James Sobieski on 7/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class BuretMainScene: CCNode, CCPhysicsCollisionDelegate {
    
    weak var myPhysicsNode:CCPhysicsNode!
    weak var victoryMessage:CCLabelTTF!
    weak var gameOverMessage:CCLabelTTF!
    weak var redBallsLabel:CCLabelTTF!
    weak var ballsNode:CCNode!
    weak var retryButton:CCButton!
    weak var badge:CCNode!
    weak var subtractBlueButton:CCButton!
    weak var menuButton:CCButton!
    
    
    var givenRedBalls:Int = 0
    var pinkBalls:[CCSprite] = []
    var timeSinceStart = 1
    var numberOfBlueBalls = 0
    var copyOfBlueBalls = 0
    var waitingForLanding = false
    var gameOverDelay = 1
    var numberOfRedBalls = 0 {
        didSet {
            if givenRedBalls - numberOfRedBalls == 0 {
                userInteractionEnabled = false
                waitingForLanding = true
                gameOverDelay = 2
            }
            redBallsLabel.string = "\(givenRedBalls - numberOfRedBalls)"
            
        }
    }
    //var isVictory:Bool = false
    
    
    func didLoadFromCCB() {
        
        loadLevelOne()
        redBallsLabel.string = "\(givenRedBalls)"
        
        self.userInteractionEnabled = true
        myPhysicsNode.collisionDelegate = self
        myPhysicsNode.debugDraw = true
        
        
        
        
    }
    
    
    func loadLevelOne() {
        numberOfBlueBalls = 0
        copyOfBlueBalls = 0
        givenRedBalls = 60
        for var yVal = 120; yVal <= 280; yVal += 40 {
            for var xValue = 40; xValue <= 280; xValue += 30 {
                var temporaryBlueBall = CCBReader.load("BlueBall")
                temporaryBlueBall.scaleX = 0.15
                temporaryBlueBall.scaleY = 0.15
                if yVal % 80 == 0 {
                    temporaryBlueBall.position = ccp(CGFloat(xValue), CGFloat(yVal))
                    
                } else {
                    temporaryBlueBall.position = ccp(CGFloat(xValue + 20), CGFloat(yVal))
                }
                numberOfBlueBalls += 1
                copyOfBlueBalls += 1
                ballsNode.addChild(temporaryBlueBall)
            }
        }
    }
    
    override func update(delta: CCTime) {
        if gameOverDelay > 1 {
            gameOverDelay += 1
        }
        if gameOverDelay % 125 == 0 {
            triggerGameOver()
        }
        
        //println("\(numberOfBlueBalls)")
        if numberOfBlueBalls <= 0 {
            triggerVictory()
        }
        //println("\(timeSinceStart)")
        if timeSinceStart % 50 == 0 {
            //println("pinks cleared
            //            if !isVictory {
            //                //clearPinks()
            //            }
            //println("pinks were cleared")
            //timeSinceStart = 1
        }
        timeSinceStart += 1
    }
    
    func clearPinks() {
        
        /*for aPinkBall:CCSprite in pinkBalls {
        pinkBalls.remove(aPinkBall)
        */
        var i = 0
        while i < pinkBalls.count {
            pinkBalls[i].removeFromParent()
            pinkBalls.removeAtIndex(i)
        }
    }
    
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if touch.locationInWorld().y > 333 && touch.locationInWorld().y < 493 {
            
            var temporaryBall = CCSprite()
            
            temporaryBall = CCBReader.load("RedBall") as! CCSprite
            temporaryBall.scaleX = Float(0.20)
            temporaryBall.scaleY = Float(0.20)
            numberOfRedBalls += 1
            
            
            temporaryBall.position = touch.locationInWorld()
            
            
            
            
            ballsNode.addChild(temporaryBall)
            println("clicked at: \(touch.locationInWorld())")
        }
        
    }
    
    func scaleCircle(blueCircle:CCNode, scaleValue:Float) {
        println("Scale Box: \(scaleValue)")
        //blueCircle.scale += scaleValue
        
        for shape in blueCircle.physicsBody.chipmunkObjects {
            
            println("Physics Object: \(shape)")
            if shape is ChipmunkCircleShape {
                var newShape = shape as! ChipmunkCircleShape
                //cpCircleShapeSetOffset(shape, box.))
                //cpCircleShapeSetRadius(shape, box.boundingBox().origin)
                
                cpCircleShapeSetRadius(newShape.shape, cpFloat(blueCircle.boundingBox().size.width * CGFloat(0.5)))
                //cpCircleShapeSetOffset(newShape.shape, ccp(blueCircle.anchorPointInPoints.x * CGFloat(1.5), blueCircle.anchorPointInPoints.y * CGFloat(1.5)))
                
                //cpCircleShapeSetOffset(newShape.shape, ccp(0.0,0.0))
                
            }
        }
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, redBall aRedBall: CCNode!, blueBall aBlueBall: CCNode!) -> ObjCBool {

        
        
        if let realRedBall = aRedBall {
            aRedBall.removeFromParent()
            if let realBlueBall = aBlueBall {
                
                let neutral = CCBReader.load("Neutralize") as! CCParticleSystem
                neutral.autoRemoveOnFinish = true
                neutral.position = realBlueBall.position
                realBlueBall.parent.addChild(neutral)
                
                var temporaryPinkBall = CCBReader.load("PinkBall") as! CCSprite
                temporaryPinkBall.position = ccp((realRedBall.position.x + realBlueBall.position.x) / 2.0, (realRedBall.position.y + realBlueBall.position.y) / 2.0)
                temporaryPinkBall.scaleX = 0.2
                temporaryPinkBall.scaleY = 0.2
                ballsNode.addChild(temporaryPinkBall)
                pinkBalls.append(temporaryPinkBall)
                aBlueBall.removeFromParent()
                numberOfBlueBalls -= 1
                aRedBall.removeFromParent()
                
//                if waitingForLanding && (numberOfBlueBalls > 0) {
//                    triggerGameOver()
//                }
                
                
            }
        }
        
        return true
    }
    
    func retry() {
        ballsNode.removeAllChildren()
        
        numberOfRedBalls = 0
        numberOfBlueBalls = 1
        loadLevelOne()
        pinkBalls.removeAll(keepCapacity: false)
        userInteractionEnabled = true
        victoryMessage.visible = false
        gameOverMessage.visible = false
        
        menuButton.position = ccp(280, 527)
        
        retryButton.visible = false
        badge.visible = false
//        badge.position = ccp(0.0, 0.0)
//        badge.scaleX = 1.0
//        badge.scaleY = 1.0
        
        subtractBlueButton.visible = false
        waitingForLanding = false
        gameOverDelay = 1
        
    }
    
    func triggerVictory() {
        userInteractionEnabled = false
        victoryMessage.visible = true
        retryButton.visible = true
        retryButton.position = ccp(152, 139)
        menuButton.position = ccp(152,179)
        
        badge.visible = true
//        badge.position = ccp(82, 72)
//        badge.scaleX = 2.0
//        badge.scaleY = 2.0
        
        subtractBlueButton.visible = false
        gameOverDelay = 1
        
    }
    
    func triggerGameOver() {
        println("gameOverTriggered")
        userInteractionEnabled = false
        gameOverMessage.visible = true
        retryButton.visible = true
        retryButton.position = ccp(152, 139)
        menuButton.position = ccp(152,179)
    }
    
    func subtractABlue() {
        numberOfBlueBalls -= 5
    }
    
    
    
    func loadLevelScene() {
        var levelScene = CCBReader.loadAsScene("MenuSelect")
        CCDirector.sharedDirector().replaceScene(levelScene)
    }
    
}


//bn