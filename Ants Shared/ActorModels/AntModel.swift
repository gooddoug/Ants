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
        let rads = atan2(vector.x, vector.y)// - 1.57 // offset by 90º
        return rads
    }
    
    var speed: CGFloat {
        let h = sqrt(vector.x * vector.x + vector.y * vector.y)
        return h
    }
    
    mutating func updateSpeed(by speedChange: CGFloat) {
        let originalSpeed = speed
        let newSpeed = originalSpeed + speedChange
        /*
         u = (L / sqrt(x^2 + y^2) * self
         */
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
        let fractionalVector = CGPoint(x: vector.x * factor, y: vector.y * factor)
        let newPosition = position + fractionalVector
        position = newPosition
    }
    
    static func nextRotationThreshold() -> Int {
        GKRandomSource.sharedRandom().nextInt(upperBound: 200)
    }
    
    var rotationThreshold = nextRotationThreshold()
    var rotationStep = 0
    
    mutating func randomWalkStep(fraction: CGFloat) {
        // move the direction we were already headed
        move(fraction: fraction)
        // add a random rotation for next step
        // need a better way to rotate
        if rotationStep > rotationThreshold {
            let randomFloat = GKRandomSource.sharedRandom().nextUniform() // number between 0 and 1
            let rotInRads = CGFloat(.pi * 0.75) // rotate a little
            let right = GKRandomSource.sharedRandom().nextBool()
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
    
    var vectorLength: CGFloat {
        return sqrt((x * x) + (y * y))
    }
}
