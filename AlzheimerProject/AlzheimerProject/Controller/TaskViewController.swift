//
//  TaskViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 26/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

protocol TaskViewControllerDelegate {
    func sendMesage(_ controller: TaskViewController, text: String,time : String,desc : String,categ : String)
}

class TaskViewController: UIViewController {
    
    let userNotification = Notification()
    
    var delegate: TaskViewControllerDelegate?
    var time : String = ""
    var data = Date()
    var auxCateg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
    
    
    @IBAction func categField(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex){
        case 0:
            auxCateg = "1"
        case 1:
            auxCateg = "2"
        case 2:
            auxCateg = "3"
        default:
            auxCateg = "4"
        }
        
    }
    
    
    @IBAction func timeField(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let outputTime = dateFormatter.string(from: sender.date)
        time = outputTime
    }
    
    
    
    
    @IBAction func confirmarBttn(_ sender: UIButton) {
        
        let descricaoNotificacao = "\(nameField.text) foi marcado para \(time) do dia \(data)"
        
        delegate?.sendMesage(self, text: nameField.text ?? "Empty",time: time,desc: descField.text ?? "Empty",categ: auxCateg)
        userNotification.notificationTask(nameField.text ?? "Notification", time, descricaoNotificacao)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
   
    
}
