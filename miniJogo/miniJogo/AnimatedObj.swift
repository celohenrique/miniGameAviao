//
//  AnimatedObj.swift
//  miniJogo
//
//  Created by Marcelo Araujo on 20/07/22.
//

import SpriteKit

class AnimatedObj: SKSpriteNode {
    
    var name1: String?
   
    init(_ name1: String){
        self.name1 = name1 //inicialize var otherwise will crash
        let texture1 = SKTexture(imageNamed: "\(name1)1")
        super.init(texture: texture1, color: .red, size: texture1.size())
        self.setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } //fixed auto how ?????
    
    //creating animation with SKTexture frames sequence
    
        func setup(){
        var image:[SKTexture] = []
            
            let atlas:SKTextureAtlas = SKTextureAtlas(named: name1!)
        
        for i in 1...atlas.textureNames.count {
            image.append(SKTexture(imageNamed: "\(self.name1!)\(i)"))
        }
        
        let animation:SKAction = SKAction.animate(with:
            image, timePerFrame: 0.1, resize: true, restore: true)
        
        self.run(SKAction.repeatForever(animation))
        
    
    }

}
