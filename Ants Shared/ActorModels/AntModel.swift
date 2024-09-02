//
//  Ant.swift
//  Ants
//
//  Created by Doug Whitmore on 9/1/24.
//

import Foundation
import Accelerate

struct AntModel {
    var position: CGPoint // is a point correct? Or should it be something else?
    var vector: CGPoint // where is it moving to?
    // rotation in radians
    var rotation: CGFloat { // get this from the vector
        let rads = atan2(vector.x, vector.y)
        return rads
    }
    
}
