//
//  GameScene.swift
//  testSK1
//
//  Created by Scott Lawrence Simon on 17/11/17.
//  Copyright © 2017 Scott Lawrence Simon. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class stage3a: SKScene, SKPhysicsContactDelegate  {
    
    
    
    var z: Float = 0.0
    
    var zUse:  Float = 0.0
    var test = true
    
    var test2 = false
    
    
    var lastTime: TimeInterval = 0.0
    var fireRate:TimeInterval = 5.0
    var fireRate2:TimeInterval = 8.0
    var timeSinceFire:TimeInterval = 0.0
    
    
    //    var freq: Float!
    //    var freq2: Float!
    
    let cat1: UInt32 = 0b1
    let playerCategory:UInt32 = 0b1 << 1
    let noCategory:UInt32 = 0
    
    // var engine: AVAudioEngine!
    
    var player:SKSpriteNode?
    
    var counter: Int = 0
    
    //static var aud = AudioClass1()
    
    
    override func didMove(to view: SKView) {
        
        // stage3a.aud.Audio1()
        
        self.physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "player") as? SKSpriteNode
        player?.zPosition = 1
        
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = noCategory
        player?.physicsBody?.contactTestBitMask = cat1
        
        
        let shaderz = SKShader(fileNamed: "test3.fsh")
        
        
        
        
        let backgroundImage = SKSpriteNode(imageNamed: "thingy")
        //backgroundImage.position = view.center
        backgroundImage.shader = shaderz
        let fill = CGSize(width: size.width, height: size.height)
        backgroundImage.scale(to: fill)
        self.addChild(backgroundImage)
        backgroundImage.zPosition = 0
        
        
        let field = SKFieldNode.noiseField(withSmoothness: 0.5, animationSpeed: 0.1)
        field.isEnabled = true
        field.position = view.center
        field.strength = 0.5
        self.addChild(field)
        field.categoryBitMask = cat1
        
        
        GameScene.aud.distortion.loadFactoryPreset(AVAudioUnitDistortionPreset.multiEchoTight1)
        GameScene.aud.reverb.loadFactoryPreset(AVAudioUnitReverbPreset.plate)
        
        
        
    }
    
    
    
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        player?.position = pos
        
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
        player?.position = pos
        let px = pos.x+(size.width/2)
        let py = pos.y+(size.height/2)
        
        let vol =  px/size.width
        let vol2 =  1 - px/size.width
        
        
        
        //freq = Float(pos.y)
        let clamped = (px*0.5)+400
        
        
        
        GameScene.aud.filtParams3.frequency = Float(clamped)
        GameScene.aud.filtParams4.frequency = Float(py*2)
        
        
        //var vol = pos.width / pos.x
        
        GameScene.aud.playerA.volume = Float(vol)
        GameScene.aud.playerB.volume = Float(vol2)
        //GameScene.aud.reverb.loadFactoryPreset(AVAudioUnitReverbPreset.largeRoom)
        
        
        
        if (counter >= 20){
            
            //AudioKit.stop()
            let scene = SKScene(fileNamed: "Level2")
            
            scene?.scaleMode = .aspectFill
            
            //self.view?.presentScene(scene)
            self.view?.presentScene(scene!, transition:  SKTransition.fade(withDuration: 1))
            
            
            
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        checkTime(currentTime - lastTime)
        //print(currentTime - lastTime)
        lastTime = currentTime
        
        
        
    }
    
    func checkTime(_ frameRate:TimeInterval){
        
        timeSinceFire += frameRate
        if(timeSinceFire > 1000){
            
            
            timeSinceFire = 0
        }
        
        if timeSinceFire < fireRate {
            
            return
        }
        
        spawnShip()
        spawnShip()
        spawnShip()
        spawnShip()
        
        
        timeSinceFire = 0
        
    }
    
    
    
    
    func generateFade(_ gain: Double, _ test:  Bool) -> AVAudioPCMBuffer {
        z = Float(gain)
        
        let test = test
        
        
        let period = 1000
        
        let newbuffer = AVAudioPCMBuffer(pcmFormat: GameScene.aud.playerA.outputFormat(forBus: 0), frameCapacity: UInt32(period))
        newbuffer.frameLength = UInt32(period)
        
        let gainDelta = Float(period) / z
        //var gd2 = gainDelta
        
        if (test == true){
            for _ in 0..<period {
                
                z += gainDelta
                zUse =  (z * 0.01) - 10.0
                
                
            }
        }
        
        if(test == false){
            
            for _ in 0..<period {
                
                z -= gainDelta
                zUse =  z * 0.01
                //print(zUse)
                
            }
        }
        GameScene.aud.distortion.wetDryMix = zUse
        
        return newbuffer
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
      
        
        let arrSound = ["sc1_h.wav","sc1_j.wav","sc1_e.wav","sc1_k.wav","sc1_i.wav","sc1_f.wav","sc1_l.wav"]
        
        guard let cA = contact.bodyA.node else{return}
        guard let cB = contact.bodyB.node else{return}
        
        
        
        if cA.name == "Enemy1"{
            playerDidCollide(with: cA)
            let explosion:SKEmitterNode = (SKEmitterNode(fileNamed: "explosion1"))!
            explosion.position = contact.bodyA.node!.position
            self.addChild(explosion)
            
            let randomSound = arrSound[Int(arc4random_uniform(UInt32(arrSound.count)))]
            
            self.run(SKAction.playSoundFileNamed(randomSound, waitForCompletion: false))
            
            counter = counter + 1
            
        }
        
        if cB.name == "Enemy1"{
            playerDidCollide(with: cB)
            let explosion:SKEmitterNode = (SKEmitterNode(fileNamed: "explosion1"))!
            explosion.position = contact.bodyA.node!.position
            self.addChild(explosion)
            
            let randomSound = arrSound[Int(arc4random_uniform(UInt32(arrSound.count)))]
            
            
            self.run(SKAction.playSoundFileNamed(randomSound, waitForCompletion: false))
            
            counter = counter + 1
            
            
        }
        
        
    }
    
    func playerDidCollide(with other:SKNode) {
        let otherCategory = other.physicsBody?.categoryBitMask
        if otherCategory == cat1 {
            other.removeFromParent()
            //explosion.removeFromParent()
            test2 = !test2
            if(test2){
                generateFade(1000, true)}
                
            else {generateFade(1000, false)}
            
            
            
        }
        
        
        
    }
    
    
}


