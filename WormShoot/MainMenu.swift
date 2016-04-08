//
//  MainMenu.swift
//  WormShoot
//
//  Created by Jordan Steele on 2016-04-02.
//  Copyright © 2016 Jordan Steele. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .AspectFill
        self.view?.presentScene(game)
        
    }

}
