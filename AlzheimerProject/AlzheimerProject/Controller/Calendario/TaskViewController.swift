//
//  TaskViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 26/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import CoreData

protocol TaskViewControllerDelegate {
    func sendMesage(_ controller: TaskViewController, titulo: String,local : String,categoria : String,hora : String,responsavel: String,descricao: String)
}

class TaskViewController: UIViewController, ViewPopupDelegate  {
    
    
    var tableController : TableViewTaskViewController {
        return self.children.first as! TableViewTaskViewController
    }
    
    var delegate: TaskViewControllerDelegate?
    var eventEntity : Evento?
    let userNotification = Notification()
    
    var event : Events?
    
    var titulo = ""
    var local = ""
    var categoria = ""
    var hora = ""
    var responsavel = ""
    var responsaveis = [String]()
    var lembrete = true
    var descricao = ""
    var willEditing = false
    var dia = Date()
    
    let DatePicker = UIDatePicker()
    let ParentPicker = UIDatePicker()
    
    @IBOutlet var viewPresent: ViewPopup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableController.tableView.delegate = self
        viewPresent.delegateSend = self
    }
    
    @objc func done(){
        
    }
    
    var auxTitulo = String()
    var auxCateg = String()
    override func viewWillAppear(_ animated: Bool) {
        if willEditing{
            
            tableController.hora.text = event?.time
            tableController.responsavel.text = event?.responsavel
            tableController.titulo.text = event?.title
            tableController.categoriaLabel.text = event?.categ
            tableController.local.text = event?.localization
            auxTitulo = tableController.titulo.text!
            auxCateg = tableController.categoriaLabel.text!
            
            //tableController.descricao
        }
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
        viewPresent.array = ["Amanda","Caio","Eduardo","Guilherme","Pedro"]
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
        if which == "Categoria" {
            tableController.categoriaLabel.text = texto
        }
        
        
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.DatePicker.removeFromSuperview()
    }
    
    
    func fetchData(){
        DatePicker.datePickerMode = .time
        
        titulo = tableController.titulo.text ?? ""
        local = tableController.local.text ?? ""
        hora = tableController.hora.text ?? ""
        responsavel = tableController.responsavel.text ?? ""
        lembrete = tableController.lembrete.isOn
    }
    
    
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        if tableController.titulo.text == "" || tableController.hora.text == "" || tableController.categoriaLabel.text == "" || tableController.responsavel.text == ""{
            let alert = UIAlertController(title: "Atenção", message: "Por favor, preencha todos os campos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
            self.present(alert,animated: true,completion: nil)
        }
            
            
        else{
            
           
            
            
            if lembrete{
                var tempo = dia.timeIntervalSinceNow
                if tempo < 36000 {
                    tempo = 36000
                }
                print(tempo)
                
                let notification = "\(titulo) foi marcado para \(hora) do dia \(dia)"
                userNotification.notificationTask(titulo, hora, notification,tempo: tempo)
                
            }
            responsaveis.append(responsavel)
            
            fetchData()
            delegate?.sendMesage(self,titulo: titulo,local: local,categoria: categoria,hora: hora,responsavel: responsavel,descricao: descricao)
            
            
          
            
            if willEditing{
                let date = Date()
                CoreDataRebased.shared.updateEvent(auxText: auxTitulo ,auxCateg: categoria, categoria: tableController.categoriaLabel.text!, descricao: tableController.descricao.text!, dia: dia, horario: DatePicker.date, nome: tableController.titulo.text!, responsaveis: responsaveis,localizacao: tableController.local.text!)
                           }
            else{
                  CoreDataRebased.shared.createEvent(categoria: categoria, descricao: descricao, dia: dia, horario: DatePicker.date, responsaveis: responsaveis, nome: titulo)
            }
            
            
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    
    
    
    
}

extension TaskViewController : UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        self.DatePicker.removeFromSuperview()
        self.ParentPicker.removeFromSuperview()
        self.viewPresent.removeFromSuperview()
        switch indexPath.row {
        case 2:
            
            print("Categoria")
            //flexible button
            createCategoryPicker()
            
        case 3:
            print("Hora")
            createDatePicker()
        case 4:
            print("Responsavel")
            createParentPicker()
            
        case 5:
            print("Lembrete")
        case 6:
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
    
    
    
}
