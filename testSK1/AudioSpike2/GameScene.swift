//
//  GameScene.swift
//  AudioSpike2
//
//  Created by Scott Lawrence Simon on 25/11/17.
//  Copyright © 2017 Scott Lawrence Simon. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let defaultFreq = 440.0 // A4 = 440
    let minimumFreq = 220.0 // A3, one octave below, half the amount
    let maximumFreq = 880.0 // A5, one octave above, twice the amount
    //
    //// gain range
    let minimumGain = 0.25
    let maximumGain = 0.2
    
    var synths: [Synth1] = [Synth1]()

    var Synth = Synth1()
  
    var Synth2 = Synth1()
    
    var Synth3 = Synth1()
   
    var Synth4 = Synth1()
    
    //from shipgame
    
    var player:SKSpriteNode?
    
    let noCategory:UInt32 = 0
    let laserCategory:UInt32 = 0b1
    let playerCategory:UInt32 = 0b1 << 1
    let enemyCategory:UInt32 = 0b1 << 2
    let itemCategory:UInt32 = 0b1 << 3
    
    var counter: Int = 0
    
    var timeBegin:TimeInterval = 0
    
    var fireRate:TimeInterval = 1.0
    var timeSinceFire:TimeInterval = 0
    
    var lastTime:TimeInterval = 0
    
    var changeRate:TimeInterval = 3.0
    var timeSinceChange:TimeInterval = 0
   
    
    override func didMove(to view: SKView) {
        
        
        self.physicsWorld.contactDelegate = self

        self.view?.isMultipleTouchEnabled = false
        
          synths.append(Synth)
        synths.append(Synth2)
         synths.append(Synth3)
        synths.append(Synth4)
     
        
        for i in 0..<synths.count{
            
            synths[i].initializer()
            
        }
        
      synths[0].dist.wetDryMix = 5//5
        synths[1].reverb.wetDryMix = 30//30
        synths[1].dist.wetDryMix = 0//5
        synths[2].reverb.wetDryMix = 10//10
        synths[3].dist.wetDryMix = 0
        synths[3].delay.wetDryMix = 10//20
        
        
        
        // from shipgame
        
    shaderz()
        player = self.childNode(withName: "player") as? SKSpriteNode
        
       
        
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = noCategory
        player?.physicsBody?.contactTestBitMask = itemCategory
        
        
    
        
     

        

    }

    
    
    func touchDown(atPoint pos : CGPoint) {
        
         player?.position = pos
        
        
        let px = pos.x+(size.width/2)
        
        
        
      
        let py = pos.y+(size.height/2)
        
        var ngain3: CGPoint
        
        // let pitchAndVolume = calculatePitchAndVolume(pos)
        
         for i in 0..<synths.count{
            
            let x = CGFloat(i+1)
            let y = CGFloat (i+1)
            
            ngain3 = CGPoint(x: px * x , y: py * y)
            let pitchAndVolume = calculatePitchAndVolume(ngain3)
            
            //print(synths[i].maximumFreq)
            let audioChunk = synths[i].generateSineFadeIn(pitchAndVolume.newPitch, gain:pitchAndVolume.newVolume)
            
            // now start playing (and looping) the new audio segment
            synths[i].player.scheduleBuffer(audioChunk, at: nil, options: .loops, completionHandler: nil)
            
            
            synths[i].player.play()
            
            
        }
        
   
        
        
        
   
        
     
    
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        let ngain = CGPoint(x: pos.x * 1.8, y: pos.y * 1.8)
//        let pitchAndVolume2 = calculatePitchAndVolume(ngain)
        
         player?.position = pos
        
        let px = pos.x+(size.width/2)
        let vol =  px/size.width
        let vol2 =  1 - px/size.width
        
        
        
        let py = pos.y+(size.height/2)
        let vol3 =  py/size.height
        let vol4 =  1 - py/size.height
        
        
        var ngain3: CGPoint
        
        
        for i in 0..<synths.count{
           
            let x = CGFloat(i+1)
            let y = CGFloat (i+1)
            
             ngain3 = CGPoint(x: px * x , y: py * y)
            
            let pitchAndVolume = calculatePitchAndVolume(ngain3)
            
            let newAudioChunk = synths[i].generateSineWave(pitchAndVolume.newPitch, gain:pitchAndVolume.newVolume)
            
              synths[i].player.scheduleBuffer(newAudioChunk, at: nil, options: .interruptsAtLoop, completionHandler:nil)
          
            synths[i].player.scheduleBuffer(newAudioChunk, at: nil, options: .loops, completionHandler: nil)
            
            
            

            
            
        }
    

        
        synths[0].z = Double(vol*vol3)
        synths[1].z = Double(vol2*vol3)
        synths[2].z = Double(vol*vol4)
        synths[3].z = Double(vol2*vol4)
      
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
         player?.position = pos
        
        let px = pos.x+(size.width/2)
       
        
        
        
        let py = pos.y+(size.height/2)
        
         var ngain3: CGPoint
        
       
        
        for i in 0..<synths.count{
            
            let x = CGFloat(i+1)
            let y = CGFloat (i+1)
            
             ngain3 = CGPoint(x: px * x , y: py * y)
             let result = calculatePitchAndVolume(ngain3)
            
          let fadingAudioBuffer = synths[i].generateSineFade(result.newPitch, gain:result.newVolume)
            
            // now start playing (and looping) the new audio segment
            synths[i].player.scheduleBuffer(fadingAudioBuffer, at: nil, options: .interruptsAtLoop, completionHandler: {
                self.synths[i].player.stop()
            })
        
            
        
            
            
        }
        
        

      
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
        checkLaser(currentTime - lastTime)
       // nextStage(currentTime - lastTime)
        
        checkEnemy(currentTime - lastTime)
        lastTime = currentTime
        
    }
    

    
    func calculatePitchAndVolume(_ touch: CGPoint) -> (newPitch : Double, newVolume: Double) {
        
        let fingerPosition = touch
        
        let width = size.width
        let height = size.height
        
        // this code maps a finger position to a frequency range
        let xRatio = fingerPosition.x / width
        let frequencyRange = maximumFreq - minimumFreq
        let positionInWidth = frequencyRange * Double(xRatio) + minimumFreq
        
        // we want a curve, or the pitches on left will be closer together than the pitches on the right
        let logMin = log(minimumFreq)
        let logMax = log(maximumFreq)
        let freqScale = (logMax - logMin) / (frequencyRange)
        let newFrequency = exp(logMin + (freqScale * (positionInWidth - minimumFreq)))
        
        // now, do the same on the Y axis to alter the volume (simple range this time)
        let yRatio = fingerPosition.y / height
        let gainRange = maximumGain - minimumGain
        let newGain = maximumGain - gainRange * Double(yRatio)
        
        return (newFrequency, newGain)
    }
    
    
    
    func checkLaser(_ frameRate:TimeInterval) {
        // add time to timer
        timeSinceFire += frameRate
        //print( timeSinceFire )
        // return if it hasn't been enough time to fire laser
        if timeSinceFire < fireRate {
            return
        }
        
       // status1 = true
        spawnLaser()
        //print(timeSinceFire)
        
        // reset timer
        timeSinceFire = 0
    }
    
    func spawnLaser() {
        let scene:SKScene = SKScene(fileNamed: "Laser")!
        let laser = scene.childNode(withName: "laser")
        laser?.position = player!.position
        laser?.move(toParent: self)
        laser?.physicsBody?.categoryBitMask = laserCategory
        laser?.physicsBody?.collisionBitMask = noCategory
        laser?.physicsBody?.contactTestBitMask = enemyCategory
        
    
        
        let waitAction = SKAction.wait(forDuration: 1.0)
        let removeAction = SKAction.removeFromParent()
        laser?.run(SKAction.sequence([waitAction,removeAction]))
        
    }
    
    func checkEnemy(_ frameRate:TimeInterval) {
        // add time to timer
        timeSinceChange += frameRate
        
        if timeSinceChange < changeRate {
            return
        }
        
        
        spawnShip()
        
        
        timeSinceChange = 0
    }
    
    


}
