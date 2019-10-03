//
//  Onboard.swift
//  AlzheimerProject
//
//  Created by Eduardo Airton on 16/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import paper_onboarding

class Onboard: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate{
    

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var colorView: OnbordingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startButton.alpha = 0
        colorView.dataSource = self
        colorView.delegate = self

        startButton.layer.cornerRadius = 10
        startButton.clipsToBounds = true
    }
    
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Bold", size: 17)!

        
        return [
            OnboardingItemInfo(informationImage: UIImage(named: "Camada 2")!, title: NSLocalizedString("boardtitle", comment: ""), description: NSLocalizedString("onboard1", comment: ""), pageIcon: UIImage(named: "n1")!, color: colorWithGradient(colors: [#colorLiteral(red: 0.9294117647, green: 0.462745098, blue: 0.368627451, alpha: 1),#colorLiteral(red: 0.937254902, green: 0.6588235294, blue: 0.3450980392, alpha: 1)]), titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: UIImage(named: "Onboarding_Calendar")!, title: NSLocalizedString("boardevent", comment: ""), description:NSLocalizedString("onboard2", comment:""), pageIcon: UIImage(named: "n2")!, color: colorWithGradient(colors: [#colorLiteral(red: 0.9294117647, green: 0.462745098, blue: 0.368627451, alpha: 1),#colorLiteral(red: 0.937254902, green: 0.6588235294, blue: 0.3450980392, alpha: 1)]), titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: UIImage(named: "Dados do Idoso")!, title: NSLocalizedString("boardInfo", comment: ""), description: NSLocalizedString("onboard3", comment: ""), pageIcon: UIImage(named: "n3")!, color: colorWithGradient(colors: [#colorLiteral(red: 0.9294117647, green: 0.462745098, blue: 0.368627451, alpha: 1),#colorLiteral(red: 0.937254902, green: 0.6588235294, blue: 0.3450980392, alpha: 1)]), titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
        ][index]
        
        
    }
    
    //     Crie um gropo
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func colorWithGradient(colors: [UIColor]) -> UIColor {

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.locations = [0.1, 0.9]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        let cgColors = colors.map({$0.cgColor})

        gradientLayer.colors = cgColors

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return UIColor(patternImage: backgroundColorImage!)
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            
            if self.startButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.startButton.alpha = 0
                })
            }
            
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            UIView.animate(withDuration: 0.4, animations: {
                self.startButton.alpha = 1
            })
        }
    }
    
    @IBAction func startButtonAction(_ sender: Any) {

    }
    
    
}
