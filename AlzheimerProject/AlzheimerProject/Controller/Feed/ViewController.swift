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
    
    struct Evento: Hashable, Comparable {
        var titulo = ""
        var horario = ""
        var dia = ""
        var localizacao = ""
        var responsavel = ""
        
        // Operator Overloading (Sobrecarga de Operadores)
        static func < (lhs: Evento, rhs: Evento) -> Bool {
            return lhs.horario < rhs.horario
        }
        
    }
    
    var eventos = Set<Evento>()
    
    var eventosOrdenados: [Evento] {
        get {
            return eventos.sorted()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedView.delegate = self
        feedView.dataSource = self
        UserNotification.requestNotificationAuthorization()
        
//        CoreDataRebased.shared.createUsuario(email: "pagodeira.com", fotoDoPerfil: UIImage(named: "Remedio"), Nome: "Pagode")
//        CoreDataRebased.shared.createSala()
        
        
//        UserLoaded()
        
        
        
//        CoreDataRebased.shared.showData()
        
        
    }
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        eventos.removeAll()
        getData()
        feedView.reloadData()
    }
    
    func getData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let titulo = data.value(forKey: "titulo") as! String
                let horario = data.value(forKey: "horario") as! String
                let dia = data.value(forKey: "dia") as! String
                let localizacao = data.value(forKey: "localizacao" ) as! String
                let responsavel = data.value(forKey: "responsavel" ) as! String
                
                
                let evento = Evento(titulo: titulo, horario: horario, dia: dia, localizacao: localizacao,responsavel: responsavel)
                eventos.insert(evento)
                
                feedView.reloadData()
            }
        } catch {
            print("failed")
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFeed", for: indexPath) as! CellFeed
        let indexRow = eventosOrdenados[indexPath.row]
        cell.descricao.text = "\(indexRow.responsavel) marcou  \(indexRow.titulo) para Pedro Paulo em \(indexRow.localizacao) as \(indexRow.horario) no dia \(indexRow.dia) "
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
