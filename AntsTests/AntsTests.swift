//
//  AntsTests.swift
//  AntsTests
//
//  Created by Doug Whitmore on 9/1/24.
//

import XCTest

final class AntsTests: XCTestCase {

    func testSimpleVector() throws {
        var antModel = AntModel(position: CGPoint(x: 0, y: 0), vector: CGPoint(x: 0.24, y: 0.24))
        print(antModel.rotation)
        XCTAssertTrue(antModel.rotation > 0)
        antModel = AntModel(position: CGPoint(x: 0, y: 0), vector: CGPoint(x: -0.24, y: -0.24))
        print(antModel.rotation)
        XCTAssertTrue(antModel.rotation < 0)
        antModel = AntModel(position: CGPoint(x: 0, y: 0), vector: CGPoint(x: 0, y: 1))
        print(antModel.rotation)
        XCTAssertTrue(antModel.rotation == 0)
        antModel = AntModel(position: CGPoint(x: 0, y: 0), vector: CGPoint(x: 0, y: -1))
        print(antModel.rotation)
        XCTAssertTrue(antModel.rotation == .pi)
    }
    
    func testVectorSpeed() {
        var antModel = AntModel(position: CGPoint(x: 0, y: 0), vector: CGPoint(x: 0, y: 1))
        print(antModel.speed)
        XCTAssertTrue(antModel.rotation == 0)
        XCTAssertTrue(antModel.speed == 1)
        antModel = AntModel(position: CGPoint(x: 0, y: 0), vector: CGPoint(x: 0, y: -1))
        print(antModel.speed)
        XCTAssertTrue(antModel.rotation == .pi)
        XCTAssertTrue(antModel.speed == 1)
    }
    
    func testVectorRotateBy() {
        var antModel = AntModel(position: .zero, vector: CGPoint(x: 0.85, y: 0.85))
        var currentSpeed = antModel.speed
        var currentRotation = antModel.rotation
        antModel.rotate(by: 1.57)
        XCTAssertEqual(antModel.rotation, currentRotation + 1.57, accuracy: 0.01)
        XCTAssertTrue(antModel.speed == currentSpeed)
        
        antModel = AntModel(position: .zero, vector: CGPoint(x: -0.85, y: -0.85))
        currentSpeed = antModel.speed
        currentRotation = antModel.rotation
        antModel.rotate(by: 1.57)
        XCTAssertEqual(antModel.rotation, currentRotation + 1.57, accuracy: 0.01)
        XCTAssertTrue(antModel.speed == currentSpeed)
        
        antModel = AntModel(position: .zero, vector: CGPoint(x: 0, y: -1))
        currentSpeed = antModel.speed
        currentRotation = antModel.rotation
        antModel.rotate(by: 1.57)
        XCTAssertEqual(antModel.rotation, currentRotation + 1.57, accuracy: 0.01)
        XCTAssertTrue(antModel.speed == currentSpeed)
        
        antModel = AntModel(position: .zero, vector: CGPoint(x: 0, y: 1))
        currentSpeed = antModel.speed
        currentRotation = antModel.rotation
        antModel.rotate(by: 1.57)
        XCTAssertEqual(antModel.rotation, currentRotation + 1.57, accuracy: 0.01)
        XCTAssertTrue(antModel.speed == currentSpeed)
        
        antModel = AntModel(position: .zero, vector: CGPoint(x: 1, y: 0))
        currentSpeed = antModel.speed
        currentRotation = antModel.rotation
        antModel.rotate(by: 1.57)
        XCTAssertEqual(antModel.rotation, currentRotation + 1.57, accuracy: 0.01)
        XCTAssertTrue(antModel.speed == currentSpeed)
        
        antModel = AntModel(position: .zero, vector: CGPoint(x: -1, y: 0))
        currentSpeed = antModel.speed
        currentRotation = antModel.rotation
        antModel.rotate(by: 1.57)
        XCTAssertEqual(antModel.rotation, currentRotation + 1.57, accuracy: 0.01)
        XCTAssertTrue(antModel.speed == currentSpeed)
    }
    
    func testMove() {
        var antModel = AntModel(position: .zero, vector: CGPoint(x: 0.85, y: 0.85))
        var originalPostion = CGPoint.zero
        antModel.move()
        XCTAssertEqual(antModel.position, antModel.vector)
        antModel = AntModel(position: .zero, vector: CGPoint(x: 1.0, y: 0.0))
        antModel.move(fraction: 0.5)
        XCTAssertEqual(antModel.position.x, 0.5)
    }
}
