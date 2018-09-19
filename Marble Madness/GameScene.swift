//
//  GameScene.swift
//  Marble Madness
//
//  Created by Sadie Flick on 5/3/18.
//  Copyright © 2018 Sadie Flick. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let manager = CMMotionManager()
    var startPosition = CGPoint()
    var startSet: Bool = false

    override func didMove(to view: SKView) {
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.01
        manager.startAccelerometerUpdates(to: OperationQueue.main) {
            (data, error) in
            
            self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.x)!) * 12, dy: CGFloat((data?.acceleration.y)!) * 12)
        }
        
        physicsWorld.contactDelegate = self
        
        // Store Marble's initial position
        if let marble = self.childNode(withName: "marble") {
            if !startSet {
                startPosition = marble.position
                startSet = true
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {

        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "BadWall" || nodeB.name == "BadWall" {
            //createAlert(title: "Marble Madness", message: "GAME OVER")
            if let loseScreen = self.childNode(withName: "LoseScreen") {
                loseScreen.zPosition = 3
                resetGame()
            }
        }
        
        if nodeA.name == "FinalWall" || nodeB.name == "FinalWall" {
            if let winScreen = self.childNode(withName: "WinScreen") {
                winScreen.zPosition = 3
                resetGame()
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func resetGame() {
        // Wait 2 seconds before executing reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            if let winScreen = self.childNode(withName: "WinScreen") { winScreen.zPosition = -3 }
            if let loseScreen = self.childNode(withName: "LoseScreen") { loseScreen.zPosition = -3 }
            if let marble = self.childNode(withName: "marble") { marble.position = self.startPosition }
        }
    }
//    var viewController : UIViewController;
//    func createAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
//        alert.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.cancel, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
//
//        self.view.viewpresent(alert, animated: true, completion: nil)
//    }
}
