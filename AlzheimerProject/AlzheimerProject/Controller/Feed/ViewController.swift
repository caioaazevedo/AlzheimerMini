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
import CircleBar
import FSCalendar

class ViewController: UIViewController {
    let loadUser = UserLoaded()
    let UserNotification = Notification()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var feedView: UITableView!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    //    struct Evento: Hashable, Comparable {
    //        var titulo = ""
    //        var horario = ""
    //        var dia = ""
    //        var localizacao = ""
    //        var responsavel = ""
    //
    //        // Operator Overloading (Sobrecarga de Operadores)
    //        static func < (lhs: Evento, rhs: Evento)git   -> Bool {
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
    
    var myPeople : [feedPerson] = []
    
    var eventosSalvos = [Evento]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sala = CoreDataRebased.shared.fetchSala()
        
        self.navBar.title = sala.nomeFamilia
        
        //        feedView.delegate = self
        //        feedView.dataSource = self
        //        UserNotification.requestNotificationAuthorization()
        //        Cloud.setupCloudKitNotifications()
        //        Cloud.deleteCloudSubs()
        //        CoreDataRebased.shared.createUsuario(email: "", fotoDoPerfil: UIImage(named: "Remedio"), Nome: "Gui")
        //        CoreDataRebased.shared.createSala()
        
        CoreDataRebased.shared.recuperarDadosEventos(completion: { (myVector) in
            self.contador = 0
            self.contador2 = 0
            let formate = DateFormatter()
            formate.dateFormat = "dd-MM-yyyy"
            self.myPeople = myVector
            self.myPeople.reverse()
            for i in self.myPeople{
                let d = "dd-MM-yyy"
                if formate.string(from: i.dataCriada) == formate.string(from: Date()){
                    self.contador += 1
                } else {
                    self.contador2 += 1
                }
            }
            self.tableView.reloadData()
        }, indici: self.segmentedControl.selectedSegmentIndex)
        
        //Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        //Refresh
        
        
    }
    var z = 0
    @objc func refreshTable(refreshControl: UIRefreshControl){
        //Adicionar aqui o fetch do cloud para o coreData
        
        Cloud.getPeople {
            DispatchQueue.main.async {
                CoreDataRebased.shared.recuperarDadosEventos(completion: { (myVector) in
                    self.contador = 0
                    self.contador2 = 0
                    let formate = DateFormatter()
                    formate.dateFormat = "dd-MM-yyyy"
                    self.myPeople = myVector
                    self.myPeople.reverse()
                    for i in self.myPeople{
                        let d = "dd-MM-yyy"
                        if formate.string(from: i.dataCriada) == formate.string(from: Date()){
                            self.contador += 1
                        } else {
                            self.contador2 += 1
                        }
                    }
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                }, indici: self.segmentedControl.selectedSegmentIndex)


            }
        }
    }
    
    
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var pessoas = [Pessoas]()
    var contador = 0
    var contador2 = 0
    
    override func viewWillAppear(_ animated: Bool) {
//        CoreDataRebased.shared.recuperarDadosEventos { (myVector) in
//            self.myPeople = myVector
//        }
        
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = false
            vc.viewDidLayoutSubviews()
            vc.self.selectedIndex = 0
        }
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


    @IBAction func changeState(_ sender: Any) {
        DispatchQueue.main.async {
            CoreDataRebased.shared.recuperarDadosEventos(completion: { (myVector) in
                self.contador = 0
                self.contador2 = 0
                let formate = DateFormatter()
                formate.dateFormat = "dd-MM-yyyy"
                self.myPeople = myVector
                self.myPeople.reverse()
                
                for i in self.myPeople{
                    if formate.string(from: i.dataCriada) == formate.string(from: Date()){
                        self.contador += 1
                    } else {
                        self.contador2 += 1
                    }
                }
                self.tableView.reloadData()
            }, indici: self.segmentedControl.selectedSegmentIndex)
        }
        
        
    }
    
   
}

extension ViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return NSLocalizedString("Today", comment: "")
        }
        
        return NSLocalizedString("Previously", comment: "")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
             return contador
        } else {
            return contador2
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellFeed2", for: indexPath) as! CustomCellFeed
            let formate = DateFormatter()
            formate.dateFormat = "dd-MM-yyyy"
            
            print("indexpath", indexPath.row)
            
             if formate.string(from: Date()) == formate.string(from: myPeople[indexPath.row].dataCriada){
                switch segmentedControl.selectedSegmentIndex {
                case 1:
                    print("1")
                    if myPeople[indexPath.row].nomeCriador == UserLoaded().getUserName(){
                        cell.label.text = "\(myPeople[indexPath.row].nomeEvento) foi marcado por \(myPeople[indexPath.row].nomeCriador) para o dia \(myPeople[indexPath.row].dataEvento)"
                        cell.bgVview.clipsToBounds = true
                        cell.bgVview.layer.cornerRadius = 15
                        cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
                        cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
                        
                    }
                default:
                    print("0")
                    cell.label.text = "\(myPeople[indexPath.row].nomeEvento) foi marcado por \(myPeople[indexPath.row].nomeCriador) para o dia \(myPeople[indexPath.row].dataEvento)"
                    cell.bgVview.clipsToBounds = true
                    cell.bgVview.layer.cornerRadius = 15
                    cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
                    cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
                }
            
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellFeed", for: indexPath) as! CustomCellFeed
            let formate = DateFormatter()
            formate.dateFormat = "dd-MM-yyyy"
            print("indexpath", indexPath.row)
            if formate.string(from: Date()) != formate.string(from: myPeople[indexPath.row].dataCriada){
            
            switch segmentedControl.selectedSegmentIndex {
            case 1:
                print("1")
                
                if myPeople[indexPath.row].nomeCriador == UserLoaded().getUserName(){
                    cell.label.text = "\(myPeople[indexPath.row].nomeEvento) foi marcado por \(myPeople[indexPath.row].nomeCriador) para o dia \(myPeople[indexPath.row].dataEvento)"
                    cell.bgVview.clipsToBounds = true
                    cell.bgVview.layer.cornerRadius = 15
                    cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
                    cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
                    
                }
            default:
                print("0")
                cell.label.text = "\(myPeople[indexPath.row].nomeEvento) foi marcado por \(myPeople[indexPath.row].nomeCriador) para o dia \(myPeople[indexPath.row].dataEvento)"
                cell.bgVview.clipsToBounds = true
                cell.bgVview.layer.cornerRadius = 15
                cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
                cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
            }
            
            }
            return cell
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func getFotoCriador(idCriador: String) ->UIImage {
        for ck in ckData {
            if ck.0 == idCriador {
                return UIImage(data: ck.2)!
            }
        }
        
        return UIImage(named: "ProfilePicture")!
    }
    
    
    
}

/*
 1.
 2.
 3.
 4.
 5.
 6.
 */
