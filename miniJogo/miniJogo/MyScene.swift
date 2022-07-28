//
//  MyScene.swift
//  miniJogo
//
//  Created by Marcelo Araujo on 20/07/22.
//

import SpriteKit

var score : Int = 0
var start : Bool = false
var endGame : Bool = false
var restart : Bool = false

var idPlane : UInt32 = 1
var idEnemy : UInt32 = 2
var idPeninha : UInt32 = 3


class MyScene: SKScene, SKPhysicsContactDelegate {
    
    //creating the text boxes programtically:))))))
    
    let textScore = SKLabelNode(fontNamed: "True Crimes")
    let startText = SKLabelNode(fontNamed: "True Crimes")
    
    let plane:AnimatedObj = AnimatedObj("aviao")
    
    let moveAction = SKAction.moveTo(x: -100, duration: 5)
    let removeAction = SKAction.removeFromParent()
    
    let objectDummy = SKNode()
    
    var randomItens = SKAction()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.blue
        
        self.physicsWorld.contactDelegate = self
        
        var backgroundImage:SKSpriteNode = SKSpriteNode()
        
        
        let moveBackground = SKAction.moveBy(x: -self.size.width, y: 0, duration: 5)
        let resizeBackground = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
        let reDo = SKAction.repeatForever(SKAction.sequence([moveBackground,resizeBackground]))
        
        for i in 0..<2 {
            backgroundImage = SKSpriteNode(imageNamed: "BG.png") //change???
            backgroundImage.anchorPoint = CGPoint(x: 0, y:0)
            
            backgroundImage.size.width = self.size.width //get the right pixel on phone
            backgroundImage.size.height = self.size.height
            backgroundImage.zPosition = -1 //Z positions define what itens comes in front goes from ex: 0,1,2,3 etc
            backgroundImage.position = CGPoint(x:self.size.width * CGFloat(i), y:0)
            backgroundImage.run(reDo)
            
            objectDummy.addChild(backgroundImage) //add image to scene
            
        }
        
        
        self.addChild(objectDummy)
        objectDummy.speed = 0
        
        plane.name = "Plane"
        plane.position = CGPoint(x: 100, y: 100)
        self.addChild(plane)
        
        
        //        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        //        borderBody.friction = 0
        //        self.physicsBody = borderBody
        
        //configuring the text boxes programatically******* :))))
        startText.fontSize = 70
        startText.text = "Iniciar"
        textScore.text = "Pontos: \(score)"
        
        textScore.horizontalAlignmentMode = .right
        textScore.verticalAlignmentMode = .top
        
        textScore.fontColor = .white
        startText.fontColor = .white
        
        
        textScore.position = CGPoint(x: frame.maxX-10, y:frame.maxY-10)
        startText.position = CGPoint(x:frame.midX,y:frame.midY)
        
        self.addChild(textScore)
        self.addChild(startText)
        
        randomItens = SKAction.run{
            let random = Int.random(in: 0..<20)
            
            if random < 7 {
                creatEnemyA()
                
            }
            else if random >= 8 && random < 15{
                creatEnemyB()
            }
            else {
                reward()
            }
        }
        
        
        
