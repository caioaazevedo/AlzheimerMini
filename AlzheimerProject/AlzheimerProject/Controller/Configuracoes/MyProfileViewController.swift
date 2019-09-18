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
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var nomeText: UILabel!
    
    let user = CoreDataRebased.shared.fetchUsuario()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageProfile.image = UIImage(data: user.fotoPerfil! as Data)
        
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.height/2
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self as ImagePickerDelegate)
        
        let fontName = "SFProText-Regular"
        
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        nomeText.font = scaledFont.font(forTextStyle: .body)
        nomeText.adjustsFontForContentSizeCategory = true
        nome.font = scaledFont.font(forTextStyle: .body)
        nome.adjustsFontForContentSizeCategory = true
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
        cdr.updateUser(nome: nome.text ?? "", fotoPerfil: self.imageProfile.image!)
        Cloud.updateUsuario(searchRecord: user.id!, nome: nome.text ?? "", foto: (self.imageProfile.image!).jpegData(compressionQuality: 0.2), idSala: user.idSala!)
    }
    
    @IBAction func cameraButton(_ sender: UIButton) {
        self.imagePicker.present(from: sender as UIView)
    }
    
    
    @IBOutlet weak var nome: UITextField!
    
}

extension MyProfileViewController: ImagePickerDelegate{
    
    
    
    func didSelect(imagem: UIImage?){
        self.imageProfile.image = imagem
    }
}
