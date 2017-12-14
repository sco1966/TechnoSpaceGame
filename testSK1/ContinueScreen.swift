//
//  gameScene2.swift
//  ShipGSpike
//
//  Created by Scott Lawrence Simon on 6/12/17.
//  Copyright © 2017 Scott Lawrence Simon. All rights reserved.
//

import Foundation
import SpriteKit


class ContinueScreen: GameScene2 {


    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        t = 0.0
        timeBegin = 0
        counter = 0
        lastTime = 0
       
    

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        nextStage(currentTime - lastTime)
        lastTime = currentTime
        
        // print(currentTime)
        
    }
    
    
    override func nextStage(_ frameRate: TimeInterval){
        // print("ya")
        t = frameRate
        if (t > 1000){
            t = 0
            
            
        }
        timeBegin += t
        
        // print(timeBegin)
        
        if (timeBegin < 5.0) {
            return
        }
        
        
        
        
        let scene2 = SKScene(fileNamed: "GameScene2")
        scene2?.scaleMode = .aspectFill
        
        self.view?.presentScene(scene2!, transition:  SKTransition.fade(withDuration: 1))
        
        
        
        
    }
}
