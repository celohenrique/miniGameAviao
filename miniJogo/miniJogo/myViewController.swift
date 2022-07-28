//
//  myViewController.swift
//  Created by Marcelo Araujo on 20/07/22.
//

import SpriteKit

class myViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.landscape) //calling struct
        
        //creating my SKView
        let myView:SKView = SKView(frame: self.view.frame)
        self.view = myView
        
        // creating scene and presenting on SKView
        let myScene: MyScene = MyScene(size: myView.frame.size)
        myView.contentMode = .scaleToFill
        myView.presentScene(myScene)
        myView.ignoresSiblingOrder = false //sobreposicao de item
        myView.showsFPS = true
        myView.showsNodeCount = true
        myView.showsPhysics = true
        
        
        // loads the scene
    }
    
}

//locking the phone just on landscape
struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask){
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
            delegate.orientationLock = orientation
        }
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
