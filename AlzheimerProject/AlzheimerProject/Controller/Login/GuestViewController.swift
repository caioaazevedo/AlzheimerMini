//
//  GuestViewController.swift
//  AlzheimerProject
//
//  Created by Eduardo Airton on 03/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class GuestViewController: UIViewController{
    
    @IBOutlet weak var homeButton: CustomButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var textNome: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        
    }
    
    func setUpImage() {
        imageButton.setImage(#imageLiteral(resourceName: "loginPhoto"), for: .normal)
        imageButton.layer.cornerRadius = imageButton.frame.size.height / 2
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        homeButton.pulsate()
    }
    
    @IBAction func imageButtonAction(_ sender: UIButton) {
        
    }
    
    func insertCode(code: String){
        self.textNome.text = code
    }
    
}