        //creating event to enemy
        func creatEnemyA(){
            let randomY = Float.random(in: 20..<120)
            let lesmo:AnimatedObj = AnimatedObj("lesmo")
            lesmo.setScale(0.8)
            lesmo.position = CGPoint(x: self.size.width+100, y: CGFloat(randomY))
            
            lesmo.name = "Enemy"
            lesmo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: lesmo.size.width-10, height: 30), center: CGPoint(x: 0, y: -lesmo.size.height/2+15))
            lesmo.physicsBody?.isDynamic = false
            lesmo.physicsBody?.allowsRotation = false
            lesmo.physicsBody?.categoryBitMask = idEnemy
            
            lesmo.run(SKAction.sequence([moveAction,removeAction]))
            self.addChild(lesmo)
        }
        
        func creatEnemyB(){
            let randomY = Float.random(in: 150..<400) //randomizando a posicao do bicho
            let bugado:AnimatedObj = AnimatedObj("bugado") //chamando animacao do .atlas
            
            bugado.setScale(0.8) //tamanho
            bugado.position = CGPoint(x: self.size.width+100, y: CGFloat(randomY)) //criando ele
            
            bugado.name = "Enemy"
            bugado.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bugado.size.width-10, height: 30), center: CGPoint(x: 0, y: -bugado.size.height/2+15)) //espaco da fisica
            
            bugado.physicsBody?.isDynamic = false
            bugado.physicsBody?.allowsRotation = false
            bugado.physicsBody?.categoryBitMask = idEnemy
            
            bugado.run(SKAction.sequence([moveAction,removeAction])) //criando a sequencia
            self.addChild(bugado) //adicionando ele na Scene
        }
        
        //trocar pela moeda de ouro
        
        func reward(){
            let randomY = Float.random(in: 40..<250)
            let peninha:AnimatedObj = AnimatedObj("coin")
            peninha.setScale(0.05)
            peninha.position = CGPoint(x: self.size.width+100, y: CGFloat(randomY))
            
            peninha.name = "Reward"
            
            peninha.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: peninha.size.width-10, height: 60), center: CGPoint(x: 0, y: -peninha.size.height/2+15))
            peninha.physicsBody?.isDynamic = false
            peninha.physicsBody?.allowsRotation = false
            peninha.physicsBody?.categoryBitMask = idPeninha
            
            peninha.run(SKAction.sequence([moveAction,removeAction]))
            self.addChild(peninha)
        }
        
        //creating actions walk/float
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        
        if !endGame{
            if !start {
                start = true
                plane.physicsBody = SKPhysicsBody(circleOfRadius: plane.size.height/2.5, center: CGPoint(x: 10, y: 0))
                plane.physicsBody?.isDynamic = true
                plane.physicsBody?.allowsRotation = false
                
                plane.physicsBody?.categoryBitMask = idPlane
                plane.physicsBody?.collisionBitMask = 0
                plane.physicsBody?.contactTestBitMask = idEnemy | idPeninha
                
                
                startText.isHidden = true
                objectDummy.speed = 0 //keeps on 1 or change to 0????**
                self.run(SKAction.repeatForever(SKAction.sequence([randomItens, SKAction.wait(forDuration: 2.5)])))
                
            }
            self.plane.physicsBody?.velocity = CGVector.zero
            self.plane.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 79))
        }
        else {
            if restart {
                plane.position = CGPoint(x: frame.maxX*0.2, y: frame.midY)
                plane.physicsBody?.velocity = CGVector.zero
                plane.physicsBody?.isDynamic = false
                plane.zRotation = 0
                start = false
                endGame = false
                restart = false
                startText.isHidden = true
                objectDummy.speed = 0 //change to 0 if bd keeps on 0
                score = 0
                textScore.text = "Pontos: \(score)"
            }
        }
    }
    
    override func didSimulatePhysics() {
        
        if start {
            self.plane.zRotation = (self.plane.physicsBody?.velocity.dy)!*0.0007 //rotation uses Radius so 3 = 180 graus
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if !endGame && start{
            
            if plane.position.y < plane.size.height/2+10{ //if the plane height is lower than half plus 10
                
                endGames()
            }
            
            if plane.position.y > self.size.height+10 { //same but with scene
                
                endGames()
            }
            
        }
        
    }
    func endGames(){
        
        endGame = true
        self.plane.physicsBody?.velocity = CGVector.zero
        self.plane.physicsBody?.applyImpulse(CGVector(dx: -90, dy: 50))
        objectDummy.speed = 0 //take out depending on BD choice
        startText.isHidden = false
        startText.text = "Fim da linha por aqui"
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run {
            
            self.startText.text = "Toque para reiniciar"
            restart = true
            
            let children = self.children
            
            for clean in children {
                if clean.name != nil{
                    if clean.name! == "Reward" || clean.name! == "Enemy"{
                        clean.removeFromParent()
                    }
                }
                
            }
            
            
        }]))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "Enemy"{
            
            endGames()
            
        }
        if contact.bodyA.node?.name == "Reward" {
            
            contact.bodyA.node?.removeFromParent()
            score += 1
            textScore.text = "Pontos: \(score)"
            
        }
        
    }
    
    
}
