//
//  DrawImage.swift
//  ImageFilter
//
//  Created by Jaroslav Stupinskyi on 14.12.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class DrawingImageView: UIImageView {
    
    var lineColor: UIColor?
    var lineWidth: CGFloat?
    var path = UIBezierPath()
    var touchPoint: CGPoint!
    var startingPoint: CGPoint!
    
    override func layoutSubviews() {
        //Insuring that drawing outside the frame and multiple touches are not possible
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Getting the first touch
        let touch = touches.first
        //Getting the location of starting point in a view
        startingPoint = touch?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        //Drawing a line (path) from starting point to curent touch point
        path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: touchPoint)
        //Updating starting point of line
        startingPoint = touchPoint
        
        //Adding sublayer every time touth is moved
        drawShapeLayer()
    }
    
    //Adding drawing sublayer (shape layer)
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor!.cgColor
        shapeLayer.lineWidth = lineWidth!
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    func clearImage() {
        path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }
}
