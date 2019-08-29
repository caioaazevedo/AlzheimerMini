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
    
    
    struct eventoStruct {
        var titulo = ""
        var horario = ""
        var dia = ""
        var descricao = ""
    }
    
    var eventoAux = [eventoStruct]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNotification.requestNotificationAuthorization()
        
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        feedView.delegate = self
        feedView.dataSource = self
        getData()
        feedView.reloadData()
    }
    
    
    func getData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Feed")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                
                let titulo = (data.value(forKey: "titulo") as! String)
                let horario = (data.value(forKey: "horario") as! String)
                let dia = (data.value(forKey: "dia") as! String)
                let descricao = (data.value(forKey: "descricao") as! String)
                 eventoAux.append(eventoStruct(titulo: titulo, horario: horario , dia: dia , descricao: descricao))
                feedView.reloadData()
            }
        } catch {
            print("failed")
        }
        
        
        
        
        
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        feedView.reloadData()
        print("segmented")
    }
    
    
    
    
    
    
    
    
    
    @IBAction func button(_ sender: UIButton) {
        UserNotification.notification()
       
    }
    
   
    
    
    
    
    
}

extension ViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFeed", for: indexPath) as! CellFeed
        cell.date.text = eventoAux[indexPath.row].dia
        cell.desc.text = eventoAux[indexPath.row].descricao
        cell.time.text = eventoAux[indexPath.row].horario
        cell.title.text = eventoAux[indexPath.row].titulo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    
    
    
    
    
    
}
