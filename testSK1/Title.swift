

import SpriteKit



var testOn = true

class Title: SKScene {
    
    //static var MasterEngine = Samplerz()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Title.MasterEngine.sampler
       
            GameScene2.valuez = 0
        
      
        
        // Load the SKScene from 'GameScene.sks'
            let scene = SKScene(fileNamed: "GameScene")
                // Set the scale mode to scale to fit the window
               // scene.scaleMode = .aspectFill
                
                // Present the scene
                self.view?.presentScene(scene)
        

       
       
    }
        
 
    


}
