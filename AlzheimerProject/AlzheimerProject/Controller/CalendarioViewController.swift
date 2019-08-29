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



class CalendarioViewController: UIViewController, TaskViewControllerDelegate {
    
    
    @IBOutlet var popover: UIView!
    @IBOutlet weak var imagePopover: UIImageView!
    @IBOutlet weak var labelPopover: UILabel!
    @IBOutlet weak var horarioPopover: UILabel!
    
    
    
    fileprivate weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    var titulos = [""]
    var horarios = [""]
    var descricao = [""]
    var categorias = [""]
    
    
    var dates = [String]()
    
    var days = [Days]()
    var events = [Events]()
    
    var canPass = true
    
    
    
    fileprivate lazy var dateFormatter : DateFormatter =  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var auxDate = Date()
    
    var auxText : String = "" {
        didSet{
            reloadAll()
        }
    }
    
    var auxTime: String = ""{
        didSet{
            reloadAll()
        }
    }
    
    var auxCateg: String = ""{
        didSet{
            reloadAll()
        }
    }
    
    var auxDesc: String = ""{
        didSet{
            reloadAll()
        }
    }
    
    var selectedDay : Date? {
        didSet{
            auxDate = selectedDay!
            if let today = calendar.today, selectedDay! < today {
                createTaskOutlet.isHidden = true
            }
            else{
                createTaskOutlet.isHidden = false
                titulos.removeAll()
                horarios.removeAll()
                for day in days{
                    if selectedDay == day.day{
                        titulos.removeAll()
                        horarios.removeAll()
                        for i in 0..<day.event.count{
                            
                            titulos.append(day.event[i].title)
                            descricao.append(day.event[i].desc)
                            horarios.append(day.event[i].time)
                            categorias.append(day.event[i].categ)
                            
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
                vc.data = auxDate;
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
        popover.removeFromSuperview()
    }
    
    
    
    
    @IBAction func createTask(_ sender: UIButton) {
        marcarTask()
    }
    
    @IBOutlet weak var createTaskOutlet: UIButton!
    
    func createEventDay(){
        
        
        if let date = calendar!.selectedDate{
            let stringDate = toString(date)
            dates.append(stringDate)
            calendar(calendar, numberOfEventsFor: date)
            
            for dia in days{
                if dia.day == date{
                    canPass = false
                    let event = Events(titleParameter: auxText,timeParameter: auxTime,descParameter: auxDesc ,categParameter: auxCateg)
                    dia.event.append(event)
                    events.append(event)
                    titulos.append(event.title)
                    descricao.append(event.desc)
                    horarios.append(event.time)
                    categorias.append(event.categ)
                    
                      SaveCoreData(titulo: event.title, horario: event.time, dia: stringDate, descricao: event.desc)
                    
                    
                }
            }
            
            
            if canPass {
                let day = Days(dayParameter: date)
                let event = Events(titleParameter: auxText,timeParameter: auxTime,descParameter: auxDesc ,categParameter: auxCateg)
                days.append(day)
                day.event.append(event)
                
                
                events.append(event)
    
                titulos.append(event.title)
                horarios.append(event.time)
                descricao.append(event.desc)
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
    
    func sendMesage(_ controller: TaskViewController, text: String,time: String,desc: String) {
        auxText = text
        auxTime = time
        auxDesc = desc
        createEventDay()
    }
    
    
    
}

extension CalendarioViewController : FSCalendarDataSource{
    
}

extension CalendarioViewController : FSCalendarDelegate {
    
    
}

extension CalendarioViewController{
    
    
    func createCalendar(){
        let calendar = FSCalendar(frame: CGRect(x: screenSize.width/8, y: screenSize.height/4, width: 320, height: 300))
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.calendarHeaderView.backgroundColor = UIColor.white
        calendar.calendarWeekdayView.backgroundColor = UIColor.gray
        calendar.appearance.borderRadius = 1
        calendar.appearance.todayColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.6)
        calendar.appearance.eventDefaultColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        view.addSubview(calendar)
        self.calendar = calendar
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
        return titulos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCalendar", for: indexPath) as! CellCalendar
        
        
        cell.titulo.text = titulos[indexPath.row]
        cell.horario.text = horarios[indexPath.row]
        cell.descricao.text = descricao[indexPath.row]
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        popover.center = view.center
        labelPopover.text = auxText
        horarioPopover.text = auxTime
        view.addSubview(popover)
    }
    
    
    
}

