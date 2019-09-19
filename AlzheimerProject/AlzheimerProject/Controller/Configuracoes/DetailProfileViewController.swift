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
    
    

    @IBOutlet weak var nascimentoGray: UILabel!
    @IBOutlet weak var tgGray: UILabel!
    @IBOutlet weak var alergiasGray: UILabel!
    @IBOutlet weak var enderecoGray: UILabel!
    @IBOutlet weak var medicamentoGray: UILabel!
    @IBOutlet weak var obsGray: UILabel!
    @IBOutlet weak var tipoSanguineoGray: UILabel!
    @IBOutlet weak var telefoneGray: UILabel!
    @IBOutlet weak var planoGray: UILabel!
    
    
    @IBOutlet weak var fotoIdoso: UIImageView!
    @IBOutlet weak var idosoNome: UITextField!
    @IBOutlet weak var dataNascimento: UITextField!
    @IBOutlet weak var tipoSanguineo: UITextField!
    @IBOutlet weak var rg: UITextField!
    @IBOutlet weak var telefone: UITextField!
    @IBOutlet weak var alergias: UITextField!
    @IBOutlet weak var plano: UITextField!
    
    @IBOutlet weak var endereco: UITextField!
    @IBOutlet weak var medicacoes: UITextField!
    @IBOutlet weak var observacoes: UITextField!
    
    @IBOutlet weak var editOutlet: UIBarButtonItem!
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self as ImagePickerDelegate)
        self.setUpView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setDynamicType(){
        let fontName = "SFProText-Regular"
        
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        idosoNome.font = scaledFont.font(forTextStyle: .body)
        idosoNome.adjustsFontForContentSizeCategory = true
        
        nascimentoGray.font = scaledFont.font(forTextStyle: .body)
        nascimentoGray.adjustsFontForContentSizeCategory = true
        
        tipoSanguineoGray.font = scaledFont.font(forTextStyle: .body)
        tipoSanguineoGray.adjustsFontForContentSizeCategory = true
        
        telefoneGray.font = scaledFont.font(forTextStyle: .body)
        telefoneGray.adjustsFontForContentSizeCategory = true
        
        tgGray.font = scaledFont.font(forTextStyle: .body)
        tgGray.adjustsFontForContentSizeCategory = true
        
        alergiasGray.font = scaledFont.font(forTextStyle: .body)
        alergiasGray.adjustsFontForContentSizeCategory = true
        
        planoGray.font = scaledFont.font(forTextStyle: .body)
        planoGray.adjustsFontForContentSizeCategory = true
        
        enderecoGray.font = scaledFont.font(forTextStyle: .body)
        enderecoGray.adjustsFontForContentSizeCategory = true
        
        medicamentoGray.font = scaledFont.font(forTextStyle: .body)
        medicamentoGray.adjustsFontForContentSizeCategory = true
        
        obsGray.font = scaledFont.font(forTextStyle: .body)
        obsGray.adjustsFontForContentSizeCategory = true
        
        
        //---------
        
        
        dataNascimento.font = scaledFont.font(forTextStyle: .body)
        dataNascimento.adjustsFontForContentSizeCategory = true
        
        tipoSanguineo.font = scaledFont.font(forTextStyle: .body)
        tipoSanguineo.adjustsFontForContentSizeCategory = true
        
        telefone.font = scaledFont.font(forTextStyle: .body)
        telefone.adjustsFontForContentSizeCategory = true
        
        rg.font = scaledFont.font(forTextStyle: .body)
        rg.adjustsFontForContentSizeCategory = true
        
        alergias.font = scaledFont.font(forTextStyle: .body)
        alergias.adjustsFontForContentSizeCategory = true
        
        plano.font = scaledFont.font(forTextStyle: .body)
        plano.adjustsFontForContentSizeCategory = true
        
        endereco.font = scaledFont.font(forTextStyle: .body)
        endereco.adjustsFontForContentSizeCategory = true
        
        medicacoes.font = scaledFont.font(forTextStyle: .body)
        medicacoes.adjustsFontForContentSizeCategory = true
        
        observacoes.font = scaledFont.font(forTextStyle: .body)
        observacoes.adjustsFontForContentSizeCategory = true
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserLoaded()
        setAll()
        self.fotoIdoso.clipsToBounds = true
        self.fotoIdoso.layer.cornerRadius = 20
        
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = true
            vc.tabBar.frame = CGRect(x: 500, y: 500, width: 0, height: 0)
            vc.viewDidLayoutSubviews()
            vc.self.selectedIndex = 2
            
            
        }
        setDynamicType()
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
        
        let a = cdr.loadProfileData()
        let day = Calendar.current.component(.day, from: a.dataDeNascimento ?? Date(timeIntervalSinceNow: 0) )
        let month = Calendar.current.component(.month, from: a.dataDeNascimento ?? Date(timeIntervalSinceNow: 0) )
        let year = Calendar.current.component(.year, from: a.dataDeNascimento ?? Date(timeIntervalSinceNow: 0) )
        dataNascimento.text = "\(day)/\(month)/\(year)"
        observacoes.text = a.Descricao
        endereco.text = a.endereco
        if flag == 0{
            fotoIdoso.image = a.fotoDePerfil
        } else{
            fotoIdoso.image = fotoIdosoAux
        }
        idosoNome.text = a.nome
        plano.text = a.planoDeSaude
        medicacoes.text = a.remedios
        telefone.text = a.telefone
        tipoSanguineo.text = a.tipoSanguineo
        rg.text = a.rg
        alergias.text = a.alergias
        
       // fotoIdoso.image = fotoIdosoAux
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
         cdr.updateProfile(alergias: alergias.text! , dataDeNascimento: Date(), descricao: observacoes.text, endereco: endereco.text, fotoDePerfil: fotoIdoso.image, nome: idosoNome.text, planoDeSaude: plano.text, remedios: medicacoes.text!, telefone: telefone.text, tipoSanguineo: tipoSanguineo.text, rg: rg.text)
    }
    
    
    
    @IBAction func editbutton(_ sender: UIBarButtonItem) {
        editPressed = !editPressed
        
        if (editPressed){
            changeAll(editPressed)
            editOutlet.title = NSLocalizedString("Done" , comment: "")
            
        } else{
            changeAll(editPressed)
           
            editOutlet.title = NSLocalizedString("Edit" , comment: "")
        }
        
        
    }
    
    func changeAll(_ bo: Bool){
        idosoNome.isUserInteractionEnabled = bo
        dataNascimento.isUserInteractionEnabled = bo
        tipoSanguineo.isUserInteractionEnabled = bo
        telefone.isUserInteractionEnabled = bo
        rg.isUserInteractionEnabled = bo
        telefone.isUserInteractionEnabled = bo
        alergias.isUserInteractionEnabled = bo
        plano.isUserInteractionEnabled = bo
        endereco.isUserInteractionEnabled = bo
        medicacoes.isUserInteractionEnabled = bo
        observacoes.isUserInteractionEnabled = bo
    }
    
    var fotoIdosoAux = UIImage(named: "Remedio")
    var flag = 0
    
    
    
    
    
}


extension DetailProfileViewController: ImagePickerDelegate{
    
    func didSelect(imagem: UIImage?) {
        self.fotoIdoso.image = imagem
        fotoIdosoAux = imagem
        flag = 1
        
    }
    
}
