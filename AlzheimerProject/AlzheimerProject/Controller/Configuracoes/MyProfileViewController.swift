//
//  MyProfileViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import CircleBar

class MyProfileViewController: UIViewController {
    let cdr = CoreDataRebased.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let a = cdr.loadUserData()
        nome.text = a.nome
        
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = true
            vc.tabBar.frame = CGRect(x: 500, y: 500, width: 0, height: 0)
            vc.viewDidLayoutSubviews()
            vc.self.selectedIndex = 2
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        cdr.updateUser(nome: nome.text ?? "", fotoPerfil: profilePhoto.image!)
    }
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    
    @IBOutlet weak var nome: UITextField!
    
    
    
    
}
