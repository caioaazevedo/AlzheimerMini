//
//  DetailViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 03/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var diaAux : String?
    var diaSemanaAux : String?
    var tituloAux : String?
    var horaAux : String?
    var responsavelAux : String?
    var localAux : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dia.text = diaAux
        diaSemana.text = diaSemanaAux
        titulo.text = tituloAux
        hora.text = horaAux
        responsavel.text = responsavelAux
        local.text = localAux
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var dia: UILabel!
    @IBOutlet weak var diaSemana: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var hora: UILabel!
    @IBOutlet weak var responsavel: UILabel!
    @IBOutlet weak var local: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
