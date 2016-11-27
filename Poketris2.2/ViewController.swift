//
//  ViewController.swift
//  PokeTris
//
//  Created by Nacho on 22/9/16.
//  Copyright © 2016 UPM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BoardViewDataSource {
    
    
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var puntuation: UILabel!
    @IBOutlet weak var boardView: BoardView!
    
    var memory: Int = 0
    var timer : Timer?
    
    var board : Board = Board()
    
    var gameInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardView.dataSource = self
        //nextBlockView.dataSource = self
        startNewGame()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startNewGame(){
        board.newGame()
        gameInProgress = true
        moveDown()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft(sender:)))
        swipeLeft.direction = .left
        boardView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight(sender:)))
        swipeRight.direction = .right
        boardView.addGestureRecognizer(swipeRight)
        
        
        let swipeDrop = UILongPressGestureRecognizer(target: self, action: #selector(self.swipeDrop(sender:)))
        boardView.addGestureRecognizer(swipeDrop)
        
    }
    
    func swipeLeft(sender:UISwipeGestureRecognizer) {
        board.moveLeft()
        boardView.setNeedsDisplay()
    }
    
    func swipeRight(sender:UISwipeGestureRecognizer) {
        board.moveRight()
        boardView.setNeedsDisplay()
    }
    
    func swipeDrop(sender:UILongPressGestureRecognizer) {
        board.dropDown()
        boardView.setNeedsDisplay()
    }
    
    func moveDown(){
        
        guard gameInProgress else { return }
        
        board.moveDown(insertNewBlockIfNeeded: true)
        boardView.setNeedsDisplay()
        var interval = 2
        var speed2 = 1
        if Int(puntuation.text!)! >= 10{
            interval = Int(1.5)
            speed2 = 2
        }
        
        if Int(puntuation.text!)! >= 20{
            interval = 1
            speed2 = 3
        }
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(moveDown), userInfo: nil, repeats: false)
        puntuation.text = String(board.puntuacion)
        
        speed.text = String(speed2)
    }
    
    
    @IBAction func moveLeft(_ sender: UIButton) {
        board.moveLeft()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func rotateLeft(_ sender: UIButton) {
        board.rotate(toRight: true)
        boardView.setNeedsDisplay()
    }
    
    @IBAction func dropDown(_ sender: UIButton) {
        board.moveDown()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func rotateRight(_ sender: UIButton) {
        board.rotate(toRight: false)
        boardView.setNeedsDisplay()
    }
    @IBAction func moveRight(_ sender: UIButton) {
        board.moveRight()
        boardView.setNeedsDisplay()
    }
    @IBAction func restart(_ sender: UIButton) {
        if (Int(puntuation.text!)! > Int(record.text!)!) {
            record.text = puntuation.text
        }
        startNewGame()
    }
    
    func gameOver() {
        gameInProgress = false
    }
    
    func rowCompleted(){
        print("ROW COMPLETED")
    }
    
    func numberOfRows(in:BoardView)->Int{
        return board.rowsCount
    }
    
    func numberOfColumns(in:BoardView)->Int{
        return board.columnsCount
    }
    
    var imagesCache = [String:UIImage]()
    
    private func cachedImage(name imageName: String) -> UIImage? {
        
        if let image = imagesCache[imageName] {
            return image
        }
        else if let image = UIImage(named: imageName) {
            
            imagesCache[imageName] = image
            
            return image
        }
        
        return nil
    }
    
    func backgroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage? {
        
        if let texture = board.currentTexture(atRow: row, atColumn: column) {
            let imageName = texture.backgroundImageName()
            return cachedImage(name: imageName)
        }
        return nil
    }
    
    func foregroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage? {
        
        if let texture = board.currentTexture(atRow: row, atColumn: column) {
            let imageName = texture.pokemonImageName()
            return cachedImage(name: imageName)
        }
        return nil
    }
    
}
