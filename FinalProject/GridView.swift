//
//  GridView.swift
//  Assignment4
//
//  Created by Jeffrey Hu on 7/13/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

@IBDesignable
class GridView: UIView {
    
    var grid : GridProtocol = Grid(10 , 10)
    var rows : Int = 10
    var cols : Int = 10
    var thebool = true
    
    @IBInspectable var livingColor : UIColor = UIColor.green
    @IBInspectable var diedColor : UIColor = UIColor.red
    @IBInspectable var emptyColor : UIColor = UIColor.darkGray
    @IBInspectable var bornColor : UIColor = UIColor.cyan
    @IBInspectable var gridColor : UIColor = UIColor.black
    @IBInspectable var gridWidth : CGFloat = 2.0
    
    override func draw(_ rect: CGRect) {
        let horizontalIncrement = bounds.width / CGFloat(cols)
        let verticalIncrement = bounds.height / CGFloat(rows)
        drawEdge(rect)
        drawVerticalLines(rect, verticalIncrement)
        drawHorizontalLines(rect, horizontalIncrement)
        if verticalIncrement > horizontalIncrement {
            drawallcircles(rect, horizontalIncrement, horizontalIncrement, verticalIncrement)
        } else {
                drawallcircles(rect, verticalIncrement, horizontalIncrement, verticalIncrement)
        }
    }
    
    //helper draw function that outlines the grid
    func drawEdge(_ rect: CGRect) {
        let edgepath = UIBezierPath()
        edgepath.lineWidth = gridWidth
        edgepath.move(to: rect.origin)
        edgepath.addLine(to: CGPoint(x: rect.width, y: 0))
        edgepath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        edgepath.addLine(to: CGPoint(x: 0, y: rect.height))
        edgepath.addLine(to: CGPoint(x: 0, y:0))
        gridColor.setStroke()
        edgepath.stroke()
    }
    
    //helper draw function that draws all vertical lines on grid
    func drawVerticalLines(_ rect: CGRect, _ increment: CGFloat){
        var remember = CGFloat(0)
        let vpath = UIBezierPath()
        vpath.lineWidth = gridWidth
        gridColor.setStroke()
        var x = 0
        while x == 0 {
            vpath.move(to: CGPoint(x: remember+increment, y:0))
            vpath.addLine(to: CGPoint(x: remember + increment, y: rect.height))
            vpath.stroke()
            remember = remember + increment
            x = ((remember > (rect.width - increment)) ? 1 : 0)
        }
    }
    
    //helper draw function that draws all horizontal lines on grid
    func drawHorizontalLines(_ rect: CGRect,
                             _ increment: CGFloat){
        var remember = CGFloat(0)
        let hpath = UIBezierPath()
        hpath.lineWidth = gridWidth
        gridColor.setStroke()
        var x = 0
        while x == 0 {
            hpath.move(to: CGPoint(x: 0 , y: remember + increment))
            hpath.addLine(to: CGPoint(x: rect.width, y: remember + increment))
            hpath.stroke()
            remember = remember + increment
            x = ((remember > (rect.width - increment)) ? 1 : 0)
        }
    }
    
