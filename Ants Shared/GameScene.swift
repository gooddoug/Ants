//
//  GameScene.swift
//  Ants Shared
//
//  Created by Doug Whitmore on 9/1/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?
    fileprivate var antNodes: [AntNode] = []
    fileprivate var antFrames: [SKTexture] = []
    
    class func newGameScene(with size: CGSize) -> GameScene {
        let scene = GameScene(size: size)
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        scene.backgroundColor = SKColor.clear
        
        return scene
    }
    
    func setUpScene() {
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 4.0
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        // create ant frames
        let spriteSheet = SpriteSheet(texture: SKTexture(imageNamed: "AntSpriteSheet"), rows: 1, columns: 4)
        antFrames = spriteSheet.frames
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }

    func makeAnt(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.strokeColor = color
            self.addChild(spinny)
        }
        
        let antModel = AntModel(position: .zero, vector: CGPoint(x: 0.85, y: 0.85))
        let antNode = AntNode(antModel: antModel, antFrames: antFrames)
        antNode.antModel.position = pos
        antNode.position = pos
        let rotation = CGFloat(GKRandomSource.sharedRandom().nextUniform() * 2 * .pi)
        antNode.antModel.rotate(by: rotation)
        antNode.zRotation = antNode.antModel.rotation
        self.addChild(antNode)
        let frameAnimation = SKAction.animate(with: antFrames, timePerFrame: 0.25)
        antNode.run(SKAction.repeatForever(frameAnimation), withKey: "antWalkAnimation")
        antNodes.append(antNode)
    }
    
    var spawnThreshold = 100
    var spawnTimer = 0
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for antNode in antNodes {
            antNode.step()
            if antNode.antModel.antState == .dead {
                antNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                  SKAction.fadeOut(withDuration: 0.5),
                                                  SKAction.removeFromParent()]))
            }
        }
        if spawnTimer > spawnThreshold {
            makeAnt(at: CGPoint(x: 100, y: 100), color: .green)
            spawnTimer = 0
        } else {
            spawnTimer += 1
        }
        // remove dead ants
        antNodes = antNodes.filter({ $0.antModel.antState != .dead })
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches {
//            self.makeAnt(at: t.location(in: self), color: SKColor.green)
//        }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            self.makeAnt(at: t.location(in: self), color: SKColor.blue)
//        }
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.makeAnt(at: t.location(in: self), color: SKColor.red)
        }
    }
    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            self.makeAnt(at: t.location(in: self), color: SKColor.red)
//        }
//    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeAnt(at: event.location(in: self), color: SKColor.green)
    }
    
//    override func mouseDragged(with event: NSEvent) {
//        self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
//    }
//    
//    override func mouseUp(with event: NSEvent) {
//        self.makeSpinny(at: event.location(in: self), color: SKColor.red)
//    }

}
#endif

