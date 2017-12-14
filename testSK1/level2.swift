
import SpriteKit





class Level2: SKScene {
    
    //static var MasterEngine = Samplerz()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Title.MasterEngine.sampler
        
        
        
        
        
        // Load the SKScene from 'GameScene.sks'
        let scene = SKScene(fileNamed: "GameScene2")
        // Set the scale mode to scale to fit the window
        // scene.scaleMode = .aspectFill
        
        // Present the scene
        self.view?.presentScene(scene)
        
        
        
        
    }
    
    
    func reset(){
        
        
        
        
        
        
        
    }
    
    
    
}
