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
let snakeMask:UInt = 0x01 << 5 // 32

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cannon: SKSpriteNode!
    var sprite: SKSpriteNode!
    var peg1: SKSpriteNode!
    
    //global array of shapes
    var circleArray:[SKShapeNode] = [SKShapeNode]()
    var spriteArray:[SKSpriteNode] = [SKSpriteNode]()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        cannon = self.childNodeWithName("cannon_full") as! SKSpriteNode
        
        //code for making array array of green circles falling 
        //uses theCircle() function
        
        
        
        
        
        for var i=0; i < 10; i++ {
            let snakeNode:SKSpriteNode = SKScene(fileNamed: "SnakeNode")?.childNodeWithName("snakeNode") as! SKSpriteNode
            
            snakeNode.removeFromParent()
            snakeNode.zPosition = 0
            
            
            spriteArray.append(snakeNode)
        }

        
        theSprite()
        
        
        
        
        /* code to make nodes move back and forth
        peg1 = self.childNodeWithName("peg1") as! SKSpriteNode
        peg2 = self.childNodeWithName("peg2") as! SKSpriteNode
        let moveRight = SKAction.moveByX(800.0, y: 0.0, duration: 3.0)
        let moveLeft = SKAction.moveByX(-800.0, y: 0.0, duration: 3.0)
        let seq = SKAction.sequence([moveRight, moveLeft])
        peg1.runAction(SKAction.repeatActionForever(seq))
        peg2.runAction(SKAction.repeatActionForever(seq))
        */
    }
    
    func theSprite(){
        
        var numSprite = 0
        var initialy = CGFloat(1920)
        var initialx = CGFloat(1000)
        
        while numSprite < spriteArray.count {
            let spriteNode = spriteArray[numSprite]
            
            
            spriteNode.zPosition = 0
            
            /*
            spriteNode.physicsBody?.affectedByGravity = false
            spriteNode.physicsBody?.allowsRotation = false
            spriteNode.physicsBody?.pinned = false
            spriteNode.physicsBody?.affectedByGravity = false
            */
            
            let initialposition = CGPoint(x: initialx, y: initialy)
            spriteNode.position = initialposition
            
            let ourVector = CGVectorMake(-2000, 0.0)
            let action1 = SKAction.moveBy(ourVector, duration: 5)
            let action2 = SKAction.removeFromParent()
            spriteNode.runAction(SKAction.sequence([action1, action2]))
            
            self.addChild(spriteNode)
            initialx = initialx + 100
            //initialy = initialy - 100
            
            numSprite++
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let ball:SKSpriteNode = SKScene(fileNamed: "Ball")?.childNodeWithName("ball") as! SKSpriteNode
        
        ball.removeFromParent()
        ball.zPosition = 0
        ball.position = cannon.position
        self.addChild(ball)
        
        let vx: CGFloat = CGFloat(0.0)
        let vy: CGFloat = CGFloat(150.0)
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
