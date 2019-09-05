//
//  DetailProfileViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class DetailProfileViewController: UIViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if (profile == host){
        idosoNome.isUserInteractionEnabled = true
        dataNascimento.isUserInteractionEnabled = true
        tipoSanguineo.isUserInteractionEnabled = true
        telefone.isUserInteractionEnabled = true
        rg.isUserInteractionEnabled = true
        
        
    //}
        // Do any additional setup after loading the view.
    }
    
    func setAll(){
//        idosoNome.text
//        dataNascimento.text
//        tipoSanguineo.text
//        telefone.text
//        rg.text
        
    }
    
    
    
    
    
    
    
    @IBOutlet weak var idosoNome: UITextField!
    @IBOutlet weak var dataNascimento: UITextField!
    @IBOutlet weak var tipoSanguineo: UITextField!
    @IBOutlet weak var telefone: UITextField!
    @IBOutlet weak var rg: UITextField!
    
    
    
    @IBOutlet weak var endereco: UILabel!
    @IBOutlet weak var fotoIdoso: UIImageView!
    
    
    
    
    
    
    

}
