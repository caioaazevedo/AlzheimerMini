//
//  ViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 16/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textSearch: UITextField!
    @IBOutlet weak var textSala: UITextField!
    @IBOutlet weak var textUsuario: UITextField!
    @IBOutlet weak var idCalendario: UITextField!
    @IBOutlet weak var textPerfil: UITextField!
    @IBOutlet weak var textHost: UITextField!
    
    @IBOutlet weak var labelDados: UILabel!
    
    
    let UserNotification = Notification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNotification.requestNotificationAuthorization()
        print("öi")
        
        
//        CoreDataRebased.shared.createUsuario(email: "pedro@gmail.com", fotoDoPerfil: nil, Nome: "Pedro")
//        CoreDataRebased.shared.createSala()
        
        let x = Date()
        
//            Cloud.updatePerfil(searchRecord: "F3D95174-F479-47B5-BEA7-321F942B483B", idPerfil: "F3D95174-F479-47B5-BEA7-321F942B483B", nome: "velho", dataNascimento: x, telefone: "3323", descricao: "KKK", fotoPerfil: nil, endereco: "casa", remedios: ["alprazolam"], alergias: ["todas"], tipoSanguineo: "o melhor", planoSaude: "Deus")
//        Cloud.updatePerfil(searchRecord: "F3D95174-F479-47B5-BEA7-321F942B483B", nome: "PEDERO")
        CoreDataRebased.shared.createEvent(categoria: "CASA", descricao: "SAL", dia: 12, horario: 12)
    }

    
    
    
    @IBAction func acaoDoBotao(_ sender: Any) {
//        Cloud.updateSala(searchRecord: self.textSearch.text!, idSala: self.textSala.text!, idUsuario: [self.textUsuario.text!], idCalendario: self.idCalendario.text!, idPerfil: self.textPerfil.text!, idHost: self.textHost.text!)
        
        let search = self.textSearch.text!
        
        Cloud.deleteTable(searchRecord: search, searchKey: "idSala", searchTable: "Sala")
    }

    @IBAction func getButton(_ sender: Any) {
        Cloud.querySala(searchRecord: self.textSearch.text!)
        
        self.labelDados.text = "\(DadosSala.sala.idSala), \(DadosSala.sala.idUsuarios), \(DadosSala.sala.idCalendario), \(DadosSala.sala.idPerfil), \(DadosSala.sala.idHost)"
    }
}

