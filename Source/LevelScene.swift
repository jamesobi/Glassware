//
//  LevelScene.swift
//  Glassware
//
//  Created by James Sobieski on 7/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class LevelScene: CCNode {
    weak var myPhysicsNode:CCPhysicsNode!
    
    
    
    func didLoadFromCCB() {
        println("Level Scene Loaded")
        userInteractionEnabled = true
        //myPhysicsNode.debugDraw = true
    }

    func loadBuret() {
        println("buret being loaded")
        var buretScene = CCBReader.loadAsScene("BuretMainScene")
        CCDirector.sharedDirector().replaceScene(buretScene)
    }
    
    func loadHydrate() {
        println("hydrate being loaded")
        var hydrateScene = CCBReader.loadAsScene("HydrateMainScene")
        CCDirector.sharedDirector().replaceScene(hydrateScene)
    }
    
    func loadTension() {
        println("tension being loaded")
        var tensionScene = CCBReader.loadAsScene("TensionMainScene")
        CCDirector.sharedDirector().replaceScene(tensionScene)
    }
    
    func loadChromatography() {
        println("Chromatography being loaded")
        var chromatographyScene = CCBReader.loadAsScene("ChromatographyMainScene")
        CCDirector.sharedDirector().replaceScene(chromatographyScene)
    }
}
