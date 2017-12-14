
import SpriteKit
import GameplayKit


extension stage3a{

    func spawnShip() {
        
        let EnemyS2 = SKSpriteNode(imageNamed:  "z1")
        
        let frame1:SKTexture = SKTexture(imageNamed: "z1")
        let frame2:SKTexture = SKTexture(imageNamed: "z2")
        let frame3:SKTexture = SKTexture(imageNamed: "z3")
        let frame4:SKTexture = SKTexture(imageNamed: "z7")
        
        let animation:SKAction = SKAction.animate(with: [frame1,frame2,frame3,frame4], timePerFrame: 0.1)
        let repeatAction:SKAction = SKAction.repeatForever(animation)
        
        
        EnemyS2.position = CGPoint(x: 2 * random(min: 0, max: 1),y:  2 * random(min: 0, max: 1))
        
        
        EnemyS2.run(repeatAction)
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
        
        let zb = randomz() + 20
        //print(zb)
        let z = CGSize(width: zb, height: zb)
        EnemyS2.scale(to: z)
        EnemyS2.physicsBody?.categoryBitMask = cat1
        EnemyS2.physicsBody?.collisionBitMask = noCategory
        EnemyS2.physicsBody?.contactTestBitMask = playerCategory
        EnemyS2.zPosition = 1
        
    
        
        
    }
    

    
    func random() -> CGFloat {
       
        return CGFloat(Float(arc4random_uniform(UInt32(400 - 343))))
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
    func randomz() -> CGFloat {
        
        return CGFloat(Float(arc4random_uniform(UInt32(40))))
    }






}
