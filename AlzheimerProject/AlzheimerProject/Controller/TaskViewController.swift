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
    
    var tableController : TableViewTaskViewController {
        return self.children.first as! TableViewTaskViewController
    }
    
    var delegate: TaskViewControllerDelegate?
    let userNotification = Notification()
    
    var titulo = ""
    var local = ""
    var categoria = ""
    var hora = ""
    var repetir = ""
    var responsavel = ""
    var responsaveis = [String]()
    var lembrete = true
    var descricao = ""
    
    var dia = Date()
    
    let DatePicker = UIDatePicker()
    let ParentPicker = UIDatePicker()
    var toolBar = UIToolbar()
    
    @IBOutlet var viewPresent: ViewPopup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableController.tableView.delegate = self
        let hour = String(Calendar.current.component(.hour, from: Date()))
        let minute = String(Calendar.current.component(.minute, from: Date()))
        tableController.hora.text = "\(hour):\(minute)"
        
    }
    
    @objc func done(){
        
    }
    
    
    
    func createToolBar(){
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:#selector(self.done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.done))
        toolBar.barStyle = UIBarStyle.default
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
    }
    
    
    func createDatePicker(){
        DatePicker.datePickerMode = .time
        tableController.titulo.inputView = DatePicker
        tableController.titulo.inputAccessoryView = toolBar
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let outputTime = dateFormatter.string(from: DatePicker.date)
        tableController.hora.text = outputTime
    }
    
    
    func createParentPicker(){
        viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
        view.addSubview(viewPresent)
        
        UIView.animate(withDuration: 1) {
            self.viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/4,  width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
    }
    
    
    func fetchData(){
        DatePicker.datePickerMode = .time
        tableController.titulo.inputView = DatePicker
        
        titulo = tableController.titulo.text ?? ""
        local = tableController.local.text ?? ""
        //categoria = tableController?.categoria.image
        hora = tableController.hora.text ?? ""
        repetir = tableController.repetir.text ?? ""
        responsavel = tableController.responsavel.text ?? ""
        lembrete = tableController.lembrete.isOn
        
        
        
        
    }
    
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
        switch indexPath.row {
        case 2:
            
            print("Categoria")
            //flexible button
            
        case 3:
            print("Hora")
            createDatePicker()
        case 4:
            print("Repetir")
            print()
        case 5:
            print("Responsavel")
            createParentPicker()
            
        case 6:
            print("Lembrete")
        case 7:
            print("Descricao")
        default:
            view.endEditing(true)
        }
    }
    
    
    
    
    
}

class ViewPopup : UIView, UITableViewDataSource,UITableViewDelegate{
    
    var array = ["Amanda","Caio","Dudu","Gui","Pedro"]
    
    
    
    @IBOutlet weak var tableViewPopup: UITableView!
    
    override func willMove(toWindow newWindow: UIWindow?) {
        tableViewPopup.delegate = self
        tableViewPopup.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRes", for: indexPath) as! CellClass
        cell.textTable.text = array[indexPath.row]
        return cell
    }
    
}

class CellClass : UITableViewCell{
    
    @IBOutlet weak var textTable: UILabel!
    

    
}
