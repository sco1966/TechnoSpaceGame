//
//  Synth1.swift
//  Instrument
//
//  Created by Scott Lawrence Simon on 25/11/17.
//  modified from code by Simon Allardice. All rights reserved.
//

import Foundation
import AVFoundation
import AudioUnit
import UIKit


class Synth1 {

    var audioEngine : AVAudioEngine!
    // one player node
    var player : AVAudioPlayerNode!
    
    // one node to add reverb
    var reverb : AVAudioUnitReverb!
    
    var dist : AVAudioUnitDistortion!
    
    var filter3 = AVAudioUnitEQ()
    var filtParams3 = AVAudioUnitEQFilterParameters()
    
    var filter4 = AVAudioUnitEQ()
    var filtParams4 = AVAudioUnitEQFilterParameters()
    
    let delay = AVAudioUnitDelay()
    
   //let scale1 = [ 220.0, 293.664, 369.99, 415.30, 440.0, 466.16, 554.365,587.329,622.253,783.99, 880.0]
    //let scale2 = [ 220, 233.08, 293.66, 311.125, 392, 440.0, 466.16, 587.33, 622.25, 739.99, 880.0]
    
 

    
    //var effect1 : AVAudioUnit
    
    // frequency range
    let defaultFreq = 440.0 // A4 = 440
    let minimumFreq = 220.0 // A3, one octave below, half the amount
    let maximumFreq = 880.0 // A5, one octave above, twice the amount
    
    // gain range
    //let minimumGain = 0.25
   // let maximumGain = 0.2
    var bGain = 0.0
    
    // set this to true to restrict to a scale
    let restrictToScale = true
    var freqtest = 0.0
    
    // we use sampleRate a lot
    var sampleRate : Double!
    
    var z = 1.0
    
    func initializer(){
        audioEngine = AVAudioEngine()
        player = AVAudioPlayerNode()
        
        delay.delayTime = 0.7
        delay.feedback = 3
        delay.wetDryMix = 0
        
        // we need the sample rate (almost certainly 44100) to calculate our sine waves
        sampleRate = player.outputFormat(forBus: 0).sampleRate
        
        dist = AVAudioUnitDistortion()
        dist.loadFactoryPreset(AVAudioUnitDistortionPreset.speechGoldenPi)
        dist.wetDryMix = 0
        
        reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.largeHall)
        // from 0 (dry) to 100 (all reverb)
        reverb.wetDryMix = 0
        
        // setup audio engine
        audioEngine.attach(player)
        audioEngine.attach(reverb)
        audioEngine.attach(dist)
        audioEngine.attach(delay)
        
        // connect the nodes
        audioEngine.connect(player, to: reverb, format: nil)
        audioEngine.connect(reverb, to: dist, format: nil)
        audioEngine.connect(dist, to: delay, format: nil)
        audioEngine.connect(delay, to: audioEngine.outputNode, format: nil)
        
        audioEngine.prepare()
        try! audioEngine.start()
        
        
        
    }
    
    func generateSineFadeIn(_ frequency : Double, gain: Double) -> AVAudioPCMBuffer {
        var frequency = frequency, gain = gain
        
        // restrict to play specific notes
        if restrictToScale {
            frequency = enforceScale(frequency)
        }
        
        
        // how many samples needed for one complete wave?
        let period = Int( sampleRate / frequency )
        
        let newbuffer = AVAudioPCMBuffer(pcmFormat: player.outputFormat(forBus: 0), frameCapacity: UInt32(period))
        newbuffer.frameLength = UInt32(period)
        
        let gainDelta = gain / Double(period)
        
        for i in 0..<period {
            
            bGain += gainDelta
            if bGain >= gain { bGain = gain }
            if bGain <= 0 { bGain = 0.0 }
            let value = sin(frequency * Double(i) * (Double.pi * 2) / sampleRate)
            let value2 = sin((frequency * 1.5) * Double(i) * (Double.pi * 2) / sampleRate)
            newbuffer.floatChannelData?[0][i] = Float((value * value2) * (bGain * z))
            newbuffer.floatChannelData?[1][i] = Float((value * value2) * (bGain * z))
            
           // print(bGain)
        }
        return newbuffer
    }
    


