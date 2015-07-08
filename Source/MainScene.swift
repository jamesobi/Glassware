import Foundation

class MainScene: CCNode {
    func didLoadFromCCB() {
        userInteractionEnabled = true
        println("console works")
    }
    func loadMenu() {
        var menuScene = CCBReader.loadAsScene("MenuSelect")
        println("scene loaded")
        CCDirector.sharedDirector().replaceScene(menuScene)
    }
}
//TO DO: Show badges
