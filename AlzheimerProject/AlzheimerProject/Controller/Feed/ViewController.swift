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
    @IBOutlet weak var activitiesLabel: UILabel!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    //⚡️
    var allToday = [feedPerson]()
    var allPreviously = [feedPerson]()
    var mineToday = [feedPerson]()
    var minePreviously = [feedPerson]()
    //⚡️
    
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
        
        
        Cloud.setupCloudKitNotifications()
        
        print("ENTROU AQUII")
        Cloud.updateUsuarioProfile()
        CoreDataRebased.shared.deleteAllEvents()
        Cloud.updateCalendario { (result) in
            Cloud.updateAllEvents(completion: { (t) in
                self.fetchAll()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                DispatchQueue.main.async {
                    CoreDataRebased.shared.recuperarDadosEventos(completion: { (myVector) in
                        self.contador = 0
                        self.contador2 = 0
                        let formate = DateFormatter()
                        formate.dateFormat = "dd-MM-yyyy"
                        self.myPeople = myVector
                        //self.myPeople.reverse()
                        
                        self.allPreviously.removeAll()
                        self.allToday.removeAll()
                        self.minePreviously.removeAll()
                        self.mineToday.removeAll()
                        if self.segmentedControl.selectedSegmentIndex == 0{
                            
                            for i in self.myPeople{
                                if i.dataEvento == formate.string(from: Date()){
                                    self.contador += 1
                                    self.allToday.append(i)
                                } else {
                                    self.contador2 += 1
                                    self.allPreviously.append(i)
                                }
                            }
                        } else {
                            for i in self.myPeople{
                                if i.dataEvento == formate.string(from: Date()) && i.reponsaveis.contains(UserLoaded().getUserName()){
                                    self.contador += 1
                                    self.mineToday.append(i)
                                } else if i.reponsaveis.contains(UserLoaded().getUserName()) {
                                    self.contador2 += 1
                                    self.minePreviously.append(i)
                                }
                            }
                        }
                        
                        self.tableView.reloadData()
                    }, indici: self.segmentedControl.selectedSegmentIndex)
                }
                
                
                
                
                
            })
        }
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
            //self.myPeople.reverse()
            
            
            self.allPreviously.removeAll()
            self.allToday.removeAll()
            self.minePreviously.removeAll()
            self.mineToday.removeAll()
            if self.segmentedControl.selectedSegmentIndex == 0{
                
                for i in self.myPeople{
                    if i.dataEvento == formate.string(from: Date()){
                        self.contador += 1
                        self.allToday.append(i)
                    } else {
                        self.contador2 += 1
                        self.allPreviously.append(i)
                    }
                }
            } else {
                for i in self.myPeople{
                    if i.dataEvento == formate.string(from: Date()) && i.reponsaveis.contains(UserLoaded().getUserName()){
                        self.contador += 1
                        self.mineToday.append(i)
                    } else if i.reponsaveis.contains(UserLoaded().getUserName()) {
                        self.contador2 += 1
                        self.minePreviously.append(i)
                    }
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
                  //  self.myPeople.reverse()
                    
                    self.allPreviously.removeAll()
                    self.allToday.removeAll()
                    self.minePreviously.removeAll()
                    self.mineToday.removeAll()
                    if self.segmentedControl.selectedSegmentIndex == 0{
                        
                        for i in self.myPeople{
                            if i.dataEvento == formate.string(from: Date()){
                                self.contador += 1
                                self.allToday.append(i)
                            } else {
                                self.contador2 += 1
                                self.allPreviously.append(i)
                            }
                        }
                    } else {
                        for i in self.myPeople{
                            if i.dataEvento == formate.string(from: Date()) && i.reponsaveis.contains(UserLoaded().getUserName()){
                                self.contador += 1
                                self.mineToday.append(i)
                            } else if i.reponsaveis.contains(UserLoaded().getUserName()) {
                                self.contador2 += 1
                                self.minePreviously.append(i)
                            }
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
        
        let fontName = "SFProText-Regular"
        self.fetchAll()
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        activitiesLabel.font = scaledFont.font(forTextStyle: .body)
        activitiesLabel.adjustsFontForContentSizeCategory = true
        
        
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = false
            vc.viewDidLayoutSubviews()
            vc.self.selectedIndex = 0
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
                
             //   self.myPeople.reverse()
                
                self.allPreviously.removeAll()
                self.allToday.removeAll()
                self.minePreviously.removeAll()
                self.mineToday.removeAll()
                if self.segmentedControl.selectedSegmentIndex == 0{
                    
                    for i in self.myPeople{
                        if i.dataEvento == formate.string(from: Date()){
                            self.contador += 1
                            self.allToday.append(i)
                        } else {
                            self.contador2 += 1
                            self.allPreviously.append(i)
                        }
                    }
                }
                if self.segmentedControl.selectedSegmentIndex == 1 {
                    for i in self.myPeople{
                        if i.dataEvento == formate.string(from: Date()) && i.reponsaveis.contains(UserLoaded().getUserName()){
                            self.contador += 1
                            self.mineToday.append(i)
                        } else if i.reponsaveis.contains(UserLoaded().getUserName()) {
                            self.contador2 += 1
                            self.minePreviously.append(i)
                        }
                    }
                }
                
                
                
                
                
                
                
                self.tableView.reloadData()
            }, indici: self.segmentedControl.selectedSegmentIndex)
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
    
    var auxDiaSemanaNum : Int? {
        didSet{
            switch (auxDiaSemanaNum){
            case 1:
                auxDiaSemana = NSLocalizedString("Sunday", comment: "")
            case 2:
                auxDiaSemana = NSLocalizedString("Monday", comment: "")
            case 3:
                auxDiaSemana = NSLocalizedString("Tuesday", comment: "")
            case 4:
                auxDiaSemana = NSLocalizedString("Wednesday", comment: "")
            case 5:
                auxDiaSemana = NSLocalizedString("Thursday", comment: "")
            case 6:
                auxDiaSemana = NSLocalizedString("Friday", comment: "")
            default:
                auxDiaSemana = NSLocalizedString("Saturday", comment: "")
            }
        }
    }
    
    var auxDiaSemana : String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFeedDetail" {
            
             let vc = segue.destination as! DetailViewController
            let evento = eventosSalvos[auxiliarSegue]
            let responsaveis = [String]()
            
            let diaEvento = Calendar.current.component(.day,from: evento.dia! as Date ?? Date())
            let mesEvento = Calendar.current.component(.month,from: evento.dia! as Date ?? Date())
            auxDiaSemanaNum = Calendar.current.component(.weekday, from: evento.dia! as Date ?? Date())
            let auxDia = Calendar.current.component(.day, from: evento.dia as! Date ?? Date())
            let auxMesNum = Calendar.current.component(.month, from: evento.dia as! Date ?? Date())
            
            let df = DateFormatter()
            df.dateFormat = "hh:mm"
            let data = df.string(from: evento.horario! as Date)
            
            
            if evento.idUsuarios != nil{
                let responsaveis = (evento.idUsuarios as! NSArray).mutableCopy() as! [String]
                
            }
            
            
            
            let eventoS = Events(titleParameter: evento.nome!, timeParameter: data, descParameter: evento.descricao ?? "", categParameter: evento.categoria ?? "", responsavelParameter: responsaveis ?? [""], localizationParameter: evento.localizacao ?? "",idParameter: evento.id!)
    
            // myPeople[indexPath.row
            
            vc.event = eventoS
            vc.diaAux = "\(auxDia) de \(auxMes)"
            vc.diaSemanaAux = "\(auxDiaSemana!)"
        }
    
    }
    
    var auxiliarSegue = 0
    
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        auxiliarSegue = indexPath.row
        performSegue(withIdentifier: "segueFeedDetail", sender: self)

        //myPeople[indexPath.row].nomeEvento
       
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellFeed", for: indexPath) as! CustomCellFeed
            let formate = DateFormatter()
            formate.dateFormat = "dd-MM-yyyy"
            let formateTime = DateFormatter()
            formateTime.dateFormat = "HH:mm"
            
            switch segmentedControl.selectedSegmentIndex{
            case 0:
                print("0")
                //                allToday[indexPath.row]
                let fontNameBold = "SFProText-Bold"
                
                let scaledFontBold: ScaledFont = {
                    return ScaledFont(fontName: fontNameBold)
                }()
                
                
                let att = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let boldEvento = NSMutableAttributedString(string: allToday[indexPath.row].nomeEvento, attributes: att)
                let boldCriador = NSMutableAttributedString(string: allToday[indexPath.row].nomeCriador, attributes: att)
                let boldData = NSMutableAttributedString(string: allToday[indexPath.row].dataEvento, attributes: att)
                let boldTime = NSMutableAttributedString(string: formateTime.string(from: allToday[indexPath.row].horarioEvento), attributes: att)
                
                
                var bodyText1 = NSMutableAttributedString(string: " foi marcado por ")
                var bodyText2 = NSMutableAttributedString(string: " para o dia ")
                var bodyText3 = NSMutableAttributedString(string: " as ")
                let combination = NSMutableAttributedString()
                
                combination.append(boldEvento)
                combination.append(bodyText1)
                combination.append(boldCriador)
                combination.append(bodyText2)
                combination.append(boldData)
                
                
                
                
                let fontName = "SFProText-Regular"
                
                
                
                let scaledFont: ScaledFont = {
                    return ScaledFont(fontName: fontName)
                }()
                
                cell.label.font = scaledFont.font(forTextStyle: .body)
                
                
                cell.label.attributedText = combination
                cell.label.adjustsFontForContentSizeCategory = true
                
                cell.bgVview.clipsToBounds = true
                cell.bgVview.layer.cornerRadius = 15
                cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
                cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
                
                cell.bgVview.layer.shadowColor = UIColor.black.cgColor
                cell.bgVview.layer.shadowOpacity = 1
                cell.bgVview.layer.shadowOffset = CGSize.zero
                cell.bgVview.layer.shadowRadius = 5
                
                
            default:
                print("1")
                //                mineToday[indexPath.row]
                let fontNameBold = "SFProText-Bold"
                
                let scaledFontBold: ScaledFont = {
                    return ScaledFont(fontName: fontNameBold)
                }()
                
                
                let att = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let boldEvento = NSMutableAttributedString(string: mineToday[indexPath.row].nomeEvento, attributes: att)
                let boldCriador = NSMutableAttributedString(string: mineToday[indexPath.row].nomeCriador, attributes: att)
                let boldData = NSMutableAttributedString(string: mineToday[indexPath.row].dataEvento, attributes: att)
                let boldTime = NSMutableAttributedString(string: formateTime.string(from: mineToday[indexPath.row].horarioEvento), attributes: att)
                
                
                var bodyText1 = NSMutableAttributedString(string: " foi marcado por ")
                var bodyText2 = NSMutableAttributedString(string: " para o dia ")
                var bodyText3 = NSMutableAttributedString(string: " as ")
                let combination = NSMutableAttributedString()
                
                combination.append(boldEvento)
                combination.append(bodyText1)
                combination.append(boldCriador)
                combination.append(bodyText2)
                combination.append(boldData)
                
                
                
                
                let fontName = "SFProText-Regular"
                
                
                
                let scaledFont: ScaledFont = {
                    return ScaledFont(fontName: fontName)
                }()
                
                cell.label.font = scaledFont.font(forTextStyle: .body)
                
                
                cell.label.attributedText = combination
                cell.label.adjustsFontForContentSizeCategory = true
                
                cell.bgVview.clipsToBounds = true
                cell.bgVview.layer.cornerRadius = 15
                cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
                cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
                
                cell.bgVview.layer.shadowColor = UIColor.black.cgColor
                cell.bgVview.layer.shadowOpacity = 1
                cell.bgVview.layer.shadowOffset = CGSize.zero
                cell.bgVview.layer.shadowRadius = 5
                
                
            }
            
            return cell
            
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellFeed2", for: indexPath) as! CustomCellFeed
            let formate = DateFormatter()
            formate.dateFormat = "dd-MM-yyyy"
            let formateTime = DateFormatter()
            formateTime.dateFormat = "HH:mm"
            
            switch segmentedControl.selectedSegmentIndex{
                
            case 0:
                print("0")
                //                allPreviously[indexPath.row]
                let fontNameBold = "SFProText-Bold"
                
                let scaledFontBold: ScaledFont = {
                    return ScaledFont(fontName: fontNameBold)
                }()
                
                
                let att = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let boldEvento = NSMutableAttributedString(string: allPreviously[indexPath.row].nomeEvento, attributes: att)
                let boldCriador = NSMutableAttributedString(string: allPreviously[indexPath.row].nomeCriador, attributes: att)
                let boldData = NSMutableAttributedString(string: allPreviously[indexPath.row].dataEvento, attributes: att)
                let boldTime = NSMutableAttributedString(string: formateTime.string(from: allPreviously[indexPath.row].horarioEvento), attributes: att)
                
                
                var bodyText1 = NSMutableAttributedString(string: " foi marcado por ")
                var bodyText2 = NSMutableAttributedString(string: " para o dia ")
                var bodyText3 = NSMutableAttributedString(string: " as ")
                let combination = NSMutableAttributedString()
                
                combination.append(boldEvento)
                combination.append(bodyText1)
                combination.append(boldCriador)
                combination.append(bodyText2)
                combination.append(boldData)
                
                
                
                
                let fontName = "SFProText-Regular"
                
                
                
                let scaledFont: ScaledFont = {
                    return ScaledFont(fontName: fontName)
                }()
                
                cell.label.font = scaledFont.font(forTextStyle: .body)
                
                
                cell.label.attributedText = combination
                cell.label.adjustsFontForContentSizeCategory = true
                
                cell.bgVview.clipsToBounds = true
                cell.bgVview.layer.cornerRadius = 15
                cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
                cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
                
                
                
                
            default:
                print("1")
                //                minePreviously[indexPath.row]
                let fontNameBold = "SFProText-Bold"
                
                let scaledFontBold: ScaledFont = {
                    return ScaledFont(fontName: fontNameBold)
                }()
                
                
                let att = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
                let boldEvento = NSMutableAttributedString(string: minePreviously[indexPath.row].nomeEvento, attributes: att)
                let boldCriador = NSMutableAttributedString(string: minePreviously[indexPath.row].nomeCriador, attributes: att)
                let boldData = NSMutableAttributedString(string: minePreviously[indexPath.row].dataEvento, attributes: att)
                let boldTime = NSMutableAttributedString(string: formateTime.string(from: minePreviously[indexPath.row].horarioEvento), attributes: att)
                
                
                var bodyText1 = NSMutableAttributedString(string: " foi marcado por ")
                var bodyText2 = NSMutableAttributedString(string: " para o dia ")
                var bodyText3 = NSMutableAttributedString(string: " as ")
                let combination = NSMutableAttributedString()
                
                combination.append(boldEvento)
                combination.append(bodyText1)
                combination.append(boldCriador)
                combination.append(bodyText2)
                combination.append(boldData)
                
                
                
                
                let fontName = "SFProText-Regular"
                
                
                
                let scaledFont: ScaledFont = {
                    return ScaledFont(fontName: fontName)
                }()
                
                cell.label.font = scaledFont.font(forTextStyle: .body)
                
                
                cell.label.attributedText = combination
                cell.label.adjustsFontForContentSizeCategory = true
                
                cell.bgVview.clipsToBounds = true
                cell.bgVview.layer.cornerRadius = 15
                cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
                cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
                
                cell.bgVview.layer.shadowColor = UIColor.black.cgColor
                cell.bgVview.layer.shadowOpacity = 1
                cell.bgVview.layer.shadowOffset = CGSize.zero
                cell.bgVview.layer.shadowRadius = 5
                
                
            }
            
            return cell
        }
        
        
        
        
        /*
         if indexPath.section == 0{
         let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellFeed2", for: indexPath) as! CustomCellFeed
         let formate = DateFormatter()
         formate.dateFormat = "dd-MM-yyyy"
         
         let formateTime = DateFormatter()
         formateTime.dateFormat = "HH:mm"
         
         print("indexpath", indexPath.row)
         
         if formate.string(from: Date()) == myPeople[indexPath.row].dataEvento{
         switch segmentedControl.selectedSegmentIndex {
         case 1:
         print("1")
         if myPeople[indexPath.row].reponsaveis.contains(UserLoaded().getUserName()){
         
         let fontNameBold = "SFProText-Bold"
         
         let scaledFontBold: ScaledFont = {
         return ScaledFont(fontName: fontNameBold)
         }()
         
         
         let att = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
         let boldEvento = NSMutableAttributedString(string: myPeople[indexPath.row].nomeEvento, attributes: att)
         let boldCriador = NSMutableAttributedString(string: myPeople[indexPath.row].nomeCriador, attributes: att)
         let boldData = NSMutableAttributedString(string: myPeople[indexPath.row].dataEvento, attributes: att)
         
         let boldTime = NSMutableAttributedString(string: formateTime.string(from: myPeople[indexPath.row].horarioEvento), attributes: att)
         
         var bodyText1 = NSMutableAttributedString(string: NSLocalizedString("was set by", comment: ""))
         var bodyText2 = NSMutableAttributedString(string: NSLocalizedString("to day", comment: ""))
         var bodyText3 = NSMutableAttributedString(string: " as ")
         let combination = NSMutableAttributedString()
         
         combination.append(boldEvento)
         combination.append(bodyText1)
         combination.append(boldCriador)
         combination.append(bodyText2)
         combination.append(boldData)
         //                        combination.append(bodyText3)
         //                        combination.append(boldTime)
         
         
         
         
         let fontName = "SFProText-Regular"
         
         
         
         let scaledFont: ScaledFont = {
         return ScaledFont(fontName: fontName)
         }()
         
         cell.label.font = scaledFont.font(forTextStyle: .body)
         
         
         cell.label.attributedText = combination
         cell.label.adjustsFontForContentSizeCategory = true
         
         cell.bgVview.clipsToBounds = true
         cell.bgVview.layer.cornerRadius = 15
         cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
         cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
         
         }
         
         default:
         print("0")
         
         let att = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
         let boldEvento = NSMutableAttributedString(string: myPeople[indexPath.row].nomeEvento, attributes: att)
         let boldCriador = NSMutableAttributedString(string: myPeople[indexPath.row].nomeCriador, attributes: att)
         let boldData = NSMutableAttributedString(string: myPeople[indexPath.row].dataEvento, attributes: att)
         let boldTime = NSMutableAttributedString(string: formateTime.string(from: myPeople[indexPath.row].horarioEvento), attributes: att)
         
         var bodyText1 = NSMutableAttributedString(string: " foi marcado por ")
         var bodyText2 = NSMutableAttributedString(string: " para o dia ")
         var bodyText3 = NSMutableAttributedString(string: " as ")
         let combination = NSMutableAttributedString()
         
         combination.append(boldEvento)
         combination.append(bodyText1)
         combination.append(boldCriador)
         combination.append(bodyText2)
         combination.append(boldData)
         //                    combination.append(bodyText3)
         //                    combination.append(boldTime)
         
         let fontName = "SFProText-Regular"
         
         let scaledFont: ScaledFont = {
         return ScaledFont(fontName: fontName)
         }()
         
         
         
         cell.label.font = scaledFont.font(forTextStyle: .body)
         cell.label.adjustsFontForContentSizeCategory = true
         
         cell.label.attributedText = combination
         
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
         
         let formateTime = DateFormatter()
         formateTime.dateFormat = "HH:mm"
         
         print("indexpath", indexPath.row)
         
         if formate.string(from: Date()) == myPeople[indexPath.row].dataEvento{
         
         switch segmentedControl.selectedSegmentIndex {
         case 1:
         print("1")
         
         if myPeople[indexPath.row].reponsaveis.contains(UserLoaded().getUserName()){
         
         let att = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
         let boldEvento = NSMutableAttributedString(string: myPeople[indexPath.row].nomeEvento, attributes: att)
         let boldCriador = NSMutableAttributedString(string: myPeople[indexPath.row].nomeCriador, attributes: att)
         let boldData = NSMutableAttributedString(string: myPeople[indexPath.row].dataEvento, attributes: att)
         let boldTime = NSMutableAttributedString(string: formateTime.string(from: myPeople[indexPath.row].horarioEvento), attributes: att)
         
         var bodyText1 = NSMutableAttributedString(string: " foi marcado por ")
         var bodyText2 = NSMutableAttributedString(string: " para o dia ")
         var bodyText3 = NSMutableAttributedString(string: " as ")
         let combination = NSMutableAttributedString()
         
         combination.append(boldEvento)
         combination.append(bodyText1)
         combination.append(boldCriador)
         combination.append(bodyText2)
         combination.append(boldData)
         //                        combination.append(bodyText3)
         //                        combination.append(boldTime)
         
         
         let fontName = "SFProText-Regular"
         
         let scaledFont: ScaledFont = {
         return ScaledFont(fontName: fontName)
         }()
         
         
         cell.label.font = scaledFont.font(forTextStyle: .body)
         cell.label.adjustsFontForContentSizeCategory = true
         
         cell.label.attributedText = combination
         
         cell.bgVview.clipsToBounds = true
         cell.bgVview.layer.cornerRadius = 15
         cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
         cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
         
         }
         default:
         print("0")
         
         let att = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
         let boldEvento = NSMutableAttributedString(string: myPeople[indexPath.row].nomeEvento, attributes: att)
         let boldCriador = NSMutableAttributedString(string: myPeople[indexPath.row].nomeCriador, attributes: att)
         let boldData = NSMutableAttributedString(string: myPeople[indexPath.row].dataEvento, attributes: att)
         let boldTime = NSMutableAttributedString(string: formateTime.string(from: myPeople[indexPath.row].horarioEvento), attributes: att)
         
         var bodyText1 = NSMutableAttributedString(string: " foi marcado por ")
         var bodyText2 = NSMutableAttributedString(string: " para o dia ")
         var bodyText3 = NSMutableAttributedString(string: " as ")
         let combination = NSMutableAttributedString()
         
         combination.append(boldEvento)
         combination.append(bodyText1)
         combination.append(boldCriador)
         combination.append(bodyText2)
         combination.append(boldData)
         //                    combination.append(bodyText3)
         //                    combination.append(boldTime)
         
         let fontName = "SFProText-Regular"
         
         let scaledFont: ScaledFont = {
         return ScaledFont(fontName: fontName)
         }()
         
         
         cell.label.font = scaledFont.font(forTextStyle: .body)
         cell.label.adjustsFontForContentSizeCategory = true
         
         cell.label.attributedText = combination
         
         cell.bgVview.clipsToBounds = true
         cell.bgVview.layer.cornerRadius = 15
         cell.imageFoto.image = self.getFotoCriador(idCriador: myPeople[indexPath.row].idCriador)
         cell.imageFoto.layer.cornerRadius = cell.imageFoto.frame.height/2
         }
         
         }
         return cell
         }
         */
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
    
    func colorWithGradient(colors: [UIColor]) -> UIColor {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.locations = [0.1, 0.9]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        let cgColors = colors.map({$0.cgColor})
        
        gradientLayer.colors = cgColors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: backgroundColorImage!)
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
