//
//  DetailViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 03/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var event : Events?
    var diaAux : String?
    var diaSemanaAux : String?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dia.text = diaAux
        diaSemana.text = diaSemanaAux
        titulo.text = event?.title
        dia.text = event?.day
        hora.text = event?.time
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        performSegue(withIdentifier: "Calendar", sender: self)
    }
    
    
    
    @IBAction func edit(_ sender: UIButton) {
        performSegue(withIdentifier: "segueEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEdit"{
            if let vc = segue.destination as? TaskViewController {
                vc.event = self.event
                vc.willEditing = true
            }
    }
    }
    
    
    @IBOutlet weak var categ: UITextField!
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
