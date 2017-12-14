//
//  AudioClass1.swift
//  testSK1
//
//  Created by Scott Lawrence Simon on 24/11/17.
//  Copyright © 2017 Scott Lawrence Simon. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import SpriteKit


class AudioClass1: UIViewController {
    
    
    var playerA: AVAudioPlayerNode!
    var playerB: AVAudioPlayerNode!
    
    var filter3 = AVAudioUnitEQ()
    var filtParams3 = AVAudioUnitEQFilterParameters()
    
    var filter4 = AVAudioUnitEQ()
    var filtParams4 = AVAudioUnitEQFilterParameters()
    
    var distortion = AVAudioUnitDistortion()
     var reverb = AVAudioUnitReverb()
    
    var engine: AVAudioEngine!
    
    var freq: Float!
    var freq2: Float!
    
    var file2:  AVAudioFile!
     var file:  AVAudioFile!
    
    
    func Audio1(){
        engine = AVAudioEngine()
        playerA = AVAudioPlayerNode()
        playerB = AVAudioPlayerNode()
        playerA.volume = 0.5
        playerB.volume = 0.5
        freq = 650.0
        freq2 = 1080.0
        
        
        
//        let path2 = Bundle.main.path(forResource: "thorz2", ofType: "wav")!
//        let url2 = URL(fileURLWithPath: path2)
        
        let path = Bundle.main.path(forResource: "Bast1", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        
        
        // Here you are creating an AVAudioFile from the sound file,
        // preparing a buffer of the correct format and length and loading
        // the file into the buffer
        
      
        
        
        // var commonFormat: AVAudioCommonFormat {file}
        //let file = try? AVAudioFile(forReading: url, commonFormat:1, interleaved: true)
        let buffer = AVAudioPCMBuffer(pcmFormat: file!.processingFormat, frameCapacity: AVAudioFrameCount(file!.length))
        try! file!.read(into: buffer)
        
        
        filter3 = AVAudioUnitEQ(numberOfBands: 1)
        //filtParams: AVAudioUnitEQFilterParameters = filter3.bands.first as! AVAudioUnitEQFilterParameters
        //filtParams3 = filter3.bands.first as! //AVAudioUnitEQFilterParameters
        filtParams3 = filter3.bands.first!
        filtParams3.filterType = .bandPass
        filtParams3.frequency = Float(freq)
        filtParams3.gain = 1
        filtParams3.bandwidth = 0.05
        filtParams3.bypass = false
        
        filter4 = AVAudioUnitEQ(numberOfBands: 1)
        filtParams4 = filter4.bands.first!
        filtParams4.filterType = .highPass
        filtParams4.frequency = Float(freq2)
        filtParams4.bandwidth = 0.05
        filtParams4.gain = 1.0
        filtParams4.bypass = false
        

        //let reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.cathedral)
        reverb.wetDryMix = 75
        
  
        let chorus = AVAudioUnitDelay()
        
        chorus.delayTime = 20.0
        chorus.feedback = 0
        chorus.wetDryMix = 30
        
        //let distortion = AVAudioUnitDistortion()
        distortion.loadFactoryPreset(AVAudioUnitDistortionPreset.drumsLoFi)
        distortion.wetDryMix = 0
        
        // Attach the four nodes to the audio engine
        engine.attach(playerA)
        engine.attach(playerB)
        engine.attach(reverb)
        engine.attach(chorus)
        engine.attach(distortion)
        
        engine.attach(filter3)
        engine.attach(filter4)
        
        // Connect playerA to the reverb
        engine.connect(playerA, to: reverb, format: buffer.format)
        
        // Connect the reverb to the mixer
        engine.connect(reverb, to: filter3, format: buffer.format)
        
        engine.connect(filter3, to: engine.mainMixerNode, format: buffer.format)
        
        
        
        // Connect playerB to the distortion
        engine.connect(playerB, to: distortion, format: buffer.format)
        
        engine.connect(distortion, to: filter4, format: buffer.format)
        
        // Connect the distortion to the mixer
        engine.connect(filter4, to: engine.mainMixerNode, format: buffer.format)
        
        // Schedule playerA and playerB to play the buffer on a loop
        playerA.scheduleBuffer(buffer, at: nil, options: AVAudioPlayerNodeBufferOptions.loops, completionHandler: nil)
        playerB.scheduleBuffer(buffer, at: nil, options: AVAudioPlayerNodeBufferOptions.loops, completionHandler: nil)
        
        // Start the audio engine
        engine.prepare()
        try! engine.start()
        
        
        playerA.play()
        
        
        playerB.play()
        
        
        
        
    }

}
