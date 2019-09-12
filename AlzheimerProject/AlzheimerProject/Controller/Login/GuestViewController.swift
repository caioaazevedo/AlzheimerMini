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
//        imageButton.layer.cornerRadius = imageButton.frame.size.height / 2
//        imageButton.clipsToBounds = true
    }
    
    @IBAction func fotoPerfil(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    @IBAction func homeButton(_ sender: Any) {
        homeButton.pulsate()
        
        if realHost {
            CoreDataRebased.shared.createUsuario(fotoDoPerfil: UIImage(named: "Remedio"), Nome: userName.text!)
            CoreDataRebased.shared.createSala(nomeFamilia: familyName.text!)
        } else {
            CoreDataRebased.shared.createUsuarioGuest(fotoDoPerfil: UIImage(named: "Remedio"), Nome: userName.text!, searchSala: self.codFamily)
        }
    }
    
    @IBAction func enterCode(_ sender: Any) {
        //self.verifyFamilyCode()
        self.performSegue(withIdentifier: "sugueCadastro", sender: nil)
    }
    
    func verifyFamilyCode() {
        self.codFamily = self.familyCode.text!
        DadosSala.sala.idSala = ""
        Cloud.querySala(searchRecord: codFamily, completion: {(result) in
            if result {
                self.performSegue(withIdentifier: "sugueCadastro", sender: nil)
                
            } else {
                let alert = UIAlertController(title: "Code doesn't exists", message: "The code that yoou try to search doesn't exists.", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
                
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
    }
    
}

//class ViewController: UIViewController {
//    
//    @IBOutlet var imageView: UIImageView!
//
//    var imagePicker: ImagePicker!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
//    }
//
//    @IBAction func showImagePicker(_ sender: UIButton) {
//        self.imagePicker.present(from: sender)
//    }
//}
//
//extension ViewController: ImagePickerDelegate {
//
//    func didSelect(image: UIImage?) {
//        self.imageView.image = image
//    }
//}

