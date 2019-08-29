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
        
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        <#code#>
    }
    
    
    
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
       
    }
    
    
    
    
    
    
    
    
    
    @IBAction func button(_ sender: UIButton) {
        UserNotification.notification()
    }
    
   
    
    
    
    
    

}

