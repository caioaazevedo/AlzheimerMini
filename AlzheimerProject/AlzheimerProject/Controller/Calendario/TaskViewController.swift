//
//  TaskViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 26/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import CoreData
import CircleBar

class TaskViewController: UIViewController, ViewPopupDelegate , notasDelegate {
    
    
    @IBOutlet weak var titulo2: UILabel!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var localTextField: UITextField!
    
    var pessoas = [Pessoas]()
    
    var tableController : TableViewTaskViewController {
        return self.children.first as! TableViewTaskViewController
    }
    
    
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
    
    
    var bolaAzul = UIImage(named: "bola azul")
    var bolaAmarela = UIImage(named: "bola amarela")
    var bolaRosa = UIImage(named: "bola rosa")
    var bolaRoxa = UIImage(named: "bola roxa")
    var bolaVermelha = UIImage(named: "bola vermelha")
    
    @IBOutlet var viewPresent: ViewPopup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tituloTextField.setBottomBorder()
        
        tableController.tableView.delegate = self
        viewPresent.delegateSend = self
        
    }
    
    func fetchPeople(){
        let fetchRequest = NSFetchRequest<Pessoas>.init(entityName: "Pessoas")
        do{
            let people = try managedObjectContext.fetch(fetchRequest)
            pessoas = people
        } catch{
            
        }
    }
    
    @objc func done(){
        
    }
    
    var auxTitulo = String()
    var auxCateg = String()
    
    
    var circle : SHCircleBarController {
        return self.children.first as! SHCircleBarController
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = true
            vc.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        if willEditing{
            
            tableController.hora.text = event?.time
            tableController.responsavel.text = event?.responsavel
            
            //tableController.descricao
        }
        
        tableController.descricao.text = auxNotas
        
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = true
            vc.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
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
        viewPresent.array.removeAll()
        viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        viewPresent.which = "Responsaveis"
        viewPresent.array = ["Saúde","Lazer","Dentista","Farmácia","Alimentaçāo"] // ADD IMAGES OF USERS
        viewPresent.arrayImage.append(bolaAzul!)
        viewPresent.arrayImage.append(bolaRoxa!)
        viewPresent.arrayImage.append(bolaRosa!)
        viewPresent.arrayImage.append(bolaAmarela!)
        viewPresent.arrayImage.append(bolaVermelha!)
        viewPresent.pessoas = pessoas
        view.addSubview(viewPresent)
        titulo2.text = "Responsável"
        UIView.animate(withDuration: 1) {
            self.viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/4,  width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            self.view.layoutIfNeeded()
        }
    }
    
    func createCategoryPicker(){
        viewPresent.array.removeAll()
        viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
        viewPresent.array = ["Saúde","Lazer","Dentista","Farmácia","Alimentaçāo"]
        viewPresent.arrayImage.append(bolaAzul!)
        viewPresent.arrayImage.append(bolaRoxa!)
        viewPresent.arrayImage.append(bolaRosa!)
        viewPresent.arrayImage.append(bolaAmarela!)
        viewPresent.arrayImage.append(bolaVermelha!)
        viewPresent.which = "Categoria"
        view.addSubview(viewPresent)
        titulo2.text = "Categoria"
        
        
        
        UIView.animate(withDuration: 1) {
            self.viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/4,  width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    var position = 0
    func sendInfo(_ view: ViewPopup, texto: String,which: String) {
        if which == "Responsaveis" {
            tableController.responsavel.text = texto
        }
        if which == "Categoria"{
            tableController.categoriaLabel.text = texto
            categoria = texto
        }
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.DatePicker.removeFromSuperview()
    }
    
    
    func fetchData(){
        DatePicker.datePickerMode = .time
        
        hora = tableController.hora.text ?? ""
        lembrete = tableController.lembrete.isOn
    }
    
    
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        if tableController.hora.text == "" || tituloTextField.text == ""  {
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
            
            
            
            
            
            
            if willEditing{
                let date = Date()
                CoreDataRebased.shared.updateEvent(evento: eventEntity!, categoria: categoria, descricao: auxNotas, dia: dia, horario: DatePicker.date, nome: tituloTextField.text ?? "", responsaveis: responsaveis)
            }
            else{
                CoreDataRebased.shared.createEvent(categoria: categoria, descricao: auxNotas, dia: dia, horario: DatePicker.date, responsaveis: responsaveis, nome:tituloTextField.text ?? "" , localizacao: localTextField.text ?? "" )
            }
            
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    var auxNotas = ""
    func sendInfo(_ controller: NotasViewController, texto: String) {
        auxNotas = texto
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
            performSegue(withIdentifier: "segueNotas", sender: self)
        default:
            view.endEditing(true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueNotas"{
            if let dest = segue.destination as? NotasViewController{
                dest.delegate = self
            }
        }
    }
    
    
    
}


protocol  ViewPopupDelegate {
    func sendInfo(_ view: ViewPopup, texto: String,which: String)
    
}

class ViewPopup : UIView, UITableViewDataSource,UITableViewDelegate{
    
    var array = [""]
    var arrayImage = [UIImage]()
    var pessoas = [Pessoas]()
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
        
        cell.imagemResponsavel.image = arrayImage[indexPath.row]
        
        
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.endEditing(true)
        let cell = tableView.cellForRow(at: indexPath) as! CellClass
        
        if indexPath.row == 2{
            
git c            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                pessoas[indexPath.row].selecionado = false
                
            }else{
                cell.accessoryType = .checkmark
                pessoas[indexPath.row].selecionado = true
                array[indexPath.row] = pessoas[indexPath.row].id!
            }
            
        }
        
        delegateSend?.sendInfo(self, texto: array[indexPath.row],which : which)
        aux = indexPath.row
        
    }
    
    
    
}

class CellClass : UITableViewCell{
    
    @IBOutlet weak var textTable: UILabel!
    
    @IBOutlet weak var imagemResponsavel: UIImageView!
    
    var id : String?
    var selecionado : Bool?
    
}
