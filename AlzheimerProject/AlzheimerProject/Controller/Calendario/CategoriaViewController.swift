//
//  CategoriaViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 18/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class CategoriaViewController : UIViewController, UITableViewDataSource,UITableViewDelegate{
    
    var array = [""]
    var arrayImage = [UIImage]()
    var pessoas = [Pessoas]()
    var categoriaSelecionada = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRes", for: indexPath) as! CellClass
        cell.textTable.text = array[indexPath.row]
        cell.categoria.image = arrayImage[indexPath.row]
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CellClass
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
}





class CellClass : UITableViewCell{
    
    @IBOutlet weak var textTable: UILabel!
    
    @IBOutlet weak var categoria: UIImageView!
    
}

