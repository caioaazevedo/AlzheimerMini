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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Cloud.checkUsuario(searchUsuario: UserLoaded().recuperarId()) { (result) in
            if result {
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "inicialStoryboard")
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
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
            destination.realHost = true
        }
    }

    
}
