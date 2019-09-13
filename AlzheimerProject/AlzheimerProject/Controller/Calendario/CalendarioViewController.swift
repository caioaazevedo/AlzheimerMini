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
import CircleBar


let screenSize = UIScreen.main.bounds


class CalendarioViewController: UIViewController {
    
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
    
    var eventoDetail : Events?
    
    var auxDiaSemanaNum : Int? {
        didSet{
            switch (auxDiaSemanaNum){
            case 1:
                auxDiaSemana = "Domingo"
            case 2:
                auxDiaSemana = "Segunda"
            case 3:
                auxDiaSemana = "Terça"
            case 4:
                auxDiaSemana = "Quarta"
            case 5:
                auxDiaSemana = "Quinta"
            case 6:
                auxDiaSemana = "Sexta"
            default:
                auxDiaSemana = "Sábado"
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
                auxMes = "Março"
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
            tableView.reloadData()
            DailyEvents.removeAll()
            DiaSelecionado = selectedDay!
            auxDiaSemanaNum = Calendar.current.component(.weekday, from: DiaSelecionado!)
            auxDia = Calendar.current.component(.day, from: DiaSelecionado!)
            auxMesNum = Calendar.current.component(.month, from: DiaSelecionado!)
            diaDeHoje.text = "\(auxDia!) de \(auxMes!)"
            
            
            let diaSelecionadoEvento = Calendar.current.component(.day, from: DiaSelecionado!)
            let mesSelecionadoEvento = Calendar.current.component(.month, from: DiaSelecionado!)
            
            
            for evento in eventosSalvos{
                if evento.dia != nil{
                    let diaEvento = Calendar.current.component(.day,from: evento.dia! as Date)
                    let mesEvento = Calendar.current.component(.month,from: evento.dia! as Date)
                    if diaSelecionadoEvento == diaEvento && mesEvento == mesSelecionadoEvento{
                        let hour = Calendar.current.component(.hour, from: evento.horario! as Date)
                        let minute = Calendar.current.component(.minute, from: evento.horario! as Date)
                        let evento = Events(titleParameter: evento.nome!, timeParameter: "\(hour):\(minute)", descParameter: evento.descricao ?? "", categParameter: evento.categoria ?? "", responsavelParameter: evento.idResponsavel ?? "", localizationParameter: evento.localizacao ?? "")
                        
                        DailyEvents.append(evento)
                        
                    }
                }}
            
            tableView.reloadData()
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        Cloud.getPeople()
        createCalendar()
        
        tableView.reloadData()
        
        if DiaSelecionado == nil{
            DiaSelecionado = calendar.today!
        }
        auxDia = Calendar.current.component(.day, from: calendar.today!)
        auxMesNum = Calendar.current.component(.month, from: calendar.today!)
        
        calendar.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        //calendar.appearance.eventDefaultColor
        
        
        
        
        
        diaDeHoje.text = "\(auxDia!) de \(auxMes!)"
        
        fetchAll()
        //        Cloud.getPeople()
        
        //Refresh
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
        //Refresh
        
        
        //        Cloud.getPeople()
    }
    
    @objc func refreshTable(refreshControl: UIRefreshControl){
        //Adicionar aqui o fetch do cloud para o coreData
        CoreDataRebased.shared.deleteAllEvents()
        Cloud.updateCalendario { (result) in
            Cloud.updateAllEvents(completion: { (t) in
                    self.fetchAll()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                    self.selectedDay = self.DiaSelecionado
                }
                
            })
        }
        
        

        
        
    }
    
    
    
    
    
    
    func fetchAll(){
        let fetchRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        do{
            let eventos = try managedObjectContext.fetch(fetchRequest)
            eventosSalvos.removeAll()
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
                
                vc.dia = DiaSelecionado ?? calendar.today!
                
                
            }
        } else {
            
            if segue.identifier == "segueDetail"{
                
                if let vc = segue.destination as? DetailViewController{
                    
                    auxDia = Calendar.current.component(.day, from: DiaSelecionado ?? selectedDay!)
                    auxMesNum = Calendar.current.component(.month, from: DiaSelecionado ?? selectedDay!)
                    
                    
                    vc.event = eventoDetail!
                    vc.diaAux = "\(auxDia!) de \(auxMes!)"
                    
                    vc.diaSemanaAux = "\(auxDiaSemana!)"
                }
            }
        }
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
        
    }
    
    
    
    
    
    
    
    
    
    
    func marcarTask(){
        performSegue(withIdentifier: "segueTask", sender: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAll()
        calendar.reloadData()
        tableView.reloadData()
        selectedDay = DiaSelecionado
        
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = false
            vc.viewDidLayoutSubviews()
            vc.self.selectedIndex = 1
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        changeMonthName()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        changeMonthName()
    }
    
    
    func changeMonthName(){
        let collectionView = self.calendar.calendarHeaderView.value(forKey: "collectionView") as! UICollectionView
        
        collectionView.visibleCells.forEach { (cell) in
            let c = cell as! FSCalendarHeaderCell
            
            c.titleLabel.text = c.titleLabel.text?.capitalizingFirstLetter()
        }
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

extension CalendarioViewController :    FSCalendarDelegateAppearance{
    
    //
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        var cor = UIColor()
        var corOutro = UIColor.init(red: 0.90, green: 0.42, blue: 0.35, alpha: 1)
        var dia = Calendar.current.component(.day, from: date)
        for x in eventosSalvos{
            var dia2 = Calendar.current.component(.day, from: x.dia! as Date)
            if dia == dia2{
                switch(x.categoria){
                    
                    
                case "Saúde":
                    cor  = .init(red: 0.68, green: 0.84, blue: 0.89, alpha: 1)
                    
                case "Lazer":
                    cor = .init(red: 0.70, green: 0.72, blue: 0.89, alpha: 1)
                case "Dentista":
                    cor = .init(red: 0.87, green: 0.62, blue: 0.77, alpha: 1)
                case "Farmácia":
                    cor = .init(red: 0.93, green: 0.65, blue: 0.34, alpha: 1)
                    corOutro = cor
                default:
                    cor = .init(red: 0.90, green: 0.42, blue: 0.35, alpha: 1)
                }
                return [cor,corOutro]
                
            }
        }
        return nil
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        if date == calendar.today!{
            return .lightGray
        }
        return nil
    }
    
}


extension CalendarioViewController{
    
    
    func createCalendar(){
        
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.calendarHeaderView.backgroundColor = UIColor.white
        //        calendar.appearance.borderRadius = 20
        
        
        
        calendar.clipsToBounds = false
        view.addSubview(calendar)
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDay = date
        
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        var aux = 0
        
        for x in eventosSalvos{
            let rhs = Calendar.current.component(.day,from: x.dia! as Date)
            let lhs = Calendar.current.component(.day,from: date)
            
            let rhsA = Calendar.current.component(.month, from: x.dia! as Date)
            let lhsA = Calendar.current.component(.month, from: date)
            
            if rhs == lhs && rhsA == lhsA{
                aux += 1
                
                
            }
            
            
        }
        
        
        
        return aux
        
        
    }
    
    
    
    
}

extension CalendarioViewController : UITableViewDataSource , UITableViewDelegate{
    
    
    
    func defineColor(_ categoria: String) -> UIColor{
        var cor = UIColor()
        switch(categoria){
        case "Saúde":
            cor  = .init(red: 0.68, green: 0.84, blue: 0.89, alpha: 1)
        case "Lazer":
            cor = .init(red: 0.70, green: 0.72, blue: 0.89, alpha: 1)
        case "Dentista":
            cor = .init(red: 0.87, green: 0.62, blue: 0.77, alpha: 1)
        case "Farmácia":
            cor = .init(red: 0.93, green: 0.65, blue: 0.34, alpha: 1)
        default:
            cor = .init(red: 0.90, green: 0.42, blue: 0.35, alpha: 1)
        }
        return cor
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DailyEvents.count;
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        indexPathAux = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCalendar", for: indexPath) as! CellCalendar
        cell.layer.cornerRadius = 10
        var categoria = DailyEvents[indexPath.row].categ
        
        cell.backgroundColor = defineColor(categoria)
        
        cell.titulo.text = DailyEvents[indexPath.row].title
        cell.horario.text = DailyEvents[indexPath.row].time
        cell.responsavel.text = DailyEvents[indexPath.row].responsavel
        cell.location.text = DailyEvents[indexPath.row].localization
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventoSelecionado = DailyEvents[indexPath.row]
        eventoDetail = DailyEvents[indexPath.row]
        performSegue(withIdentifier: "segueDetail", sender: self)
    }
    
    
    
    
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
