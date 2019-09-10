//
//  DetailProfileViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class DetailProfileViewController: UIViewController {
    
    var editPressed = false
    var cdr = CoreDataRebased.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if (profile == host) && editPressed{
     //   setAll()
        
        
        //}
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserLoaded()
        setAll()
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        cdr.updateProfile(alergias: [alergias.text!] , dataDeNascimento: Date(), descricao: observacoes.text, endereco: endereco.text, fotoDePerfil: fotoIdoso.image, nome: idosoNome.text, planoDeSaude: plano.text, remedios: [medicacoes.text!], telefone: telefone.text, tipoSanguineo: tipoSanguineo.text)
    }
    
    
    func setAll(){
        
        let a = cdr.loadProfileData()
        let day = Calendar.current.component(.day, from: a.dataDeNascimento ?? Date(timeIntervalSinceNow: 0) )
        let month = Calendar.current.component(.month, from: a.dataDeNascimento ?? Date(timeIntervalSinceNow: 0) )
        let year = Calendar.current.component(.year, from: a.dataDeNascimento ?? Date(timeIntervalSinceNow: 0) )
        dataNascimento.text = "\(day)/\(month)/\(year)"
        observacoes.text = a.Descricao
        endereco.text = a.endereco
        fotoIdoso.image = a.fotoDePerfil
        idosoNome.text = a.nome
        plano.text = a.planoDeSaude
        medicacoes.text = a.remedios?[0]
        telefone.text = a.telefone
        tipoSanguineo.text = a.tipoSanguineo
    }
    
    
    
    
    @IBOutlet weak var editOutlet: UIBarButtonItem!
    
    @IBAction func editbutton(_ sender: UIBarButtonItem) {
        editPressed = !editPressed
        
        if (editPressed){
            changeAll(editPressed)
            editOutlet.title = "Done"
          
        } else{
            changeAll(editPressed)
                cdr.updateProfile(alergias: [alergias.text!] , dataDeNascimento: Date(), descricao: observacoes.text, endereco: endereco.text, fotoDePerfil: fotoIdoso.image, nome: idosoNome.text, planoDeSaude: plano.text, remedios: [medicacoes.text!], telefone: telefone.text, tipoSanguineo: tipoSanguineo.text)
            editOutlet.title = "Edit"
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
    
    
    
    
    
    
    
    
    
    
}