    //helper draw function that draws all circles in the grid
    func drawallcircles(_ rect: CGRect,
                        _ increment: CGFloat,
                        _ verticalIncrement: CGFloat,
                        _ horizontalIncrement: CGFloat){
        
        //function that draws a single circle
        
        func drawonecircle (center: CGPoint, row: Int, col: Int) {
            let arcPath = UIBezierPath(arcCenter: center, radius: 2 * increment / 5 , startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi - 0.0005), clockwise: true)
            switch grid[row, col] {
            case .alive:
                livingColor.setStroke()
                livingColor.setFill()
            case .born:
                bornColor.setStroke()
                bornColor.setFill()
            case .died:
                diedColor.setStroke()
                diedColor.setFill()
            case .empty:
                emptyColor.setStroke()
                emptyColor.setFill()
            }
            arcPath.lineWidth = CGFloat(0.005)
            arcPath.stroke()
            arcPath.fill()
        }
        //creates an array that will hold all the CGPoint values that represents the centers of each circle in the grid
        var arrayofcenters = Array(repeating: Array(repeating: CGPoint(x: 0, y:0), count: cols), count: rows)
        for (indexofrow, row) in arrayofcenters.enumerated() {
            for (indexofpoint, _) in row.enumerated() {
                (arrayofcenters[indexofrow])[indexofpoint] =
                    CGPoint(x: CGFloat((indexofrow + 1)) * horizontalIncrement - CGFloat(horizontalIncrement / 2),
                            y: CGFloat((indexofpoint + 1)) * verticalIncrement - CGFloat(verticalIncrement / 2))
                
                drawonecircle(center: arrayofcenters[indexofrow][indexofpoint], row: indexofrow, col: indexofpoint )
            }
        }
    }
    
    typealias coordinate = (x: Int, y: Int)
    var lastTouchedPosition : coordinate?
    
    //converts a touch into a coordinate of (Int, Int)
    func convert(touch: CGPoint) -> coordinate? {
        let touchY = touch.y
        let touchX = touch.x
        var arrayofincrements = Array(repeating: Array(repeating: CGPoint(x: 0, y:0), count: cols), count: rows)
        let horizontalIncrement = bounds.width / CGFloat(rows)
        let verticalIncrement = bounds.height / CGFloat(cols)
        for (index0, row) in arrayofincrements.enumerated() {
            for (index1, _) in row.enumerated() {
                arrayofincrements[index0][index1] = CGPoint(x: CGFloat(index0 + 1) * horizontalIncrement,
                                                            y: CGFloat(index1 + 1) * verticalIncrement)
                let a = (arrayofincrements[index0][index1].x - touchX) > 0 ? true : false
                let b = (arrayofincrements[index0][index1].y - touchY) > 0 ? true : false
                let x = (arrayofincrements[index0][index1].x - touchX) < horizontalIncrement ? true : false
                let y = (arrayofincrements[index0][index1].y - touchY) < verticalIncrement ? true : false
                if (x && y && a && b) {
                    return (x: index0, y: index1)
                }
            }
        }
        return nil
    }
    
    var translationPoint : CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPosition = touches.first?.location(in: self) else {
            return
        }
        translationPoint = touchPosition
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if thebool == false {
            thebool = true
            return
        }
        thebool = true
        guard let touchPosition = touches.first?.location(in: self) else {
            return
        }
        updateTouches(x: touchPosition.x, y: touchPosition.y)
    }
    
    func touching(panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .began:
            panRecognizer.setTranslation(translationPoint!, in: self)
            fallthrough
        case .changed:
            let touch = panRecognizer.translation(in: self)
            guard let currentCoord = convert(touch: touch) else {return}
            guard lastTouchedPosition?.x != currentCoord.x
                || lastTouchedPosition?.y != currentCoord.y
                else { return }
            lastTouchedPosition = convert(touch: touch)
            updateTouches(x: touch.x, y: touch.y)
            thebool = false
        default: break
        }
    }
    
    func updateTouches(x touchX : CGFloat, y touchY : CGFloat) {
        var arrayofincrements = Array(repeating: Array(repeating: CGPoint(x: 0, y:0), count: cols), count: rows)
        let horizontalIncrement = bounds.width / CGFloat(rows)
        let verticalIncrement = bounds.height / CGFloat(cols)
        for (index0, row) in arrayofincrements.enumerated() {
            for (index1, _) in row.enumerated() {
                arrayofincrements[index0][index1] = CGPoint(x: CGFloat(index0 + 1) * horizontalIncrement,
                                                            y: CGFloat(index1 + 1) * verticalIncrement)
                let a = (arrayofincrements[index0][index1].x - touchX) > 0 ? true : false
                let b = (arrayofincrements[index0][index1].y - touchY) > 0 ? true : false
                let x = (arrayofincrements[index0][index1].x - touchX) < horizontalIncrement ? true : false
                let y = (arrayofincrements[index0][index1].y - touchY) < verticalIncrement ? true : false
                let row = index0
                let col = index1
                if (x && y && a && b) {
                    StandardEngine.shared.grid[row, col] = grid[row, col].toggle(value: grid[row, col])
                    setNeedsDisplay()
                }
            }
        }
    }
    
}
