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

class TaskViewController: UIViewController, ViewPopupDelegate  {
    
    
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var localTextField: UITextField!
    
    
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
        
        tituloTextField.setBottomBorder()

        tableController.tableView.delegate = self
        viewPresent.delegateSend = self
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
       
        print(DatePicker.date)
        
        DatePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        DatePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
        self.view.addSubview(DatePicker)
        UIView.animate(withDuration: 1) {
            self.DatePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/4,  width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func datePickerChanged(picker: UIDatePicker){
        let df = DateFormatter()
        df.dateFormat = "hh:mm"
        
        tableController.hora.text = df.string(from: DatePicker.date)
    }
    
    
    func createParentPicker(){
        viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
        viewPresent.array = ["Amanda","Caio","DuDu","Gui","Pedro Paulo"]
        viewPresent.which = "Responsaveis"
        view.addSubview(viewPresent)

        
        UIView.animate(withDuration: 1) {
            self.viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/4,  width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            self.view.layoutIfNeeded()
        }
    }
    
    func createCategoryPicker(){
        viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
        viewPresent.array = ["Medico","Dentista","Passeio","Farmacia","Alimentacao"]
        viewPresent.which = "Categoria"
        view.addSubview(viewPresent)
        
        
        UIView.animate(withDuration: 1) {
            self.viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/4,  width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    func sendInfo(_ view: ViewPopup, texto: String,which: String) {
        if which == "Responsaveis" {
            tableController.responsavel.text = texto
        }
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.DatePicker.removeFromSuperview()
    }
    
    
    func fetchData(){
        DatePicker.datePickerMode = .time

//        titulo = tableController.titulo.text ?? ""
//        local = tableController.local.text ?? ""
        hora = tableController.hora.text ?? ""
        responsavel = tableController.responsavel.text ?? ""
        lembrete = tableController.lembrete.isOn
    }
    

    @IBAction func addTask(_ sender: Any) {
        if lembrete{
            var tempo = dia.timeIntervalSinceNow
            if tempo == 0 {
                tempo += 3600
            }
            print(tempo)
            
            let notification = "\(titulo) foi marcado para \(hora) do dia \(dia)"
            //userNotification.notificationTask(titulo, hora, notification,tempo: tempo)
            
        }
        
        fetchData()
        delegate?.sendMesage(self,titulo: titulo,local: local,categoria: categoria,hora: hora,repetir: repetir,responsavel: responsavel,descricao: descricao)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension TaskViewController : UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        self.DatePicker.removeFromSuperview()
        self.ParentPicker.removeFromSuperview()
        self.viewPresent.removeFromSuperview()
        switch indexPath.row {
        case 0:
            print("Categoria")
            //flexible button
            createCategoryPicker()
            
        case 1:
            print("Hora")
            createDatePicker()
        case 2:
            print("Responsavel")
            createParentPicker()
            
        case 3:
            print("Lembrete")
        case 4:
            print("Descricao")
        default:
            view.endEditing(true)
        }
    }
    
    
    
    
    
}


protocol  ViewPopupDelegate {
    func sendInfo(_ view: ViewPopup, texto: String,which: String)
    
}

class ViewPopup : UIView, UITableViewDataSource,UITableViewDelegate{
    
    var array = [""]
    
    var delegateSend: ViewPopupDelegate?
    var aux = 0
    var which = ""
    @IBOutlet weak var tableViewPopup: UITableView!
    
    override func willMove(toWindow newWindow: UIWindow?) {
        tableViewPopup.delegate = self
        tableViewPopup.dataSource = self
        tableViewPopup.reloadData()
    }
    
    
    @IBAction func Dismiss(_ sender: UIButton) {
        delegateSend?.sendInfo(self, texto: array[aux],which: which)
        
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            self.layoutIfNeeded()
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.removeFromSuperview()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRes", for: indexPath) as! CellClass
        cell.textTable.text = array[indexPath.row]
        //cell.imagemResponsavel.image =
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.endEditing(true)
        delegateSend?.sendInfo(self, texto: array[indexPath.row],which : which)
        aux = indexPath.row
    }
    
}

class CellClass : UITableViewCell{
    
    @IBOutlet weak var textTable: UILabel!
    
    @IBOutlet weak var imagemResponsavel: UIImageView!
    
    
}
