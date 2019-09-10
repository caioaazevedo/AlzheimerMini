//
//  DetailViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 03/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let iconesArray = [UIImage(named: "Hora"), UIImage(named: "Responsável"), UIImage(named: "Local") , UIImage(named: "Notas")]
    var diaAux : String?
    var diaSemanaAux : String?
    var indexValue = 0
    var event = Events(titleParameter: "", timeParameter: "", descParameter: "", categParameter: "", responsavelParameter: "", localizationParameter: "")
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        diaSemana.text = ("\(diaAux!), \(diaSemanaAux!)")
        titulo.text = event.title ?? ""
        
        blueView.layer.cornerRadius = 8
        blueView.clipsToBounds = true
        
        
    }
    @IBOutlet weak var diaSemana: UILabel!
    @IBOutlet weak var titulo: UILabel!
    

    
    
}

extension DetailViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as! CellDetail
        
        var image = UIImage(named: "")
        var tipo = ""
        var detalhe = ""
        
        switch(indexPath.row){
            case 0:
                image = iconesArray[0]
                tipo = "Hora"
                detalhe = event.time
            
            case 1:
                image = iconesArray[1]
                tipo = "Responsável"
                detalhe = event.responsavel
            case 2:
                image = iconesArray[2]
                tipo = "Local"
                detalhe = event.localization
            default:
                image = iconesArray[3]
                tipo = "Notas"
                detalhe = event.desc ?? ""
        }
        
        cell.imagem.image = image
        cell.tipoDetalhe.text = tipo
        cell.labelDetail.text = detalhe
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    
    
    
}
