//
//  ViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 16/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    let UserNotification = Notification()
    
    @IBOutlet weak var feedView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNotification.requestNotificationAuthorization()
        print("öi")
        
        CoreDataBase.shared.createEvent(descricao: <#T##String?#>, categoria: .fun, dia: <#T##Int64#>, horario: <#T##Int64#>, nome: <#T##String#>, participantes: <#T##[UUID]#>)
    }

    
    
    
    
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        switch (segmented.selectedSegmentIndex){
        case 0:
            print("first")
        case 1:
            print("second")
        default:
            print("default")
        }
    }
    
    
    
    
    
    
    
    
    
    @IBAction func button(_ sender: UIButton) {
        UserNotification.notification()
    }
    
   
    
    
    
    
    

}

