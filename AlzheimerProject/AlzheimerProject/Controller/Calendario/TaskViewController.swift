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



//protocol PreviousTaskViewController {
//    func eventUpdated(event: Events)
//}

class TaskViewController: UIViewController, ViewPopupDelegate , notasDelegate, sendRespDelegate, removeRespDelegate {
   
    @IBOutlet weak var titulo2: UILabel!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var localTextField: UITextField!
    
   // var previousController: PreviousTaskViewController?
    var detailViewControllerDelegate : DetailViewControllerDelegate?
  //  var eventUpdatedCallback: ((Events) -> Void)?
    
    var userLoad = UserLoaded()
    
    var pessoas = [String]()
    var pessoasIds = [String]()
    var images = [UIImage]()
    
    var tableController : TableViewTaskViewController {
        return self.children.first as! TableViewTaskViewController
    }
    
    let cdr = CoreDataRebased.shared
    // updateSala -> arrayUsuariospresentes -> nuvem pessoas -> pegar dados pessoas -> armazenar
    
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
    
    var pessoasResponsaveis = [String]()
    var bolaAzul = UIImage(named: "bola azul")
    var bolaAmarela = UIImage(named: "bola amarela")
    var bolaRosa = UIImage(named: "bola rosa")
    var bolaRoxa = UIImage(named: "bola roxa")
    var bolaVermelha = UIImage(named: "bola vermelha")
    
    @IBOutlet var viewPresent: ViewPopup!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Cloud.getPeople {
                self.getIds()
        }
        
        tituloTextField.setBottomBorder()
        
        tableController.tableView.delegate = self
        viewPresent.delegateSend = self
        viewPresent.sendResponsavel = self
        viewPresent.removeResponsavel = self

