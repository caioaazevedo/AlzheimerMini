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
    
    var imagePicker: ImagePicker!

    @IBOutlet weak var familyCode: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var homeButton: CustomButton!
    
//    @IBOutlet weak var textNome: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var familyName: UITextField!
    
    var codFamily = String()
    var familyExists = false
    var imageProfile = UIImage(named: "ProfilePicture")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
        if isHost {
            if realHost == false {
                familyName.isHidden = true
            }else{
                familyName.setBottomBorder()
            }
            
            setUpImage()
            userName.setBottomBorder()
        }else {
            familyCode.setBottomBorder()
        }
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self as ImagePickerDelegate)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }


    func setUpImage() {
        imageButton.layer.cornerRadius = imageButton.frame.size.height / 2
        imageButton.clipsToBounds = true
    }
    
    @IBAction func fotoPerfil(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    @IBAction func homeButton(_ sender: Any) {
        homeButton.pulsate()
// && familyName.text != ""
        if userName.text != ""{
            if realHost {
                // Para Usuarios com valor host = 1 - Indicam que são Administradores
                CoreDataRebased.shared.createUsuario(fotoDoPerfil: self.imageProfile, Nome: userName.text!, host: 1)
                CoreDataRebased.shared.createSala(nomeFamilia: familyName.text!)
                
            } else {
                // Para Usuarios com valor host = 0 - Indicam que são Administradores
                CoreDataRebased.shared.createUsuarioGuest(fotoDoPerfil: self.imageProfile, Nome: userName.text!, searchSala: self.codFamily, host: 0)
                
            }
        } else {
            let alert = UIAlertController(title: "Fields are empty", message: "You cannot advance while fields are empty.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func enterCode(_ sender: Any) {
        self.verifyFamilyCode()
//        self.performSegue(withIdentifier: "sugueCadastro", sender: nil)
    }
    
    func verifyFamilyCode() {
        self.codFamily = self.familyCode.text!
        DadosSala.sala.idSala = ""
        Cloud.querySala(searchRecord: codFamily, completion: {(result) in
            if result {
                self.performSegue(withIdentifier: "sugueCadastro", sender: nil)
                
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Code doesn't exists", comment: ""), message: NSLocalizedString("AlertCodeMenssage", comment: ""), preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sugueCadastro"{
            let destination = segue.destination as! GuestViewController
            destination.isHost = true
            destination.codFamily = familyCode.text!
        }
    }
    
    func insertCode(code: String){
        self.familyCode.text = code
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 200
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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

extension GuestViewController: ImagePickerDelegate {
    
    func didSelect(imagem: UIImage?) {
        self.imageButton.setBackgroundImage(imagem, for: .normal)
        guard let img = imagem else { return }
        self.imageProfile = img
    }
    
}

