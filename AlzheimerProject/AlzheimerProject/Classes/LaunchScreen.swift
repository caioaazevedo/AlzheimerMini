//
//  LaunchScreen.swift
//  AlzheimerProject
//
//  Created by Eduardo Airton on 19/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class LaunchScreen: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.alpha = 0
        
        UIView.animate(withDuration: 1, animations: {
            self.imageView.alpha = 1.0
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                self.imageView.alpha = 0.0
            }, completion: { (true) in
                Cloud.checkUsuario(searchUsuario: UserLoaded().recuperarId()) { (result) in
                    if result {
                        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "inicialStoryboard")
                        self.present(viewController, animated: true, completion: nil)
                    }else {
                        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MainApp")
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
                
            })
            
        }
        
    }
    

    

    
}
