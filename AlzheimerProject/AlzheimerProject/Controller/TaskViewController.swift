//
//  TaskViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 26/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

protocol TaskViewControllerDelegate {
    func sendMesage(_ controller: TaskViewController, text: String,time : String,desc : String)
}

class TaskViewController: UIViewController {
    
    var delegate: TaskViewControllerDelegate?
    var time : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
   
    
    @IBAction func timeField(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let outputTime = dateFormatter.string(from: sender.date)
        time = outputTime
    }
    
    
    
    
    @IBAction func confirmarBttn(_ sender: UIButton) {
        
        delegate?.sendMesage(self, text: nameField.text ?? "Empty",time: time,desc: descField.text ?? "Empty")
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
   
    
}
