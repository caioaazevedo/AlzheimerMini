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
    var activeField: UITextField?
    var currentVC: UIViewController!
    static let shared = GuestViewController()
    var imagePickedBlock: ((UIImage) -> Void)?
    
    @IBOutlet weak var familyCode: UITextField!
    
    @IBOutlet weak var homeButton: CustomButton!
    @IBOutlet weak var imageButton: UIButton!
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
            let tap = UITapGestureRecognizer(target: self, action: #selector(PerfilViewController.moreInfo(_:)))
            imageButton.addGestureRecognizer(tap)
        }else {
            familyCode.setBottomBorder()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpView() {
        self.activeField = UITextField()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }


    func setUpImage() {
        imageButton.layer.cornerRadius = imageButton.frame.size.height / 2
        imageButton.clipsToBounds = true
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
    

    
    @IBAction func imageButtonAction(_ sender: UITapGestureRecognizer? = nil) {
        
        presentOption(vc: self)
        

        GuestViewController.shared.imagePickedBlock = { (image) in
            self.imageButton.setImage(image, for: .normal)
        }

    }

    func camera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
    }

    func galeria(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    }

    func presentOption(vc: UIViewController) {

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))

        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.galeria()
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        vc.present(actionSheet, animated: true, completion: nil)
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

extension GuestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
            
        }else{
            print("Something went wrong")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
}
