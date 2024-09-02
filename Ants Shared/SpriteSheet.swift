//
//  SpriteSheet.swift
//  Ants
//
//  Created by Doug Whitmore on 9/1/24.
//

import SpriteKit
import OSLog

/// Manages loading textures from a Sprite Sheet. Pass in a texture along with a count of rows and columns.
class SpriteSheet {
    // TODO: Someday add a "file format" for a SpriteSheet that takes a sprite sheet, rows and columns, and maybe animation timings... or a way to tag particular areas (e.g. Row 2, column 5-10 is the death animation)
    let texture: SKTexture
    let rows: Int
    let columns: Int
    var margin: CGFloat = 0
    var spacing: CGFloat = 0
    var frameSize: CGSize {
        CGSize(width: frameWidth, height: frameHeight)
    }
    private var frameWidth: CGFloat {
        (self.texture.size().width - ((self.margin * 2) + self.spacing * (CGFloat(self.columns - 1)))) / CGFloat(self.columns)
    }
    private var frameHeight: CGFloat {
        (self.texture.size().height - ((self.margin * 2) + self.spacing * CGFloat(self.rows - 1))) / CGFloat(self.rows)
    }
    
    init(texture: SKTexture, rows: Int, columns: Int, spacing: CGFloat, margin: CGFloat) {
        self.texture=texture
        self.rows=rows
        self.columns=columns
        self.spacing=spacing
        self.margin=margin
        
        setupFrames()
    }
        
    convenience init(texture: SKTexture, rows: Int, columns: Int) {
        self.init(texture: texture, rows: rows, columns: columns, spacing: 0, margin: 0)
    }
    
    /// Use if you want to arrange frames yourself
    func texture(forColumn column: Int, row: Int) -> SKTexture? {
        guard column < columns, row < rows else {
            // Should this throw? This should be an error
            return nil
        }
        let imageX = margin + CGFloat(column) * (frameWidth + spacing) - spacing
        let imageY = margin + CGFloat(row) * (frameHeight + spacing) - spacing
        
        let textureRect = texture.textureRect()
        let originalTextureSize = texture.size()
        let widthFactor =  textureRect.size.width / originalTextureSize.width
        let heightFactor = textureRect.size.height / originalTextureSize.height
        
        let normalizedOrigin = CGPoint(x: imageX * widthFactor, y: imageY * heightFactor)
        let normalizedSize = CGSize(width: frameWidth * widthFactor, height: frameHeight * heightFactor)
        
        let normalizedRect = CGRect(origin: normalizedOrigin, size: normalizedSize)
        
        return SKTexture(rect: normalizedRect, in: texture)
    }
    
    /// Gets all frames in sheet in order
    var frames: [SKTexture] = []
    private func setupFrames() {
        frames = []
        for aRow in 0..<rows {
            for aColumn in 0..<columns {
                if let texture = texture(forColumn: aColumn, row: aRow) {
                    frames.append(texture)
                    logger.info("Got a texture!")
                } else {
                    logger.error("Something messed up and we didn't get a texture")
                }
            }
        }
    }
}

private let logger = Logger(subsystem: "org.gooddoug.Ants", category: "SpriteSheet")
