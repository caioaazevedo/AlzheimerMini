//
//  LoginViewController.swift
//  AlzheimerProject
//
//  Created by Eduardo Airton on 03/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var hostButton: CustomButton!
    @IBOutlet weak var guestButton: CustomButton!
    
    @IBAction func hostButtonAction(_ sender: Any) {
        hostButton.pulsate()
        
    }
    
    @IBAction func guestButtonAction(_ sender: Any) {
        guestButton.pulsate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "host" {
            let destination = segue.destination as! GuestViewController
            destination.isHost = true
        }
    }

    
}
