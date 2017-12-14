
import SpriteKit
import GameplayKit


extension GameScene2{
 
    func shaderz(shade:  String){
      
        // Shader work with pixels, not points like we are used to on iOS. Store scale for use below.
        let scale = UIScreen.main.scale
        
        // Setup a container sprite for the shader that makes the movement
        // We are using an empty image in a sprite node because sprite nodes allow you to specify size, and shader.
        let moveNode = SKSpriteNode(imageNamed: "dummypixel")
        moveNode.position = CGPoint(x: frame.midX, y: frame.midY)
        moveNode.size = frame.size
        addChild(moveNode)
        // Create the shader from a shader-file
        let moveShader = SKShader(fileNamed: shade)
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
        
        

        
         let reflectNode = SKSpriteNode(imageNamed: "test2")
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
    
    func shaderz2(shade:  String){
        
        // Shader work with pixels, not points like we are used to on iOS. Store scale for use below.
        let scale = UIScreen.main.scale
        
        // Setup a container sprite for the shader that makes the movement
        // We are using an empty image in a sprite node because sprite nodes allow you to specify size, and shader.
        let moveNode = SKSpriteNode(imageNamed: "dummypixel")
        moveNode.position = CGPoint(x: frame.midX, y: frame.midY)
        moveNode.size = frame.size
        addChild(moveNode)
        // Create the shader from a shader-file
        let moveShader = SKShader(fileNamed: shade)
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
        
        
        


}

}
