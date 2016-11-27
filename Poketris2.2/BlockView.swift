//
//  BlockView.swift
//  PokeTris
//
//  Created by Nacho on 21/10/16.
//  Copyright © 2016 UPM. All rights reserved.
//

import UIKit
protocol  BlockViewDataSource:class {
    
    func blockWidth(for: BlockView)->Int
    func blockHeight(for: BlockView)->Int
    func backgroundImageName(in: BlockView, atRow row: Int, atColumn column: Int) -> UIImage?
    func foregroundImageName(in: BlockView, atRow row: Int, atColumn column: Int) -> UIImage?
    
    func texture(of:BlockView) -> Texture
}


@IBDesignable
class BlockView: UIView {
    
    weak var dataSource: BlockViewDataSource!
    
    var imagesCache = [String:UIImage]()
    
    var boxSize : Int = 10
    
    override func draw(_ rect: CGRect) {
        drawBlock()
    }
    
    //Pinta el bloque siguiente
    private func drawBlock(){
        
        let width = dataSource.blockWidth(for:self)
        let height = dataSource.blockHeight(for:self)
        
        for r in 0..<height{
            for c in 0..<width{
                drawBox(row:r, column:c)
            }
        }
        
    }
    
    private func drawBox(row: Int, column: Int) {
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
    
    private func box2Point(_ box : Int) -> CGFloat {
        return CGFloat(box) * CGFloat(boxSize)
        
    }
    
}
