//
//  CalendarioViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 20/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

let screenSize = UIScreen.main.bounds


struct eventStruct{
    var titulos = [""]
    var horarios = [""]
    var descricao = [""]
    var categorias = [""]
    var repeatt = [""]
    var localization = [""]
    var responsavel = [""]
}

class CalendarioViewController: UIViewController, TaskViewControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var createTaskOutlet: UIBarButtonItem!
    
    
    
    fileprivate lazy var dateFormatter : DateFormatter =  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    
    
    
    var eventAux = eventStruct()
    var auxDate = Date()
    
    
    var dates = [String]()
    
    var days = [Days]()
    var events = [Events]()
    
    var canPass = true
    
    
    
    
    
    var auxText : String = "" {
        didSet{
            reloadAll()
        }
    }
    var auxLocal : String?
    var auxCateg : String?
    var auxTime : String?
    var auxRepetir : String?
    var auxResponsavel : String?
    var auxLembrete : String?
    var auxDescricao : String?
    
    var auxDiaSemanaNum : Int? {
        didSet{
            switch (auxDiaSemanaNum){
            case 1:
                auxDiaSemana = "Domingo"
            case 2:
                auxDiaSemana = "Segunda"
            case 3:
                auxDiaSemana = "Terca"
            case 4:
                auxDiaSemana = "Quarta"
            case 5:
                auxDiaSemana = "Quinta"
            case 6:
                auxDiaSemana = "Sexta"
            default:
                auxDiaSemana = "Sabado"
            }
        }
    }
    
    var auxDiaSemana : String?
    var auxDia : Int?
    
    var auxMesNum : Int?{
        didSet{
            switch(auxMesNum){
            case 1:
                auxMes = "Janeiro"
            case 2:
                auxMes = "Fevereiro"
            case 3:
                auxMes = "Marco"
            case 4:
                auxMes = "Abril"
            case 5:
                auxMes = "Maio"
            case 6:
                auxMes = "Junho"
            case 7:
                auxMes = "Julho"
            case 8:
                auxMes = "Agosto"
            case 9:
                auxMes = "Setembro"
            case 10:
                auxMes = "Outubro"
            case 11:
                auxMes = "Novembro"
            default:
                auxMes = "Dezembro"
            }
        }
    }
    
    var auxMes : String?
    
    var selectedDay : Date? {
        didSet{
            auxDate = selectedDay!
            auxDiaSemanaNum = Calendar.current.component(.weekday, from: auxDate)
            auxDia = Calendar.current.component(.day, from: auxDate)
            auxMesNum = Calendar.current.component(.month, from: auxDate)
            if let today = calendar.today, selectedDay! < today {
                let alert = UIAlertController(title: "Error", message: "Nao e possivel adicionar tarefas a dias passados", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(alert,animated: true,completion: nil)
            }
            else{
                
                eventAux.titulos.removeAll()
                eventAux.horarios.removeAll()
                eventAux.localization.removeAll()
                eventAux.repeatt.removeAll()
                eventAux.responsavel.removeAll()
                for day in days{
                    if selectedDay == day.day{
                        eventAux.titulos.removeAll()
                        eventAux.horarios.removeAll()
                        for i in 0..<day.event.count{
                            eventAux.titulos.append(day.event[i].title)
                            eventAux.descricao.append(day.event[i].desc)
                            eventAux.horarios.append(day.event[i].time)
                            eventAux.categorias.append(day.event[i].categ)
                            eventAux.repeatt.append(day.event[i].repeatt)
                            eventAux.responsavel.append(day.event[i].responsavel)
                            eventAux.localization.append(day.event[i].localization)
                            
                            
                            
                            
                        }
                    }
                }
                reloadAll()
            }
        }
    }
    
    
    @IBAction func createTask(_ sender: Any) {
        marcarTask()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCalendar()
        reloadAll()
        
        
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTask"{
            if let vc = segue.destination as? TaskViewController{
                vc.delegate = self
                vc.dia = auxDate;
            }
        }
        
        if segue.identifier == "segueDetail"{
            if let vc = segue.destination as? DetailViewController{
                vc.diaAux = "\(auxDia!) de \(auxMes!)"
                vc.diaSemanaAux = auxDiaSemana ?? ""
                vc.horaAux = auxTime ?? ""
                vc.localAux = auxLocal ?? ""
                vc.responsavelAux = auxResponsavel ?? ""
                vc.tituloAux = auxText ?? ""
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
    
    
    
    
    func sendMesage(_ controller: TaskViewController, titulo: String, local: String, categoria: String, hora: String, repetir: String, responsavel: String, descricao: String) {
        auxText = titulo
        auxLocal = local
        auxCateg = categoria
        auxTime = hora
        auxRepetir = repetir
        auxResponsavel = responsavel
        auxDescricao = descricao
        createEventDay()
    }
    
    func createEventDay(){
        
        
        if let date = calendar!.selectedDate{
            let stringDate = toString(date)
            dates.append(stringDate)
            calendar(calendar, numberOfEventsFor: date)
            
            for dia in days{
                if dia.day == date{
                    canPass = false
                    let event = Events(titleParameter: auxText,timeParameter: auxTime ?? "",descParameter: auxDescricao ?? "" ,categParameter: auxCateg ?? "",repeattParameter: auxRepetir ?? "",responsavelParameter: auxResponsavel ?? "",localizationParameter: auxLocal ?? "aa")
                    dia.event.append(event)
                    events.append(event)
                    eventAux.titulos.append(event.title)
                    eventAux.descricao.append(event.desc)
                    eventAux.horarios.append(event.time)
                    eventAux.categorias.append(event.categ)
                    eventAux.repeatt.append(event.repeatt)
                    eventAux.localization.append(event.localization)
                    eventAux.responsavel.append(event.responsavel)
                    SaveCoreData(titulo: event.title, horario: event.time, dia: stringDate, localizacao: event.localization,responsavel: event.responsavel)
                    
                    
                }
            }
            
            
            if canPass {
                let day = Days(dayParameter: date)
              let event = Events(titleParameter: auxText ?? "",timeParameter: auxTime ?? "",descParameter: auxDescricao ?? "" ,categParameter: auxCateg ?? "",repeattParameter: auxRepetir ?? "",responsavelParameter: auxResponsavel ?? "",localizationParameter: auxLocal ?? "")
                days.append(day)
                day.event.append(event)
                
                
                events.append(event)
                eventAux.titulos.append(event.title)
                eventAux.horarios.append(event.time)
                eventAux.descricao.append(event.desc)
                eventAux.categorias.append(event.categ)
                eventAux.repeatt.append(event.repeatt)
                eventAux.localization.append(event.localization)
                eventAux.responsavel.append(event.responsavel)
                     SaveCoreData(titulo: event.title, horario: event.time, dia: stringDate, localizacao: event.localization,responsavel: event.responsavel)
                
                
                canPass = true
            }
            
            reloadAll()
        }
        
        
        
        
        
    }
    
    func SaveCoreData(titulo: String,horario: String,dia: String,localizacao: String,responsavel: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: "Feed", in: managedContext) else { return}
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(titulo, forKey: "titulo")
        user.setValue(horario, forKey: "horario")
        user.setValue(dia, forKey: "dia")
        user.setValue(localizacao, forKey: "localizacao")
        user.setValue(responsavel, forKey: "responsavel")
       
    }
    
    
    
    func marcarTask(){
        performSegue(withIdentifier: "segueTask", sender: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendar.reloadData()
    }
    
    func reloadAll(){
        
        tableView.reloadData()
    }
    
    
    func toString(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
   
    


    
    
}

extension CalendarioViewController : FSCalendarDataSource{
    
}

extension CalendarioViewController : FSCalendarDelegate {
    
    
}

extension CalendarioViewController{
    
    
    func createCalendar(){
        
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.calendarHeaderView.backgroundColor = UIColor.white
        calendar.calendarWeekdayView.backgroundColor = UIColor.gray
        calendar.appearance.borderRadius = 1
        calendar.appearance.todayColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.6)
        calendar.appearance.eventDefaultColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        view.addSubview(calendar)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDay = date
        
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        var aux = 1
        
        for x in days{
            if x.day == date{
                aux = x.event.count
            }
        }
        
        if self.dates.contains(dateString) {
            return aux
        }
        
        return 0
        
    }
    
    
}

extension CalendarioViewController : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventAux.titulos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCalendar", for: indexPath) as! CellCalendar
        
        let imagem = eventAux.categorias[indexPath.row]
        cell.titulo.text = eventAux.titulos[indexPath.row]
        cell.horario.text = eventAux.horarios[indexPath.row]
      //  cell.imagem.image = UIImage(named: imagem)
        cell.responsavel.text = eventAux.responsavel[indexPath.row]
        cell.location.text = eventAux.localization[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        

    }
    
    
    
    
    
}

