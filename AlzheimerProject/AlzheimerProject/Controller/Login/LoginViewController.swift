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

    }
    
    @IBAction func hostButtonAction(_ sender: Any) {
        recuperarId()
        hostButton.pulsate()
        
    }
    
    @IBAction func guestButtonAction(_ sender: Any) {
        recuperarId()
        guestButton.pulsate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "host" {
            let destination = segue.destination as! GuestViewController
            destination.isHost = true
            destination.realHost = true
        }
    }
    
    func recuperarId(){
        //Verifica se está logado no icloud
        if FileManager.default.ubiquityIdentityToken == nil {
            
            
        print("iCloud Unavailable")
        
        //Pede que o usuário abra as configurações para que faça o login no icloud
        func openSettings(alert: UIAlertAction!) {
            if let url = URL.init(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
            
            let alert = UIAlertController(title: NSLocalizedString("icloudLogin", comment: ""),
                                          message: NSLocalizedString("descLogin", comment: ""),
                                                preferredStyle: .alert)
                  
                  alert.addAction(UIAlertAction(title: "Open Settings",
                                                style: UIAlertAction.Style.default,
                                                handler: openSettings))
                  alert.addAction(UIAlertAction(title: "Cancel",
                                                style: UIAlertAction.Style.destructive,
                                                handler: nil))
                  self.present(alert, animated: true, completion: nil)
        
        
      
        //Passar a viewController que deve ser apresentada
        }
    }

    
}
