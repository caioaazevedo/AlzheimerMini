//
//  DetailProfileViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import CircleBar

class DetailProfileViewController: UIViewController {
    
    var editPressed = false
    var cdr = CoreDataRebased.shared
    
    
    var nascimento = ""
    var rg = ""
    var tipoSanguineo = ""
    var Alergia = ""
    var endereco = ""
    var telefone = ""
    var medicamento = ""
    var plano = ""
    var observacoes = ""
    var arrayAux = [String]()
    var arrayFetch = [String]()
    
    @IBOutlet weak var idosoNome: UITextField!
    
    @IBOutlet weak var fotoIdoso: UIImageView!
    
    @IBOutlet weak var tableVelho: UITableView!
    
    @IBOutlet weak var editOutlet: UIBarButtonItem!
    
    var imagePicker: ImagePicker!
    var a = profileData()
    
    var tableController : TabElderViewController {
        return self.children.first as! TabElderViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.idosoNome.setBottomBorder()
        
        arrayAux = [nascimento,rg,tipoSanguineo,Alergia,endereco,telefone,medicamento,plano,observacoes]
        setAll()
//        tableController.tableView.delegate = self
  
//        self.fotoIdoso.image = UIImage(named: "Borda")
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self as ImagePickerDelegate)
        //        self.setUpView()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //    func setDynamicType(){
    //        let fontName = "SFProText-Regular"
    //
    //        let scaledFont: ScaledFont = {
    //            return ScaledFont(fontName: fontName)
    //        }()
    //
    //
    //
    //
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserLoaded()
        //        setAll()

        
        
        
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = true
            vc.tabBar.frame = CGRect(x: 500, y: 500, width: 0, height: 0)
            vc.viewDidLayoutSubviews()
            vc.self.selectedIndex = 2
            
            
        }
        //        setDynamicType()
    }
    
    func setUpView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 40
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
    
    @IBAction func mudarFoto(_ sender: UIButton) {
        self.imagePicker.present(from: sender as UIView)
    }
    
    
    
    
    
    
    
    
    func setAll(){
        
        a = cdr.loadProfileData()
        let day = Calendar.current.component(.day, from: a.dataDeNascimento ?? Date(timeIntervalSinceNow: 0) )
        let month = Calendar.current.component(.month, from: a.dataDeNascimento ?? Date(timeIntervalSinceNow: 0) )
        let year = Calendar.current.component(.year, from: a.dataDeNascimento ?? Date(timeIntervalSinceNow: 0) )
        
        if flag == 0{
            fotoIdoso.image = a.fotoDePerfil
        } else{
            fotoIdoso.image = fotoIdosoAux
        }
        if idosoNome.text == nil || idosoNome.text == "" {
            idosoNome.text = "Elder Name"
        }
        else {
            idosoNome.text = a.nome
        }

        
        tableController.alergia.text = a.alergias
        tableController.dataNasc.text = "\(day)/\(month)/\(year)"
        tableController.endereco.text = a.endereco
        tableController.medicamento.text = a.remedios
        tableController.observacoes.text = a.Descricao
        tableController.plano.text = a.planoDeSaude
        tableController.RG.text = a.rg
        tableController.telefone.text = a.telefone
        tableController.tipo.text = a.tipoSanguineo
        
        // fotoIdoso.image = fotoIdosoAux
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        cdr.updateProfile(alergias:  tableController.alergia.text ?? "empty", dataDeNascimento: Date(), descricao: tableController.observacoes.text ?? "empty", endereco: tableController.endereco.text ?? "empty", fotoDePerfil: fotoIdoso.image, nome: idosoNome.text ?? "empty", planoDeSaude: tableController.plano.text ?? "empty", remedios: tableController.medicamento.text ?? "empty", telefone: tableController.telefone.text ?? "empty", tipoSanguineo: tableController.plano.text ?? "empty", rg:  tableController.RG.text ?? "empty")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @IBAction func editbutton(_ sender: UIBarButtonItem) {
        arrayAux = [nascimento,rg,tipoSanguineo,Alergia,endereco,telefone,medicamento,plano,observacoes]
        
        Alergia = arrayAux[3]
        nascimento = arrayAux[0]
        observacoes = arrayAux[8]
        rg = arrayAux[1]
        endereco = arrayAux[4]
        plano = arrayAux[7]
        medicamento = arrayAux[6]
        telefone = arrayAux[5]
        tipoSanguineo = arrayAux[2]
        
        
        editOutlet.title = NSLocalizedString("Save", comment: "")
        
        
        
        
    }
    
    
    var fotoIdosoAux = UIImage(named: "Borda")
    var flag = 0
    
    

    
    var selecionado = Int()
}


extension DetailProfileViewController: ImagePickerDelegate{
    
    func didSelect(imagem: UIImage?) {
        self.fotoIdoso.image = imagem
        fotoIdosoAux = imagem
        flag = 1
        
    }
    
}