func generateSineWave(_ frequency : Double, gain: Double) -> AVAudioPCMBuffer {
    
    freqtest = Double(frequency)
    var frequency = frequency
    
    
    // restrict to play specific notes
    if restrictToScale {
        frequency = enforceScale(frequency)
    }
    
    // how many samples needed for one complete wave?
    let period = Int( sampleRate / frequency )
    
    let newbuffer = AVAudioPCMBuffer(pcmFormat: player.outputFormat(forBus: 0), frameCapacity: UInt32(period))
    newbuffer.frameLength = UInt32(period)
    
    for i in 0..<period {
        let value = sin(frequency * Double(i) * (Double.pi * 2) / sampleRate)
        let value2 = sin((frequency * 1.5) * Double(i) * (Double.pi * 2) / sampleRate)
        newbuffer.floatChannelData?[0][i] = Float((value * value2) * (gain * z))
        newbuffer.floatChannelData?[1][i] = Float((value * value2) * (gain * z))
        
        
    }
    
   // print(freqtest)
    
    return newbuffer
}

func generateSineFade(_ frequency : Double, gain: Double) -> AVAudioPCMBuffer {
    var frequency = frequency, gain = gain
    
    // restrict to play specific notes
    if restrictToScale {
        frequency = enforceScale(frequency)
    }
    
    // how many samples needed for one complete wave?
    let period = Int( sampleRate / frequency )
    
    
    let newbuffer = AVAudioPCMBuffer(pcmFormat: player.outputFormat(forBus: 0), frameCapacity: UInt32(period))
    newbuffer.frameLength = UInt32(period)
    
    let gainDelta = gain / Double(period)
    bGain = 0.0
    
    
    for i in 0..<period {
      
        gain -= gainDelta
        if gain < 0 { gain = 0.0 }
        
        let value = sin(frequency * Double(i) * (Double.pi * 2) / sampleRate)
         let value2 = sin((frequency * 1.5) * Double(i) * (Double.pi * 2) / sampleRate)
        newbuffer.floatChannelData?[0][i] = Float((value * value2) * (gain * z))
        newbuffer.floatChannelData?[1][i] = Float((value * value2) * (gain * z))
    }
    return newbuffer
}

func enforceScale(_ inputPitch : Double) ->  Double {
    
    // A minor scale
    //let scale = [ 220, 246.94, 261.63, 293.66, 329.63, 349.23, 392.00, 440.0, 493.88, 523.25, 587.33, 659.26, 698.46, 783.99, 880.0]
    
    // Japanese iwato scale
    //let scale = [ 220, 233.08, 293.66, 311.125, 392, 440.0, 466.16, 587.33, 622.25, 739.99, 880.0]
    
    // let scale = [ 261.63, 277.18, 293.66, 329.63, 349.23, 369.99, 415.30, 440, 466.16, 494, 523.25]
    
//    let scale = [ 220, 261.625, 293.664, 329.627, 349.23, 369.99, 415.30, 440, 466.16, 494, 523.25,554.365,587.329,622.253,698.456,783.99,830.60]
        let scale = [ 220.0, 293.664, 369.99, 415.30, 440.0, 466.16, 554.365,587.329,622.253,783.99, 880.0]
    //scale2....
    
    //scale3....
    
    var closestPitch = scale.first!
    var maxDifference = abs(scale.first! - inputPitch)
    
    for currentPitch in scale {
        let difference = abs(currentPitch - inputPitch)
        if difference < maxDifference {
            maxDifference = difference
            closestPitch = currentPitch
        }
    }
    return closestPitch
}

}
