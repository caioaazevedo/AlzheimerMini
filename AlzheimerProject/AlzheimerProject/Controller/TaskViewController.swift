//
//  TaskViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 26/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

protocol TaskViewControllerDelegate {
    func sendMesage(_ controller: TaskViewController, titulo: String,local : String,categoria : String,hora : String,repetir: String,responsavel: String,descricao: String)
}

class TaskViewController: UIViewController {
    
    
    let userNotification = Notification()
    
    var delegate: TaskViewControllerDelegate?
    var titulo = ""
    var local = ""
    var categoria = ""
    var hora = ""
    var repetir = ""
    var responsavel = ""
    var lembrete = true
    var descricao = ""
    
    var dia = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fetchData()
        self.view.endEditing(true)
    }
    
    func fetchData(){
        let tableController = self.children.first as? TableViewTaskViewController
        tableController?.tableView.delegate = self
        titulo = tableController?.titulo.text ?? ""
        local = tableController?.local.text ?? ""
        //categoria = tableController?.categoria.image
        hora = tableController?.hora.text ?? ""
        repetir = tableController?.repetir.text ?? ""
        responsavel = tableController?.responsavel.text ?? ""
        lembrete = tableController?.lembrete.isOn ?? true

        
    }
//
//    @IBAction func timeField(_ sender: UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "hh:mm"
//        let outputTime = dateFormatter.string(from: sender.date)
//        hora = outputTime
//    }
//
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        if lembrete{
            let notification = "\(titulo) foi marcado para \(hora) do dia \(dia)"
            userNotification.notificationTask(titulo, hora, notification)
        }
        
        
        delegate?.sendMesage(self,titulo: titulo,local: local,categoria: categoria,hora: hora,repetir: repetir,responsavel: responsavel,descricao: descricao)
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension TaskViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    
    
}
