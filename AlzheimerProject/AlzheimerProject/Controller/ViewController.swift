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
        var descricao = ""
        
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
                let descricao = data.value(forKey: "descricao") as! String
                
                let evento = Evento(titulo: titulo, horario: horario, dia: dia, descricao: descricao)
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
    
}

extension ViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFeed", for: indexPath) as! CellFeed
        cell.date.text = eventosOrdenados[indexPath.row].dia
        cell.desc.text = eventosOrdenados[indexPath.row].descricao
        cell.time.text = eventosOrdenados[indexPath.row].horario
        cell.title.text = eventosOrdenados[indexPath.row].titulo

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
