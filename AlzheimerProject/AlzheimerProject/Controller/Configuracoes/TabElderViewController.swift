//
//  TabElderViewController.swift
//  AlzheimerProject
//
//  Created by Caio Azevedo on 25/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class TabElderViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var dataNasc: UITextField!
    @IBOutlet weak var RG: UITextField!
    @IBOutlet weak var tipo: UITextField!

    @IBOutlet weak var plano: UITextField!
    @IBOutlet weak var telefone: UITextField!
    
    @IBOutlet weak var endereco: UITextView!
    @IBOutlet weak var alergia: UITextView!
    @IBOutlet weak var medicamento: UITextView!
    @IBOutlet weak var observacoes: UITextView!
    
    var selecionado = Int()
    var flag = 0
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selecionado = indexPath.row
        tableView.reloadData()
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selecionado == indexPath.row && selecionado > 4 {
            flag += 1
            if flag == 2{
                flag = 0
                return 98
            }
            return 220
            
        }
        return 98
    }
    
    
    

}

class cellConfig: UITableViewCell{
    
    
    
    
}
