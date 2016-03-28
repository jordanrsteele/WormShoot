//
//  GameScene.swift
//  WormShoot
//
//  Created by Jordan Steele on 2016-03-26.
//  Copyright (c) 2016 Jordan Steele. All rights reserved.
//

import SpriteKit


let wallMask:UInt32 = 0x1 << 0 // 1
let ballMask:UInt32 = 0x1 << 1 // 2
let pegMask:UInt32 = 0x1 << 2 // 4
let squareMask:UInt32 = 0x1 << 3 // 8
let orangePegMask:UInt32 = 0x1 << 4 // 16

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cannon: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        cannon = self.childNodeWithName("cannon_full") as! SKSpriteNode
        
        self.physicsWorld.contactDelegate = self
            
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let ball:SKSpriteNode = SKScene(fileNamed: "Ball")?.childNodeWithName("ball") as! SKSpriteNode
        ball.removeFromParent()
        ball.zPosition = 0
        ball.position = cannon.position
        self.addChild(ball)
        
        
        let vx: CGFloat = CGFloat(0.0)
        let vy: CGFloat = CGFloat(100.0)
        ball.physicsBody?.applyImpulse(CGVectorMake(vx, vy))
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("contact!")
    }
}
