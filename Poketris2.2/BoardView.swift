//
//  BoardView.swift
//  PokeTris
//
//  Created by Nacho on 21/10/16.
//  Copyright © 2016 UPM. All rights reserved.
//

import UIKit

protocol  BoardViewDataSource:class {
    
    func numberOfRows(in: BoardView)->Int
    func numberOfColumns(in: BoardView) -> Int
    func backgroundImageName(in: BoardView, atRow row: Int, atColumn column: Int) -> UIImage?
    func foregroundImageName(in: BoardView, atRow row: Int, atColumn column: Int) -> UIImage?
    
}

@IBDesignable
class BoardView: UIView {
    
    weak var dataSource : BoardViewDataSource!
    
    @IBInspectable
    var bgColor : UIColor! = UIColor.yellow
    
    var boxSize : CGFloat!
    
    override func draw(_ rect: CGRect) {
        
        updateBoxSize()
        drawBackground()
        drawBlocks()
        
    }
    
    private func drawBackground() {
        
        let rows = dataSource.numberOfRows(in: self)
        let columns = dataSource.numberOfColumns(in: self)
        
        let canvasX = box2Point(0)
        let canvasY = box2Point(0)
        let canvasWidth = box2Point(columns)
        let canvasHeight = box2Point(rows)
        let path = UIBezierPath(rect: CGRect(x: canvasX, y: canvasY, width: canvasWidth, height: canvasHeight))
        
        bgColor.setFill()
        path.fill()
        
    }
    
    private func drawBlocks() {
        let rows = dataSource.numberOfRows(in:self)
        let columns = dataSource.numberOfColumns(in:self)
        
        for r in 0..<rows{
            for c in 0..<columns{
                drawBox(row:r, column:c)
            }
        }
    }
    
    private func drawBox(row: Int, column: Int){
        let x = box2Point(column)
        let y = box2Point(row)
        let width = box2Point(1)
        let height = box2Point(1)
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        if let bgImg = dataSource.backgroundImageName(in:self, atRow: row, atColumn: column){
            bgImg.draw(in:rect)
        }
        
        if let fgImg = dataSource.foregroundImageName(in:self, atRow: row, atColumn: column){
            fgImg.draw(in:rect)
        }
    }
    
    private func updateBoxSize() {
        let rows = dataSource.numberOfRows(in:self)
        let columns = dataSource.numberOfColumns(in:self)
        let width = bounds.size.width
        let height = bounds.size.height
        
        let boxWidth = width / CGFloat(columns)
        let boxHeight = height / CGFloat(rows)
        
        boxSize = min(boxWidth,boxHeight)
    }
    
    
    private func box2Point(_ box : Int) -> CGFloat {
        return CGFloat(box) * boxSize
    }
    
}
