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
    
    let cdr = CoreDataRebased.shared
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var diaDeHoje: UILabel!
    @IBOutlet weak var createTaskOutlet: UIBarButtonItem!
    
    
    fileprivate lazy var dateFormatter : DateFormatter =  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var DailyEvents = [Events]()
    var eventosSalvos = [Evento]()
    var dates = [String]()
    var days = [Days]()
    var indexPathAux = 0
    
    var canPass = true
    
    var auxText : String = "" {
        didSet{
            tableView.reloadData()
        }
    }
    var auxLocal : String?
    var auxCateg : String?
    var auxTime : String?
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
    var DiaSelecionado : Date?
    var eventoSelecionado : Events?
    var DiaHoje : Date?
    var selectedDay : Date? {
        didSet{
            DailyEvents.removeAll()
            DiaSelecionado = selectedDay!
            auxDiaSemanaNum = Calendar.current.component(.weekday, from: DiaSelecionado!)
            auxDia = Calendar.current.component(.day, from: DiaSelecionado!)
            auxMesNum = Calendar.current.component(.month, from: DiaSelecionado!)
            diaDeHoje.text = "\(auxDia!) de \(auxMes!)"
            
            
            
            for day in days{
                if selectedDay == day.day{
                    for i in 0..<day.event.count{
                        DailyEvents.append(day.event[i])
                    }
                }
            }
            tableView.reloadData()
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCalendar()
        tableView.reloadData()
        DiaSelecionado = calendar.today!
        auxDia = Calendar.current.component(.day, from: calendar.today!)
        auxMesNum = Calendar.current.component(.month, from: calendar.today!)
        diaDeHoje.text = "\(auxDia!) de \(auxMes!)"
        
        
        
        fetchAll()
        
        
        
        
    }
    
    func fetchAll(){
        let fetchRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        do{
            let eventos = try managedObjectContext.fetch(fetchRequest)
            for evento in eventos{
                eventosSalvos.append(evento)
            
                
                
            }
        }catch{
            
        }
    }
    
    @IBAction func createTask(_ sender: Any) {
        
        if let today = calendar.today, DiaSelecionado ?? today < today {
            let alert = UIAlertController(title: "Atenção", message: "Não é possível adicionar tarefas a dias passados", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
            self.present(alert,animated: true,completion: nil)
            
            // Deixar opcao escondida
        } else{
            marcarTask()
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTask"{
            if let vc = segue.destination as? TaskViewController{
                vc.delegate = self
                vc.dia = DiaSelecionado ?? calendar.today!
                
            }
        }
        
        if segue.identifier == "segueDetail"{
            
                if let vc = segue.destination as? DetailViewController{
                    
                    auxDia = Calendar.current.component(.day, from: DiaSelecionado ?? selectedDay!)
                    auxMesNum = Calendar.current.component(.month, from: DiaSelecionado ?? selectedDay!)
                   
                    
                    vc.event = DailyEvents[indexPathAux]
                    
                    vc.diaAux = "\(auxDia!) de \(auxMes!)"
    
                    vc.diaSemanaAux = "\(auxDiaSemana!)"
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
        
    }
    
    
    
    
    func sendMesage(_ controller: TaskViewController, titulo: String, local: String, categoria: String, hora: String, responsavel: String, descricao: String) {
        auxText = titulo
        auxLocal = local
        auxCateg = categoria
        auxTime = hora
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
                    let event = Events(titleParameter: auxText,timeParameter: auxTime ?? "",descParameter: auxDescricao ?? "" ,categParameter: auxCateg ?? "",responsavelParameter: auxResponsavel ?? "",localizationParameter: auxLocal ?? "aa")
                    
                    dia.event.append(event)
                    DailyEvents.append(event)
                }
            }
            
            
            if canPass {
                let dia = Days(dayParameter: date)
                let event = Events(titleParameter: auxText ?? "",timeParameter: auxTime ?? "",descParameter: auxDescricao ?? "" ,categParameter: auxCateg ?? "",responsavelParameter: auxResponsavel ?? "",localizationParameter: auxLocal ?? "")
                days.append(dia)
                dia.event.append(event)
                DailyEvents.append(event)
                canPass = true
            }
            
            tableView.reloadData()
        }
    
        
    }
    
    
    
    func marcarTask(){
        performSegue(withIdentifier: "segueTask", sender: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendar.reloadData()
        tableView.reloadData()
        print(eventosSalvos[0].nome)
        print(eventosSalvos[0].categoria)
        
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
        calendar.appearance.todayColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
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
        return eventosSalvos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let horario = Calendar.current.component(.hour, from: eventosSalvos[indexPath.row].horario! as Date)
        let minutos = Calendar.current.component(.minute, from: eventosSalvos[indexPath.row].horario! as Date)
        let segundos = Calendar.current.component(.second, from: eventosSalvos[indexPath.row].horario! as Date)
        
        
        indexPathAux = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCalendar", for: indexPath) as! CellCalendar
        cell.titulo.text = eventosSalvos[indexPath.row].nome
        cell.horario.text = "\(horario):\(minutos):\(segundos)"
        cell.responsavel.text = "\(eventosSalvos[indexPath.row].idUsuarios!)"
        cell.location.text = eventosSalvos[indexPath.row].localizacao
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventoSelecionado = DailyEvents[indexPath.row]
        performSegue(withIdentifier: "segueDetail", sender: self)
        
    }
    
    
    
    
    
}

