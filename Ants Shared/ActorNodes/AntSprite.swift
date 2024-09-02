//
//  AntSprite.swift
//  Ants
//
//  Created by Doug Whitmore on 9/1/24.
//

import SpriteKit

class AntNode: SKSpriteNode {
    var antModel: AntModel
    fileprivate var antFrames: [SKTexture] = []
    
    convenience init(antModel: AntModel, antFrames: [SKTexture]) {
        let texture = SKTexture(imageNamed: "Bug")
        
        let firstTexture = antFrames.first
        self.init(texture: firstTexture, color: SKColor.clear, size: CGSize(width: 64, height: 64))
        self.antModel = antModel
        self.antFrames = antFrames
        let frameAnimation = SKAction.animate(with: self.antFrames, timePerFrame: 0.25)
        run(SKAction.repeatForever(frameAnimation), withKey: "antWalkAnimation")
    }
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        antModel = AntModel(position: .zero, vector: CGPoint(x: 0, y: 1))
        super.init(texture: texture, color: color, size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func step() {
        antModel.randomWalkStep(fraction: 1.0)
        position = antModel.position
        zRotation = -antModel.rotation
    }
}
