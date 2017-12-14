
import SpriteKit
import GameplayKit


extension GameScene2{

    func spawnShip() {
        
        let EnemyS2 = SKSpriteNode(imageNamed:  "enemy2")
        
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
        
        
        let z = CGSize(width: 20, height: 20)
        EnemyS2.scale(to: z)
        EnemyS2.physicsBody?.categoryBitMask = enemyCategory
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let cA:UInt32 = contact.bodyA.categoryBitMask
        let cB:UInt32 = contact.bodyB.categoryBitMask
        
        if (cA == playerCategory || cB == playerCategory) {
            let otherNode:SKNode = (cA == playerCategory) ? contact.bodyB.node! : contact.bodyA.node!
            playerDidCollide(with: otherNode)
        }
            
            
        else{
            let explosion:SKEmitterNode = (SKEmitterNode(fileNamed: "Explosion"))!
            
            
            if(contact.bodyA.node?.position != nil){
                explosion.position = contact.bodyA.node!.position
                explosion.position = (contact.bodyA.node?.position)!
                self.addChild(explosion)
                self.run(SKAction.playSoundFileNamed("sc2", waitForCompletion: false))
                counter = counter + 1
            }
            //print(contact.bodyA.node?.position)
            
            
            
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
                counter = counter + 1
        }
    }
    
    
    func playerDidCollide(with other:SKNode) {
        let otherCategory = other.physicsBody?.categoryBitMask
        if otherCategory == itemCategory {
            other.removeFromParent()
            self.run(SKAction.playSoundFileNamed("blip4Mono1", waitForCompletion: false))
            
            
            
        }
        else if otherCategory == enemyCategory {
            other.removeFromParent()
            player?.removeFromParent()
             self.run(SKAction.playSoundFileNamed("sc1_d", waitForCompletion: false))
            
            //to do:  player counter --
            //add game over screen.....
            
            let scene = SKScene(fileNamed: "GameOver")
            
            scene?.scaleMode = .aspectFill
            
            self.view?.presentScene(scene)
            
            
            
        }
        
        
   }






}
