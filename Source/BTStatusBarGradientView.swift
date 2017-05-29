//
//  BTStatusBarGradientView.swift
//  BTStatusBar
//
//  Created by Blake Tsuzaki on 5/28/17.
//  Copyright © 2017 Modoki. All rights reserved.
//

import UIKit

class BTStatusBarGradientView: UIView {
    var isAnimating: Bool = false
    var progress: CGFloat = 0 {
        didSet {
            if progress > 1 { progress = 1 }
            else {
                setNeedsLayout()
            }
        }
    }
    internal let resolution = 100
    private var colors: [CGColor] = [CGColor]()
    private var shiftedColors: [CGColor] {
        var newColors = [CGColor](colors)
        let lastColor = newColors.removeFirst()
        newColors.append(lastColor)
        
        return newColors
    }
    internal var maskLayer = CALayer()
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    init() {
        super.init(frame: CGRect())
        
        if let layer = layer as? CAGradientLayer {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
            for idx in 0...resolution {
                let val = CGFloat(idx)
                let variance = CGFloat(resolution)
                let saturation = abs(val/(variance/2)-1)*0.15+0.5
                colors.append(UIColor(hue: saturation, saturation: 1, brightness: 1, alpha: 1).cgColor)
            }
            
            layer.colors = colors
            
            maskLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width*progress, height: frame.size.height)
            maskLayer.backgroundColor = UIColor.black.cgColor
            layer.mask = maskLayer
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        maskLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width*progress, height: frame.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func beginAnimations() {
        if !isAnimating {
            isAnimating = true
            animationRunLoop()
        }
    }
    
    func endAnimations() {
        if isAnimating {
            isAnimating = false
        }
    }
    
    internal func animationRunLoop() {
        if let layer = layer as? CAGradientLayer {
            let fromColors = colors
            let toColors = shiftedColors
            layer.colors = Array(toColors.prefix(upTo: toColors.count/2))
            colors = shiftedColors
            
            let animation = CABasicAnimation(keyPath: "colors")
            animation.fromValue = fromColors
            animation.toValue = toColors
            animation.duration = 0.01
            animation.isRemovedOnCompletion = true
            animation.fillMode = kCAFillModeForwards
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.delegate = self
            
            layer.add(animation, forKey: "animateGradient")
        }
    }
}
extension BTStatusBarGradientView: CAAnimationDelegate {
    func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        if isAnimating {
            animationRunLoop()
        }
    }
}
