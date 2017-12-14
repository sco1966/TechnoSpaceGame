
import SpriteKit
import GameplayKit


extension GameScene{
 
    func shaderz(){
      
        // Shader work with pixels, not points like we are used to on iOS. Store scale for use below.
        let scale = UIScreen.main.scale
        
        // Setup a container sprite for the shader that makes the movement
        // We are using an empty image in a sprite node because sprite nodes allow you to specify size, and shader.
        let moveNode = SKSpriteNode(imageNamed: "dummypixel")
        moveNode.position = CGPoint(x: frame.midX, y: frame.midY)
        moveNode.size = frame.size
        addChild(moveNode)
        // Create the shader from a shader-file
        let moveShader = SKShader(fileNamed: "shader_water_movement.fsh")
        // Set variables that are used in the shader script
        moveShader.uniforms = [
            SKUniform(
                name: "size",
                vectorFloat3: vector_float3(Float(scale * frame.width), Float(scale * frame.height), 0)
            ),
            SKUniform(
                name: "customTexture",
                texture: SKTexture(imageNamed: "test2")
            ),
        ]
        //Add the shader to the sprite
        moveNode.shader = moveShader
        
        
        // Setup a container sprite for the shader that makes the reflections
        // NOTE: It is necessary to modify your Info.plist to get this shader to work
        // PrefersOpenGL = YES
        //let reflectNode = SKSpriteNode(imageNamed: "dummypixel")
        
         let reflectNode = SKSpriteNode(imageNamed: "enemy")
        reflectNode.position = CGPoint(x: frame.midX, y: frame.midY)
        reflectNode.size = frame.size
        //reflectNode.size = scale
        addChild(reflectNode)
        // Create the shader from a shader-file
        let reflectShader = SKShader(fileNamed: "shader_water_reflection.fsh")
        // Set vairiables that are used in the shader script
        reflectShader.uniforms = [
            SKUniform(
                name: "size",
                vectorFloat3: vector_float3(Float(scale * frame.width), Float(scale * frame.height), 0)
            ),
        ]
        // Add the shader to the sprite
        reflectNode.shader = reflectShader
        
        
        
    }

}
