
import SpriteKit
import GameplayKit
import AVFoundation


class Stage2: SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode?
    //var enemy:SKSpriteNode?
    //var EnemyS2:SKSpriteNode?
    var item:SKSpriteNode?
    
    //var timeNextRate:TimeInterval = 10.0
    var t = 0.0
    var timeBegin:TimeInterval = 0
    
    var counter: Int = 0
    
    var changeRate:TimeInterval = 3.0
    var timeSinceChange:TimeInterval = 0
    
    var lastTime:TimeInterval = 0
    
    let noCategory:UInt32 = 0
    let playerCategory:UInt32 = 0b1 << 1
    let itemCategory:UInt32 = 0b1 << 3

    
    
    override func didMove(to view: SKView) {
        
       
        self.physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "player") as? SKSpriteNode
        
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = noCategory
        player?.physicsBody?.contactTestBitMask = itemCategory
        
        player?.zPosition = 1
        
         let shaderz2 = SKShader(fileNamed: "test2.fsh")
        
        
        let backgroundImage = SKSpriteNode(imageNamed: "mandel")
        //backgroundImage.position = view.center
        backgroundImage.shader = shaderz2
        let fill = CGSize(width: size.width, height: size.height)
        backgroundImage.scale(to: fill)
        self.addChild(backgroundImage)
        backgroundImage.zPosition = 0
        
        
        
        
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
 
        
        guard let cA = contact.bodyA.node else{return}
        guard let cB = contact.bodyB.node else{return}
        
        
        
        if cA.name == "Enemy1"{
            playerDidCollide(with: cA)
            let explosion:SKEmitterNode = (SKEmitterNode(fileNamed: "explosion2"))!
            explosion.position = contact.bodyA.node!.position
            self.addChild(explosion)
            
        }
        
        if cB.name == "Enemy1"{
            playerDidCollide(with: cB)
            let explosion:SKEmitterNode = (SKEmitterNode(fileNamed: "explosion2"))!
            explosion.position = contact.bodyA.node!.position
            self.addChild(explosion)
            
        }
        
        
        
        
    }
    
    func playerDidCollide(with other:SKNode) {
        
        let arrSound = ["brown1","blip4Mono1","blip4Mono2","blip4Mono3"]
        let randomSound = arrSound[Int(arc4random_uniform(UInt32(arrSound.count)))]
        
        
        let otherCategory = other.physicsBody?.categoryBitMask
        if otherCategory == itemCategory {
            other.removeFromParent()
            self.run(SKAction.playSoundFileNamed(randomSound, waitForCompletion: false))
            
            
            
            counter = counter + 1
            
        }
        
        
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        player?.position = pos
        let px = pos.x+(size.width/2)
        let py = pos.y+(size.height/2)
        
        //let vol =  px/size.width
       // let vol2 =  1 - px/size.width
        
        
        
        //freq = Float(pos.y)
        let clamped = (py*0.5)+400
        

        
        GameScene.aud.filtParams3.frequency = Float(clamped)
        GameScene.aud.filtParams4.frequency = Float(px*2)
        

    }
    
    func touchDown(atPoint pos : CGPoint) {
        player?.position = pos
        
      
        
        
    }
    
    
    
    func touchUp(atPoint pos : CGPoint) {
        player?.position = pos
   
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
        
        checkEnemy(currentTime - lastTime)
        
        lastTime = currentTime
        
        
        if (counter >= 20){
            
          
            let scene = SKScene(fileNamed: "stage3a")
            
            scene?.scaleMode = .aspectFill
            
            //self.view?.presentScene(scene)
             self.view?.presentScene(scene!, transition:  SKTransition.fade(withDuration: 1))
            
           
           
            
        }
        
    
        
    }
    
    func checkEnemy(_ frameRate:TimeInterval) {
        // add time to timer
        timeSinceChange += frameRate
        
        if timeSinceChange < changeRate {
            return
        }
        
        
        spawnEnemy()
        spawnEnemy()
        spawnEnemy()
        
        
        timeSinceChange = 0
    }
    
    func spawnEnemy() {
        
        let EnemyS2 = SKSpriteNode(imageNamed:  "transparent2")
        
        EnemyS2.position = CGPoint(x: 2 * random(min: 0, max: 1),y:  2 * random(min: 0, max: 1))
        
        self.addChild(EnemyS2)
        
        EnemyS2.name = "Enemy1"
        
        
        EnemyS2.physicsBody = SKPhysicsBody(rectangleOf: EnemyS2.size)
        EnemyS2.physicsBody?.isDynamic = true
        EnemyS2.physicsBody?.allowsRotation = true
        EnemyS2.physicsBody?.affectedByGravity = false
        EnemyS2.physicsBody?.friction = 0.2
        EnemyS2.physicsBody?.restitution = 0.2
        EnemyS2.physicsBody?.angularDamping = 0.2
        EnemyS2.physicsBody?.mass = 0.006
        EnemyS2.physicsBody?.linearDamping = 0
        EnemyS2.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        let z = CGSize(width: 50, height: 50)
        EnemyS2.scale(to: z)
        
        
        
        EnemyS2.physicsBody?.categoryBitMask = itemCategory
        EnemyS2.physicsBody?.collisionBitMask = noCategory
        EnemyS2.physicsBody?.contactTestBitMask = playerCategory
        
        EnemyS2.zPosition = 1
        
        
    }
    
    func random() -> CGFloat {
        //this is the random spawn generator increasing or decreasing these two numbers will change how far or how close they spawn together
        return CGFloat(Float(arc4random_uniform(UInt32(400 - 343))))
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
}

