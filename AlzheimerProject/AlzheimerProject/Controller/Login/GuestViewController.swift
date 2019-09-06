//
//  GuestViewController.swift
//  AlzheimerProject
//
//  Created by Eduardo Airton on 03/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class GuestViewController: UIViewController{
    var isHost = false
    var realHost = false
    @IBOutlet weak var familyCode: UITextField!
    
    @IBOutlet weak var homeButton: CustomButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var textNome: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isHost {
            setUpImage()
            userName.setBottomBorder()
            userEmail.setBottomBorder()
        }else {
            familyCode.setBottomBorder()
        }
    }

    
    func setUpImage() {
        imageButton.layer.cornerRadius = imageButton.frame.size.height / 2
        imageButton.clipsToBounds = true
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        homeButton.pulsate()
        
        if realHost {
            CoreDataRebased.shared.createUsuario(email: userEmail.text!, fotoDoPerfil: UIImage(named: "Remedio"), Nome: textNome.text!)
            CoreDataRebased.shared.createSala()
        } else {
            CoreDataRebased.shared.createUsuarioGuest(email: userEmail.text!, fotoDoPerfil: UIImage(named: "Remedio"), Nome: textNome.text!, searchSala: familyCode.text!)
        }
    }
    
    @IBAction func imageButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func VerifyFamilyCode(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "host2" {
            let destination = segue.destination as! GuestViewController
            destination.isHost = true
        }
    }
    
    func insertCode(code: String){
        self.familyCode.text = code
    }
    
}

extension UITextField {
    
    func setBottomBorder() {
        self.layer.shadowColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


