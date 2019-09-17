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
    var imagePicker : ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self as ImagePickerDelegate)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let a = cdr.loadUserData()
        nome.text = a.nome
        
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = false
            vc.tabBar.frame = CGRect(x: 500, y: 500, width: 0, height: 0)
            vc.viewDidLayoutSubviews()
            vc.self.selectedIndex = 2
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        cdr.updateUser(nome: nome.text ?? "", fotoPerfil: profilePhoto.image!)
    }
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBAction func cameraButton(_ sender: UIButton) {
        self.imagePicker.present(from: sender as UIView)
    }
    
    
    @IBOutlet weak var nome: UITextField!
    
    
    
    
}

extension MyProfileViewController: ImagePickerDelegate{
    
    
    
    func didSelect(imagem: UIImage?){
        self.profilePhoto.image = imagem
    }
}
