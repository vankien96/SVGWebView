//
//  MarkerView.swift
//  SVGInteraction
//
//  Created by Trương Văn Kiên on 4/22/20.
//  Copyright © 2020 Prefeex. All rights reserved.
//

import UIKit

@IBDesignable
class MarkerView: LoadableFromXibView {
    enum ArrowPosition {
        case top, left, right, bottom
    }
    
    @IBInspectable var lineColor: UIColor = .purple
    @IBInspectable var corner: CGFloat = 5
    @IBInspectable var lineWidth: CGFloat = 2
    @IBInspectable var triangleHeight: CGFloat = 8
    @IBInspectable var triangleWidth: CGFloat = 18
    var arrowPosition: ArrowPosition = .bottom
    
    var path: SVGPath!
    
    override var xibName: String {
        return "MarkerView"
    }
    
    override func draw(_ rect: CGRect) {
        switch arrowPosition {
        case .bottom, .top:
            drawBottomArrow(rect)
        case .left, .right:
            drawLeftArrow(rect)
        }
    }
    
    private func drawBottomArrow(_ rect: CGRect) {
        let halfLineWidth = lineWidth / 2
        let initialPoint = CGPoint(x: rect.width / 2, y: halfLineWidth)
        let path = UIBezierPath()
        
        path.lineWidth = lineWidth
        
        path.move(to: initialPoint)
        path.addLine(to: CGPoint(x: rect.width - corner, y: halfLineWidth))
        path.addArc(withCenter: CGPoint(x: rect.width - corner - halfLineWidth, y: corner + halfLineWidth), radius: corner, startAngle: -.pi/2, endAngle: 0, clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.width - halfLineWidth, y: rect.height - corner - triangleHeight))
        path.addArc(withCenter: CGPoint(x: rect.width - corner - halfLineWidth, y: rect.height - corner - triangleHeight), radius: corner, startAngle: 0, endAngle: .pi/2, clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.width / 2 + triangleWidth / 2, y: rect.height - triangleHeight))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - halfLineWidth))
        path.addLine(to: CGPoint(x: rect.width / 2 - triangleWidth / 2, y: rect.height - triangleHeight))
        
        path.addLine(to: CGPoint(x: corner + halfLineWidth, y: rect.height - triangleHeight))
        path.addArc(withCenter: CGPoint(x: corner + halfLineWidth, y: rect.height - corner - triangleHeight), radius: corner, startAngle: .pi/2, endAngle: .pi, clockwise: true)
        
        path.addLine(to: CGPoint(x: halfLineWidth, y: corner))
        path.addArc(withCenter: CGPoint(x: corner + halfLineWidth, y: corner + halfLineWidth), radius: corner, startAngle: .pi, endAngle: -.pi/2, clockwise: true)
        if arrowPosition == .top {
            flipPathHorizontally(path, in: rect)
        }
        path.close()
        lineColor.setStroke()
        path.stroke()
        UIColor.white.setFill()
        
        path.fill()
        
    }
    
    private func drawLeftArrow(_ rect: CGRect) {
        let halfLineWidth = lineWidth / 2
        let initialPoint = CGPoint(x: rect.width / 2, y: halfLineWidth)
        let path = UIBezierPath()
        
        path.lineWidth = lineWidth
        
        path.move(to: initialPoint)
        path.addLine(to: CGPoint(x: rect.width - corner, y: halfLineWidth))
        path.addArc(withCenter: CGPoint(x: rect.width - corner - halfLineWidth, y: corner + halfLineWidth), radius: corner, startAngle: -.pi/2, endAngle: 0, clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.width - halfLineWidth, y: rect.height - corner - halfLineWidth))
        path.addArc(withCenter: CGPoint(x: rect.width - corner - halfLineWidth, y: rect.height - corner - halfLineWidth), radius: corner, startAngle: 0, endAngle: .pi/2, clockwise: true)
        
        path.addLine(to: CGPoint(x: corner + triangleHeight, y: rect.height - halfLineWidth))
        path.addArc(withCenter: CGPoint(x: corner + halfLineWidth + triangleHeight, y: rect.height - corner - halfLineWidth), radius: corner, startAngle: .pi/2, endAngle: .pi, clockwise: true)
        
        path.addLine(to: CGPoint(x: halfLineWidth + triangleHeight, y: rect.height / 2 + triangleWidth / 2))
        
        path.addLine(to: CGPoint(x: halfLineWidth, y: rect.height / 2))
        path.addLine(to: CGPoint(x: halfLineWidth + triangleHeight, y: rect.height / 2 - triangleWidth / 2))
        path.addLine(to: CGPoint(x: halfLineWidth + triangleHeight, y: corner + halfLineWidth))
        
        path.addArc(withCenter: CGPoint(x: corner + halfLineWidth + triangleHeight, y: corner + halfLineWidth), radius: corner, startAngle: .pi, endAngle: -.pi/2, clockwise: true)
        if arrowPosition == .right {
            flipPathVerizontally(path, in: rect)
        }
        path.close()
        lineColor.setStroke()
        path.stroke()
        UIColor.white.setFill()
        path.fill()
        
    }
    
    private func flipPathHorizontally(_ path: UIBezierPath, in rect: CGRect) {
        let mirror = CGAffineTransform(scaleX: 1,
                                          y: -1)
        let translate = CGAffineTransform(translationX: 0,
                                          y: rect.size.height)
        let concatenated = mirror.concatenating(translate)

        path.apply(concatenated)
    }
    
    private func flipPathVerizontally(_ path: UIBezierPath, in rect: CGRect) {
        let mirror = CGAffineTransform(scaleX: -1,
                                          y: 1)
        let translate = CGAffineTransform(translationX: rect.size.width,
                                          y: 0)
        let concatenated = mirror.concatenating(translate)

        path.apply(concatenated)
    }
    
    func adjustDisplayPoint(point: CGPoint) -> CGPoint {
        var x,y: CGFloat
        switch arrowPosition {
        case .bottom:
            x = point.x - frame.width / 2
            y = point.y - frame.height
        case .top:
            x = point.x - frame.width / 2
            y = point.y
        case .left:
            x = point.x
            y = point.y - frame.height / 2
        case .right:
            x = point.x - frame.width
            y = point.y - frame.height / 2
        }
        return CGPoint(x: x, y: y)
        
    }
}
