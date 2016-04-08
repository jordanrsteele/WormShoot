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
    //var sprite: SKSpriteNode!
    var peg1: SKSpriteNode!
    
    //global array of shapes
    var initialy = CGFloat(1890)
    var velocity = CGFloat(-2000)
    var snakeLength = 20
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
        cannon = self.childNodeWithName("cannon_full") as! SKSpriteNode
        
        let wait = SKAction .waitForDuration(10, withRange: 0.5)
        let spawn = SKAction.runBlock({
            self.spawnSnake()
        })
        let spawning = SKAction.sequence([spawn, wait])
        self.runAction(SKAction.repeatActionForever(spawning), withKey:"spawning")
        
        
    }
    
    func spawnSnake(){
        
        var spriteArray:[SKSpriteNode] = [SKSpriteNode]()
        var numSprite = 0
        var initialx = CGFloat(1000)
        
        
        for numSprite = 0; numSprite < snakeLength; numSprite++ {
            let snakeNode:SKSpriteNode = SKScene(fileNamed: "SnakeNode")?.childNodeWithName("snakeNode") as! SKSpriteNode
            snakeNode.removeFromParent()
            spriteArray.append(snakeNode)
        
            let spriteNode = spriteArray[numSprite]
            spriteNode.zPosition = 0
            let initialposition = CGPoint(x: initialx, y: initialy)
            
            let ourVector = CGVectorMake(velocity, 0.0)
            let action1 = SKAction.moveBy(ourVector, duration: 10)
            let action2 = SKAction.removeFromParent()
            spriteNode.position = initialposition
            spriteNode.runAction(SKAction.sequence([action1, action2]))
            
            self.addChild(spriteNode)
            initialx = initialx + 100
            print(numSprite)
            
        }
        initialy = initialy - 100
        velocity = velocity - 600
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
    
    override func didSimulatePhysics() {
        //runs after all physics actions are complete 
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(initialy < 500.0){
            self.removeActionForKey("spawning")
            print("game over!")
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let ball = (contact.bodyA.categoryBitMask == ballMask) ? contact.bodyA : contact.bodyB
        
        let other = (ball == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == pegMask || other.categoryBitMask == orangePegMask {
            self.didHitPeg(other)
            ball.node?.removeFromParent()
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
        snakeLength--
    }
}
