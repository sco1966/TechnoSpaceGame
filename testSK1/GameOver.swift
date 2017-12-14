

import SpriteKit





class GameOver: SKScene {
    
    //static var MasterEngine = Samplerz()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Title.MasterEngine.sampler
        
        GameScene2.valuez = 0
        GameScene.aud.playerA.stop()
        GameScene.aud.playerB.stop()
        
        
        
        // Load the SKScene from 'GameScene.sks'
        let scene = SKScene(fileNamed: "Title")
        // Set the scale mode to scale to fit the window
        // scene.scaleMode = .aspectFill
        
        // Present the scene
        self.view?.presentScene(scene)
        
        
        
        
    }
    
    
    
    
    
}


class SectionOver: SKScene {
    
    //static var MasterEngine = Samplerz()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Title.MasterEngine.sampler
        
        GameScene2.valuez = 0
        GameScene.aud.playerA.stop()
        GameScene.aud.playerB.stop()
        GameScene.sections = true
        
        
        
        // Load the SKScene from 'GameScene.sks'
        let scene = SKScene(fileNamed: "GameScene")
        // Set the scale mode to scale to fit the window
        // scene.scaleMode = .aspectFill
        
        // Present the scene
        self.view?.presentScene(scene)
        
        
        
        
    }
    
    
    
    
    
}
