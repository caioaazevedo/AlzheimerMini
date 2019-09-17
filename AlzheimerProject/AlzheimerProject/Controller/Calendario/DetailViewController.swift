//
//  DetailViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 03/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import CircleBar

class DetailViewController: UIViewController {
    
    let iconesArray = [UIImage(named: "Camada 2-1"), UIImage(named: "Camada 2"), UIImage(named: "Camada 2-2") , UIImage(named: "Camada 2-3")]
    var diaAux : String?
    var diaSemanaAux : String?
    var indexValue = 0
    var event = Events(titleParameter: "", timeParameter: "", descParameter: "", categParameter: "", responsavelParameter: [""], localizationParameter: "",idParameter: "")
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        diaSemana.text = ("\(diaAux!), \(diaSemanaAux!)")
        titulo.text = event.title ?? ""
        
        blueView.layer.cornerRadius = 50
        blueView.clipsToBounds = true
        setShadowBlueView()
        defineColor()
        defineDynamicType()
        
        
    }
    
    func defineDynamicType(){
        let fontName = "SFProText-Regular"
        
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        
        diaSemana.font = scaledFont.font(forTextStyle: .body)
        diaSemana.adjustsFontForContentSizeCategory = true
    }
    
    
    func defineColor(){
        switch(event.categ){
        case NSLocalizedString("Health", comment: ""):
            blueView.backgroundColor = .init(red: 0.68, green: 0.84, blue: 0.89, alpha: 1)
        case NSLocalizedString("Recreation", comment: ""):
            blueView.backgroundColor = .init(red: 0.70, green: 0.72, blue: 0.89, alpha: 1)
        case NSLocalizedString("Dentist", comment: ""):
            blueView.backgroundColor = .init(red: 0.87, green: 0.62, blue: 0.77, alpha: 1)
        case NSLocalizedString("Pharmacy", comment: ""):
            blueView.backgroundColor = .init(red: 0.93, green: 0.65, blue: 0.34, alpha: 1)
        default:
            blueView.backgroundColor = .init(red: 0.67, green: 0.85, blue: 0.74, alpha: 1)
        }
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = true
            vc.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
    
    @IBOutlet weak var diaSemana: UILabel!
    @IBOutlet weak var titulo: UILabel!
    
    
    let userLoad = UserLoaded()
    
    @IBAction func deleteTask(_ sender: UIButton) {
        
        Cloud.cloudDeleteEvento(eventoId: event.ID)
      
        
        CoreDataRebased.shared.deleteEvento(eventoId: event.ID) { (nome) in
            Cloud.updateCalendario(searchRecord: self.userLoad.idSalaCalendar!, idEventos: nome)
        }
        
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    

    
    
}

extension DetailViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath) as! CellDetail
        
        let fontName = "SFProText-Regular"
        
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        var image = UIImage(named: "")
        var tipo = ""
        var detalhe = ""
        
        switch(indexPath.row){
            case 0:
                image = iconesArray[0]
                tipo = NSLocalizedString("Time", comment: "")
                detalhe = event.time
            
            case 1:
                image = iconesArray[1]
                tipo = NSLocalizedString("Responsable", comment: "")
                var string: String?
                for element in event.responsavel {
                    if string == nil {
                        string = element
                    } else {
                        string = string! + ", " + element
                    }
                }
                
                detalhe = string ?? NSLocalizedString("None", comment: "")
            case 2:
                image = iconesArray[2]
                tipo = NSLocalizedString("Localization",comment: "")
                detalhe = event.localization
            default:
                image = iconesArray[3]
                tipo = NSLocalizedString("Notes",comment: "")
                detalhe = event.desc
        }
        
        cell.imagem.image = image
        cell.tipoDetalhe.text = tipo
        cell.labelDetail.text = detalhe
        
        cell.tipoDetalhe.font = scaledFont.font(forTextStyle: .body)
        cell.tipoDetalhe.adjustsFontForContentSizeCategory = true
        
        cell.labelDetail.font = scaledFont.font(forTextStyle: .body)
        cell.labelDetail.adjustsFontForContentSizeCategory = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func setShadowBlueView() {
        blueView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        blueView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        blueView.layer.shadowRadius = 5
        blueView.layer.shadowOpacity = 0.5
        blueView.clipsToBounds = true
        blueView.layer.masksToBounds = false
    }
    
    
}
