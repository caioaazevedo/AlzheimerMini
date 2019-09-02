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
}

class CalendarioViewController: UIViewController, TaskViewControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    
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
    
    
    var selectedDay : Date? {
        didSet{
            auxDate = selectedDay!
            if let today = calendar.today, selectedDay! < today {
                let alert = UIAlertController(title: "Error", message: "Nao e possivel adicionar tarefas a dias passados", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                self.present(alert,animated: true,completion: nil)
            }
            else{
                
                eventAux.titulos.removeAll()
                eventAux.horarios.removeAll()
                for day in days{
                    if selectedDay == day.day{
                        eventAux.titulos.removeAll()
                        eventAux.horarios.removeAll()
                        for i in 0..<day.event.count{
                            
                            eventAux.titulos.append(day.event[i].title)
                            eventAux.descricao.append(day.event[i].desc)
                            eventAux.horarios.append(day.event[i].time)
                            eventAux.categorias.append(day.event[i].categ)
                            
                        }
                    }
                }
                reloadAll()
            }
        }
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
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
    
    
    

    @IBAction func createTask(_ sender: Any) {
         marcarTask()
    }
    
    @IBOutlet weak var createTaskOutlet: UIBarButtonItem!
    
    func createEventDay(){
        
        
        if let date = calendar!.selectedDate{
            let stringDate = toString(date)
            dates.append(stringDate)
            calendar(calendar, numberOfEventsFor: date)
            
            for dia in days{
                if dia.day == date{
                    canPass = false
                    let event = Events(titleParameter: auxText,timeParameter: auxTime!,descParameter: auxDescricao! ,categParameter: auxCateg!)
                    dia.event.append(event)
                    events.append(event)
                    eventAux.titulos.append(event.title)
                    eventAux.descricao.append(event.desc)
                    eventAux.horarios.append(event.time)
                    eventAux.categorias.append(event.categ)
                    eventAux.categorias.append(event.categ)
                    SaveCoreData(titulo: event.title, horario: event.time, dia: stringDate, descricao: event.desc)
                    
                    
                }
            }
            
            
            if canPass {
                let day = Days(dayParameter: date)
                let event = Events(titleParameter: auxText,timeParameter: auxTime!,descParameter: auxDescricao! ,categParameter: auxCateg!)
                days.append(day)
                day.event.append(event)
                
                
                events.append(event)
                
                eventAux.titulos.append(event.title)
                eventAux.horarios.append(event.time)
                eventAux.descricao.append(event.desc)
                eventAux.categorias.append(event.categ)
                SaveCoreData(titulo: event.title, horario: event.time, dia: stringDate, descricao: event.desc)
                
                
                canPass = true
            }
            
            reloadAll()
        }
        
        
        
        
        
    }
    
    func SaveCoreData(titulo: String,horario: String,dia: String,descricao: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: "Feed", in: managedContext) else { return}
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(titulo, forKey: "titulo")
        user.setValue(horario, forKey: "horario")
        user.setValue(dia, forKey: "dia")
        user.setValue(descricao, forKey: "descricao")
        
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
        cell.descricao.text = eventAux.descricao[indexPath.row]
        cell.imagem.image = UIImage(named: imagem)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    
}

