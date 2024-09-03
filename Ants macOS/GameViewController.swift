//
//  GameViewController.swift
//  Ants macOS
//
//  Created by Doug Whitmore on 9/1/24.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene.newGameScene(with: view.frame.size)
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.allowsTransparency = true
        skView.wantsLayer = true
        skView.layer?.backgroundColor = .clear
    }

}

