//
//  CustomButton.swift
//  AlzheimerProject
//
//  Created by Eduardo Airton on 03/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpButton()

    }
    
    func setUpButton() {
        setShadow()
    
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: "SF-Pro-Display-Semibold", size: 20)
        layer.cornerRadius = 10
        
        setGradient(colorOne: #colorLiteral(red: 0.9568627451, green: 0.5568627451, blue: 0.1058823529, alpha: 1), colorTwo: #colorLiteral(red: 0.9490196078, green: 0.7137254902, blue: 0.4549019608, alpha: 1))
    }
    
    
    func setShadow() {
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    func setGradient(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.1, 0.9]
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        clipsToBounds = true
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    
    
    func shakeButton() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 8, y: center.y)
        let fromValeu = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 8, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValeu
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
    
}

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