        print(pessoas)
    }
    
    
    func getIds(){
        let sala = CoreDataRebased.shared.fetchSala()

        var usuarios = (sala.idUsuarios as! NSArray).mutableCopy() as! [String]

        for user in usuarios {

            for i in 0...ckData.count - 1 {
                if ckData[i].0 == user {
                    // ID
                    pessoasIds.append(ckData[i].0)
                    // Nome
                    pessoas.append(ckData[i].1)
                    // Foto
                    let image = UIImage(data: ckData[i].2)
                    images.append(image!)
                }
            }
        }
    }
    
    
    
    @objc func done(){
        
    }
    
    var auxTitulo = String()
    var auxCateg = String()
    
    var auxdataEdit = Date()
    
    var circle : SHCircleBarController {
        return self.children.first as! SHCircleBarController
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.localTextField.placeholder = NSLocalizedString("TextFieldLocal", comment: "")
        self.tituloTextField.placeholder = NSLocalizedString("TextFieldTitle", comment: "")
        
        Cloud.setupCloudKitNotifications()
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = true
            vc.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        if willEditing{
            
            
            tableController.hora.text = event?.time
            var string: String?
            for element in event!.responsavel {
                if string == nil {
                    string = element
                } else {
                    string = string! + ", " + element
                }
            }
            
            tituloTextField.text = event?.title ?? ""
            localTextField.text = event?.localization ?? ""
         //   tableController.responsavel.text = string
            tableController.descricao.text = event?.desc
            tableController.categoria.text = event?.categ
            var bola = ""
            switch(categoria){
            case NSLocalizedString("Health", comment: ""):
                bola = "bola azul"
            case NSLocalizedString("Recreation",comment: ""):
                bola = "bola roxa"
            case NSLocalizedString("Dentist", comment: ""):
                bola = "bola rosa"
            case NSLocalizedString("Pharmacy", comment: ""):
                bola = "bola amarela"
            default:
                bola = "bola vermelha"
            }
            tableController.bolinha.image = UIImage(named: bola)
            
            //tableController.descricao
        }
        
        tableController.descricao.text = auxNotas
        
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = true
            vc.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        Cloud.getPeople {
            self.tableController.reloadInputViews()
        }
    }
    
    
    
    
    
    
    func createDatePicker(){
        DatePicker.datePickerMode = .time
        
        
        
        
        
        DatePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        DatePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
        self.view.addSubview(DatePicker)
        UIView.animate(withDuration: 0.7) {
            self.DatePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/4,  width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func datePickerChanged(picker: UIDatePicker){
        let df = DateFormatter()
        df.dateFormat = "hh:mm"
        
       // Calendar.current.component(DatePi, from: <#T##Date#>)
        tableController.hora.text = df.string(from: DatePicker.date)
    }
    
    
    
    func createParentPicker(){
        viewPresent.array.removeAll()
        viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        viewPresent.which = "Responsaveis"
        viewPresent.array = pessoas// ADD IMAGES OF USERS
        
        
        for i in 0...ckData.count-1{
            for pessoa in pessoas {
                if ckData[i].1 == pessoa {
                    viewPresent.arrayImage.append(UIImage(data: ckData[i].2)!)
                }
            }
        }
        
        // COLOCAR FOTO DOS INTEGRANTES
        view.addSubview(viewPresent)
        titulo2.text = "Responsável"
        UIView.animate(withDuration: 0.7) {
            self.viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/3,  width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            self.view.layoutIfNeeded()
        }
    }
    
    func createCategoryPicker(){
        viewPresent.array.removeAll()
        viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
        viewPresent.array = [NSLocalizedString("Health", comment: ""),NSLocalizedString("Recreation", comment: ""),NSLocalizedString("Dentist", comment: ""),NSLocalizedString("Pharmacy", comment: ""),NSLocalizedString("Food", comment: "")]
        viewPresent.arrayImage.append(bolaAzul!)
        viewPresent.arrayImage.append(bolaRoxa!)
        viewPresent.arrayImage.append(bolaRosa!)
        viewPresent.arrayImage.append(bolaAmarela!)
        viewPresent.arrayImage.append(bolaVermelha!)
        viewPresent.which = "Categoria"
        view.addSubview(viewPresent)
        titulo2.text = "Categoria"
        
        
        
        UIView.animate(withDuration: 0.7) {
            self.viewPresent.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/3,  width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    var position = 0
    func sendInfo(_ view: ViewPopup, texto: String,which: String,index: Int) {
      
        if which == "Categoria"{
            tableController.categoria.text = texto
            categoria = texto
            
            applyToDef(index: index)
            
            
        }
    }
    
   
    
    func sendResp(_ view: ViewPopup, resp: String) {
        responsaveis.append(resp)
       
        tableController.responsavel.text = "\(responsaveis[0])"
        
        if responsaveis.count > 1{
                tableController.responsavel.text = "\(responsaveis[0]) + \(responsaveis.count - 1)"
        }
       
       
        
    }
    
    func removeResp(_ view: ViewPopup, resp: String){
        responsaveis.removeFirst()
        if responsaveis.count != 0{
        tableController.responsavel.text = "\(responsaveis[0])"
            if responsaveis.count > 1{
                tableController.responsavel.text = "\(responsaveis[0]) + \(responsaveis.count - 1)"
            }
        } else{
            tableController.responsavel.text = ""
        }
    }
    
    
    
    
    func applyToDef(index: Int){
        var bola = ""
        switch (index){
        case 0:
            bola = "bola azul"
        case 1:
            bola = "bola roxa"
        case 2:
            bola = "bola rosa"
        case 3:
            bola = "bola amarela"
        default:
            bola = "bola vermelha"
            
        }
        tableController.bolinha.image = UIImage(named: bola)
    }
    
    
    func fetchEvent(ID: String){

            let fetchRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
            do{
                let eventos = try managedObjectContext.fetch(fetchRequest)
                
                for evento in eventos{
                    if evento.id == ID{
                    eventEntity = evento
                    }
                }
            }catch{
                
            }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.DatePicker.removeFromSuperview()
    }
    
    func fetchEvento(nome: String){
        let fetchRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        do{
            let eventos = try managedObjectContext.fetch(fetchRequest)
            for evento in eventos{
                if evento.nome == nome{
                    eventEntity = evento
                }
            }
        }catch{
            
        }
    }
    
    
    func fetchData(){
        DatePicker.datePickerMode = .time
        
        hora = tableController.hora.text ?? ""
        lembrete = tableController.lembrete.isOn
    }
    
    
    var auxMes = ""
    
    var auxMesNum : Int?{
        didSet{
            switch(auxMesNum){
            case 1:
                auxMes = NSLocalizedString("January", comment: "")
            case 2:
                auxMes = NSLocalizedString("February", comment: "")
            case 3:
                auxMes = NSLocalizedString("March", comment: "")
            case 4:
                auxMes = NSLocalizedString("April", comment: "")
            case 5:
                auxMes = NSLocalizedString("May", comment: "")
            case 6:
                auxMes = NSLocalizedString("June", comment: "")
            case 7:
                auxMes = NSLocalizedString("July", comment: "")
            case 8:
                auxMes = NSLocalizedString("August", comment: "")
            case 9:
                auxMes = NSLocalizedString("September", comment: "")
            case 10:
                auxMes = NSLocalizedString("October", comment: "")
            case 11:
                auxMes = NSLocalizedString("November", comment: "")
            default:
                auxMes = NSLocalizedString("December", comment: "")
            }
        }
    }
    
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        if tableController.hora.text == "" || tituloTextField.text == ""  {
            let alert = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("FillAll", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default, handler: nil))
            self.present(alert,animated: true,completion: nil)
        }
            
            
        else{
            
            
            
            
            if lembrete{
                var tempo = dia.timeIntervalSinceNow
                if tempo < 36000 {
                    tempo = 36000
                }
                print(tempo)
                let diaD = Calendar.current.component(.day, from: dia)
                 auxMesNum = Calendar.current.component(.month, from: dia)
                // FAZER INTERNATIONALIZATION AQUI
                let notification = "An event has been marked \(hora) of day \(diaD) of \(auxMes)"
                userNotification.notificationTask(titulo, hora, notification,tempo: tempo)
                
            }
            
            
            fetchData()
            
            
            
            
            
            
            if willEditing{
                fetchEvent(ID: event!.ID)
                let df = DateFormatter()
                df.dateFormat = "hh:mm"
                
                let data = df.string(from: Date())
                let date = df.date(from: data)
                let auxDataEdit = eventEntity?.dia as! Date
                let eventoEnviar = Events(titleParameter: tituloTextField.text ?? "", timeParameter: data, descParameter: descricao, categParameter: categoria, responsavelParameter: responsaveis, localizationParameter: localTextField.text!, idParameter: "")
                
               // delegateDetail?.sendMessageDetail(self, evento: eventoEnviar)
                // previousController?.eventUpdated(event: eventoEnviar)
              //  eventUpdatedCallback?(eventoEnviar)
                detailViewControllerDelegate?.updateEvent(eventoEnviar)
                CoreDataRebased.shared.updateEvent(evento: eventEntity!, categoria: categoria, descricao: auxNotas, dia: auxDataEdit, horario: date ?? DatePicker.date, nome: tituloTextField.text ?? "", responsaveis: responsaveis,localizacao: localTextField.text!)
                
            }
            else{
                let df = DateFormatter()
                df.dateFormat = "hh:mm"
                
                let data = df.string(from: DatePicker.date)
                let date = df.date(from: data)
                
                CoreDataRebased.shared.createEvent(categoria: categoria, descricao: auxNotas, dia: dia, horario: date ?? DatePicker.date, responsaveis: responsaveis, nome:tituloTextField.text ?? "" , localizacao: localTextField.text ?? "", nomeCriador: userLoad.nomeUser! )
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
            createCategoryPicker()
        case 1:
            createDatePicker()
        case 2:
            createParentPicker()
            
        case 3:
            print("Lembrete")
        case 4:
            performSegue(withIdentifier: "segueNotas", sender: self)
        default:
            view.endEditing(true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueNotas"{
            if let dest = segue.destination as? NotasViewController{
                dest.delegate = self
                dest.notasTexto = auxNotas
            }
        }
    }
    
    
    
}


protocol  ViewPopupDelegate {
    func sendInfo(_ view: ViewPopup, texto: String,which: String,index: Int)
}

protocol sendRespDelegate{
    func sendResp(_ view: ViewPopup,resp: String)
}

protocol removeRespDelegate{
    func removeResp(_ view: ViewPopup,resp: String)
}

class ViewPopup : UIView, UITableViewDataSource,UITableViewDelegate{
    
    var array = [""]
    var arrayImage = [UIImage]()
    var pessoas = [Pessoas]()
    var delegateSend: ViewPopupDelegate?
    var sendResponsavel: sendRespDelegate?
    var removeResponsavel: removeRespDelegate?
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
        
        if arrayImage.count > 0 {
            cell.imagemResponsavel.image = arrayImage[indexPath.row]
            cell.imagemResponsavel.layer.cornerRadius = cell.imagemResponsavel.frame.width/2
        }
        
        
        
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.endEditing(true)
        let cell = tableView.cellForRow(at: indexPath) as! CellClass
        
        if which == "Responsaveis"{
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                removeResponsavel?.removeResp(self, resp: array[indexPath.row])
                
            }else{
                cell.accessoryType = .checkmark
                sendResponsavel?.sendResp(self, resp: array[indexPath.row])
            }
            
            
        }
        

        
        
        delegateSend?.sendInfo(self, texto: array[indexPath.row],which : which,index: indexPath.row)
        aux = indexPath.row
        
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
}

class CellClass : UITableViewCell{
    
    @IBOutlet weak var textTable: UILabel!
    
    @IBOutlet weak var imagemResponsavel: UIImageView!
    
    var id : String?
    var selecionado : Bool?
    
}
