//
//  ProgressCircle.swift
//  Punch
//
//  Created by Russell Weber on 2019-07-02.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit

class ProgressCircle: CAShapeLayer {
    
    let shapeLayer = CAShapeLayer()
    
    override init(layer: Any) {
        super.init(layer: layer)
        print("layer init")
    }
    
    init(center: CGPoint) {
        super.init()
        print("center init")
        let bezierPath = UIBezierPath(arcCenter: center, radius: 85, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        path = bezierPath.cgPath
        strokeColor = UIColor.lightGray.cgColor
        lineWidth = 10
        fillColor = UIColor.clear.cgColor
        lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = CustomColors.orange.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        addSublayer(shapeLayer)
    }
    
    func animate(to progress: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = progress
        animation.duration = 1
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "urSoBasic")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
