//
//  ViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 16/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import CloudKit
import CoreData
class ViewController: UIViewController {
    
    let UserNotification = Notification()
    
    @IBOutlet weak var feedView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    var auxMes = ""
    var auxMesNum : Int?{
        didSet{
            switch(auxMesNum){
            case 1:
                auxMes = "Janeiro"
            case 2:
                auxMes = "Fevereiro"
            case 3:
                auxMes = "Marco"
            case 4:
                auxMes = "Abril"
            case 5:
                auxMes = "Maio"
            case 6:
                auxMes = "Junho"
            case 7:
                auxMes = "Julho"
            case 8:
                auxMes = "Agosto"
            case 9:
                auxMes = "Setembro"
            case 10:
                auxMes = "Outubro"
            case 11:
                auxMes = "Novembro"
            default:
                auxMes = "Dezembro"
            }
        }
    }
    
    var eventosSalvos = [Evento]()
//
//    struct Evento: Hashable, Comparable {
//        var titulo = ""
//        var horario = ""
//        var dia = ""
//        var localizacao = ""
//        var responsavel = ""
//
//        // Operator Overloading (Sobrecarga de Operadores)
//        static func < (lhs: Evento, rhs: Evento) -> Bool {
//            return lhs.horario < rhs.horario
//        }
//
//    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedView.delegate = self
        feedView.dataSource = self
        UserNotification.requestNotificationAuthorization()

//        CoreDataRebased.shared.createUsuario(email: "pagodeira.com", fotoDoPerfil: nil, Nome: "Pagode")
//        CoreDataRebased.shared.createSala()
        
        UserLoaded()
    }
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        eventosSalvos.removeAll()
        fetchAll()
        feedView.reloadData()
    }
    
    
    func fetchAll(){
        let fetchRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        do{
            let eventos = try managedObjectContext.fetch(fetchRequest)
            eventosSalvos.removeAll()
            for evento in eventos{
                eventosSalvos.append(evento)
            }
        }catch{
            
        }
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        feedView.reloadData()
    }
    
    
    @IBAction func shareAction(_ sender: Any) {
        // text to share
        let userload = UserLoaded()
        
        let user = CoreDataRebased.shared.loadUserData()
        
        let text = "\(user.nome!) would like your participation in the family group. Access key: \(userload.idSala!)."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension ViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventosSalvos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFeed", for: indexPath) as! CellFeed
        let indexRow = eventosSalvos[indexPath.row]
        let hour = Calendar.current.component(.hour, from: indexRow.horario! as Date)
        let minute = Calendar.current.component(.minute, from: indexRow.horario! as Date)
        let day = Calendar.current.component(.day, from: indexRow.horario! as Date)
        auxMesNum = Calendar.current.component(.month, from: indexRow.horario! as Date)
        cell.descricao.text = "\(indexRow.idResponsavel ?? "Gui") marcou  \(indexRow.nome!) para Pedro Paulo em \(indexRow.localizacao ?? "Brasilia") as \(hour):\(minute) no dia \(day) de \(auxMes) "
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
