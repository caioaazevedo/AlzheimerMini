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

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var feedView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        feedView.delegate = self
//        feedView.dataSource = self
//        UserNotification.requestNotificationAuthorization()
//        Cloud.setupCloudKitNotifications()
//        Cloud.deleteCloudSubs()
//        CoreDataRebased.shared.createUsuario(email: "", fotoDoPerfil: UIImage(named: "Remedio"), Nome: "Gui")
//        CoreDataRebased.shared.createSala()
    }
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    

    override func viewWillAppear(_ animated: Bool) {
        print("=-=-=-=-=-=->>>> \(eventosSalvos)")
        eventosSalvos.removeAll()
        fetchAll()
        Cloud.getPeople()
        
        tableView.reloadData()
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
        
        let url = URL(string: "login://" + "\(userload.idSala!)")
        
        let text = "\(user.nome!) would like your participation in the family group. Access key: \(url!)."
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionName: String
        switch section {
        case 0:
            sectionName = NSLocalizedString("Hoje", comment: "")
        case 1:
            sectionName = NSLocalizedString("Anteriores", comment: "")
        // ...
        default:
            sectionName = ""
        }
        return sectionName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if eventosSalvos.count > 0{
            if section == 0 {
                for i in 0...eventosSalvos.count-1 {
                    if eventosSalvos[i].dia! == Date() as NSDate{
                        count += 1
                    }
                }
                return count
            } else {
                for i in count...eventosSalvos.count-1 {
                    if eventosSalvos[i].dia! == Date() as NSDate{
                        count += 1
                    }
                }
                return eventosSalvos.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellFeed", for: indexPath) as! CustomCellFeed
        
        var pessoas = CoreDataRebased.shared.fetchPessoas()

        print("=-===-=-=-> \(pessoas)")
        
        cell.view.layer.cornerRadius = 10
        
//        if eventosSalvos.count > 0 {
//            for i in 0...pessoas.count-1{
//                for j in 0...eventosSalvos.count-1 {
//                    if pessoas[i].id == eventosSalvos[j].idResponsavel {
//                        cell.imageFoto.image = UIImage(data: pessoas[i].foto! as Data)
//
//                        let hour = Calendar.current.component(.hour, from: eventosSalvos[j].horario! as Date)
//                        let minute = Calendar.current.component(.minute, from: eventosSalvos[j].horario! as Date)
//                        let day = Calendar.current.component(.day, from: eventosSalvos[j].horario! as Date)
//
//                        auxMesNum = Calendar.current.component(.month, from: eventosSalvos[j].horario! as Date)
//
//                        cell.label.text = "\(eventosSalvos[j].idResponsavel ?? "Gui") marcou  \(eventosSalvos[j].nome!) para Pedro Paulo em \(eventosSalvos[j].localizacao ?? "Brasilia") as \(hour):\(minute) no dia \(day) de \(auxMes) "
//                    }
//                }
//            }
//        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}


