//
//  NotasViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 10/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit


protocol  notasDelegate {
    func sendInfo(_ controller: NotasViewController, texto: String)
    
}

class NotasViewController: UIViewController {
    
    
    var delegate: notasDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Done(_ sender: UIBarButtonItem) {
        delegate?.sendInfo(self, texto: notas.text)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var notas: UITextView!
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
