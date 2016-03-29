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
    var peg1: SKSpriteNode!
    var peg2: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        cannon = self.childNodeWithName("cannon_full") as! SKSpriteNode
        
        self.physicsWorld.contactDelegate = self
        
        peg1 = self.childNodeWithName("peg1") as! SKSpriteNode
        peg2 = self.childNodeWithName("peg2") as! SKSpriteNode
        
        let moveRight = SKAction.moveByX(800.0, y: 0.0, duration: 3.0)
        let moveLeft = SKAction.moveByX(-800.0, y: 0.0, duration: 3.0)
        
        let seq = SKAction.sequence([moveRight, moveLeft])
        
        peg1.runAction(SKAction.repeatActionForever(seq))
        peg2.runAction(SKAction.repeatActionForever(seq))
            
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
        
        ball.physicsBody?.collisionBitMask = wallMask | ballMask | pegMask | orangePegMask
        
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask | squareMask
        
        
        
        
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        

        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let ball = (contact.bodyA.categoryBitMask == ballMask) ? contact.bodyA : contact.bodyB
        
        let other = (ball == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == pegMask || other.categoryBitMask == orangePegMask {
            self.didHitPeg(other)
        }
        else if other.categoryBitMask == squareMask {
            print("hit square!")
        }
        else if other.categoryBitMask == wallMask {
            print("hit wall!")
        }
        else if other.categoryBitMask == ballMask {
            print("hit ball!")
        }
        
    }
    
    func didHitPeg(peg:SKPhysicsBody) {
        let blue = UIColor(red: 0.16, green: 0.73, blue: 0.78, alpha: 1.0)
        let orange = UIColor(red: 1.0, green: 0.45, blue: 0.0, alpha: 1.0)
        
        let spark: SKEmitterNode = SKEmitterNode(fileNamed: "SparkParticle")!
        spark.position = peg.node!.position
        spark.particleColor = (peg.categoryBitMask == orangePegMask) ? orange : blue
        self.addChild(spark)
        peg.node?.removeFromParent()
    }
}
