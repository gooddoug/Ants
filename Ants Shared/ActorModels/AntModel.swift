//
//  Ant.swift
//  Ants
//
//  Created by Doug Whitmore on 9/1/24.
//

import Foundation
import Accelerate
import GameplayKit

struct AntModel {
    var position: CGPoint // is a point correct? Or should it be something else?
    var vector: CGPoint // where is it moving to?
    // rotation in radians
    var rotation: CGFloat { // get this from the vector
        let rads = atan2(vector.x, vector.y)
        return rads
    }
    
    var speed: CGFloat {
        return vector.vectorLength
    }
    
    mutating func updateSpeed(by speedChange: CGFloat) {
        let originalSpeed = speed
        let newSpeed = originalSpeed + speedChange
        let factor = newSpeed / originalSpeed
        let newVector = CGPoint(x: vector.x * factor, y: vector.y * factor)
        vector = newVector
    }
    
    mutating func rotate(by rads: CGFloat) {
        // rotate the vector
        /*
         𝑥2=cos𝛽𝑥1−sin𝛽𝑦1
         𝑦2=sin𝛽𝑥1+cos𝛽𝑦1
         */
        let sinRads = -sin(rads)
        let cosRads = -cos(rads)
        let newX = (cosRads * vector.x) - (sinRads * vector.y)
        let newY = (sinRads * vector.x) + (cosRads * vector.y)
        let newVector = CGPoint(x: newX, y: newY)
        vector = newVector
    }
    
    mutating func move(fraction: CGFloat = 1.0) {
        let currentVectorLength = vector.vectorLength
        let newVectorLength = currentVectorLength * fraction
        let factor = newVectorLength / currentVectorLength
        let fractionalVector = vector * factor
        let newPosition = position + fractionalVector
        position = newPosition
    }
    
    static func nextRotationThreshold() -> Int {
        GKRandomSource.sharedRandom().nextInt(upperBound: 100)
    }
    
    var rotationThreshold = nextRotationThreshold()
    var rotationStep = 0
    
    // smaller numbers are more rotation
    fileprivate let rotationFactor: Float = 0.35
    
    mutating func randomWalkStep(fraction: CGFloat) {
        // move the direction we were already headed
        move(fraction: fraction)
        // add a random rotation for next step
        // need a better way to rotate
        if rotationStep > rotationThreshold {
            let randomSource = GKRandomSource.sharedRandom()
            let randomFactor = randomSource.nextUniform() * rotationFactor
            let rotInRads = CGFloat(.pi * (1 - randomFactor)) // rotate a little
            let right = randomSource.nextBool()
            let nextRot = CGFloat((right ? -1 : 1) * rotInRads)
            rotate(by: nextRot)
            rotationStep = 0
            rotationThreshold = AntModel.nextRotationThreshold()
        } else {
            rotationStep += 1
        }
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    var vectorLength: CGFloat {
        return sqrt((x * x) + (y * y))
    }
}
