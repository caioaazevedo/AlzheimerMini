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
    @IBOutlet weak var navBar: UINavigationItem!
    
    
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
                auxDiaSemana = NSLocalizedString("Sunday", comment: "")
            case 2:
                auxDiaSemana = NSLocalizedString("Monday", comment: "")
            case 3:
                auxDiaSemana = NSLocalizedString("Tuesday", comment: "")
            case 4:
                auxDiaSemana = NSLocalizedString("Wednesday", comment: "")
            case 5:
                auxDiaSemana = NSLocalizedString("Thursday", comment: "")
            case 6:
                auxDiaSemana = NSLocalizedString("Friday", comment: "")
            default:
                auxDiaSemana = NSLocalizedString("Saturday", comment: "")
            }
        }
    }
    
    var auxDiaSemana : String?
    var auxDia : Int?
    
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
            
            diaDeHoje.text = String("\(auxDia!) \(NSLocalizedString("of", comment: "")) \(auxMes!)").uppercased()
            
            
            let diaSelecionadoEvento = Calendar.current.component(.day, from: DiaSelecionado!)
            let mesSelecionadoEvento = Calendar.current.component(.month, from: DiaSelecionado!)
            
            
            for evento in eventosSalvos{
                if evento.dia != nil{
                    var responsaveis = [String]()
                    let diaEvento = Calendar.current.component(.day,from: evento.dia! as Date)
                    let mesEvento = Calendar.current.component(.month,from: evento.dia! as Date)
                    if diaSelecionadoEvento == diaEvento && mesEvento == mesSelecionadoEvento{
                        
                        let df = DateFormatter()
                        df.dateFormat = "hh:mm"
                        let data = df.string(from: evento.horario! as Date)
                        
                        
                        if evento.idUsuarios != nil{
                         responsaveis = (evento.idUsuarios as! NSArray).mutableCopy() as! [String]
                    
                        }
                        let evento = Events(titleParameter: evento.nome!, timeParameter: data, descParameter: evento.descricao ?? "", categParameter: evento.categoria ?? "", responsavelParameter: responsaveis ?? [""], localizationParameter: evento.localizacao ?? "",idParameter: evento.id!)
                        
                        DailyEvents.append(evento)
                        
                    }
                }}
            
            tableView.reloadData()
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        Cloud.getPeople()
        
        let sala = CoreDataRebased.shared.fetchSala()
        
        
        self.navBar.title = sala.nomeFamilia
        
        createCalendar()
        
        tableView.reloadData()
        tableView.backgroundColor = view.backgroundColor
        
        if DiaSelecionado == nil{
            DiaSelecionado = calendar.today!
        }
        auxDia = Calendar.current.component(.day, from: calendar.today!)
        auxMesNum = Calendar.current.component(.month, from: calendar.today!)
        
     //   calendar.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        //calendar.appearance.eventDefaultColor
        
        let fontName = "SFProText-Regular"
        
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        
        diaDeHoje.font = scaledFont.font(forTextStyle: .body)
        diaDeHoje.adjustsFontForContentSizeCategory = true
        
        
        diaDeHoje.text = "\(auxMes!) \(auxDia!)"
        
        fetchAll()
        //        Cloud.getPeople()
        
        //Refresh
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
//        Refresh
        CoreDataRebased.shared.deleteAllEvents()
        Cloud.updateCalendario { (result) in
            Cloud.updateAllEvents(completion: { (t) in
                self.fetchAll()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.calendar.reloadData()
                    refreshControl.endRefreshing()
                    self.selectedDay = self.DiaSelecionado
                }

            })

        //        Cloud.getPeople()
    }
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
            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 2, animations: {
                    refreshControl.endRefreshing()
                }, completion: { (k) in
                    self.tableView.reloadData()
                })
            }
           
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
            let alert = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("PassedDays", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default, handler: nil))
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
                    
                    // enum apply
                case NSLocalizedString("Health",comment: ""):
                    cor  = .init(red: 0.68, green: 0.84, blue: 0.89, alpha: 1)
                    corOutro = cor
                case NSLocalizedString("Recreation" , comment: ""):
                    cor = .init(red: 0.70, green: 0.72, blue: 0.89, alpha: 1)
                case NSLocalizedString("Dentist" , comment: ""):
                    cor = .init(red: 0.87, green: 0.62, blue: 0.77, alpha: 1)
                case NSLocalizedString("Pharmacy" , comment: ""):
                    cor = .init(red: 0.93, green: 0.65, blue: 0.34, alpha: 1)
                    corOutro = cor
                default:
                   cor = .init(red: 0.67, green: 0.85, blue: 0.74, alpha: 1)
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
        case NSLocalizedString("Health",comment: ""):
            cor  = .init(red: 0.68, green: 0.84, blue: 0.89, alpha: 1)
        case NSLocalizedString("Recreation",comment: ""):
            cor = .init(red: 0.70, green: 0.72, blue: 0.89, alpha: 1)
        case NSLocalizedString("Dentist",comment: ""):
            cor = .init(red: 0.87, green: 0.62, blue: 0.77, alpha: 1)
        case NSLocalizedString("Pharmacy",comment: ""):
            cor = .init(red: 0.93, green: 0.65, blue: 0.34, alpha: 1)
        default:
                   cor = .init(red: 0.67, green: 0.85, blue: 0.74, alpha: 1)
        }
        return cor
    }
    
    func defineColor2(_ categoria: String) -> UIColor{
        var cor = UIColor()
        switch(categoria){
        case NSLocalizedString("Health",comment: ""):
            cor  = .init(red: 0.28, green: 0.54, blue: 0.62, alpha: 1)
        case NSLocalizedString("Recreation",comment: ""):
            cor = .init(red: 0.30, green: 0.35, blue: 0.61, alpha: 1)
        case NSLocalizedString("Dentist",comment: ""):
            cor = .init(red: 0.57, green: 0.23, blue: 0.43, alpha: 1)
        case NSLocalizedString("Pharmacy",comment: ""):
            cor = .init(red: 0.54, green: 0.39, blue: 0.23, alpha: 1)
        default:
            cor = .init(red: 0.09, green: 0.46, blue: 0.30, alpha: 1)
        }
        return cor
        
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = .none
        
        return DailyEvents.count;
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let fontName = "SFProText-Bold"
        
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        indexPathAux = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCalendar", for: indexPath) as! CellCalendar
//        cell.clipsToBounds = true
//        cell.layer.cornerRadius = 10
        
        let categoria = DailyEvents[indexPath.row].categ
        
        var string: String?
        
        for element in DailyEvents[indexPath.row].responsavel {
            if string == nil {
                string = element
            } else {
                string = string! + ", " + element
            }
        }
        
        cell.bgCalendarCellView.clipsToBounds = true
        cell.bgCalendarCellView.layer.cornerRadius = 10
        
        
        cell.backgroundColor = view.backgroundColor
        
        
//        cell.backgroundColor = defineColor(categoria)
      
        cell.titulo.text = DailyEvents[indexPath.row].title
        cell.titulo.textColor = defineColor2(categoria)
        cell.horario.textColor = defineColor2(categoria)
        cell.responsavel.textColor = defineColor2(categoria)
        cell.location.textColor = defineColor2(categoria)
        cell.horario.text = DailyEvents[indexPath.row].time
        cell.bgCalendarCellView.backgroundColor = defineColor(categoria)
       
        cell.responsavel.text = string
        cell.location.text = DailyEvents[indexPath.row].localization
        
        cell.horario.font = scaledFont.font(forTextStyle: .body)
        cell.horario.adjustsFontForContentSizeCategory = true
        
        cell.responsavel.font = scaledFont.font(forTextStyle: .body)
        cell.responsavel.adjustsFontForContentSizeCategory = true
        
        cell.location.font = scaledFont.font(forTextStyle: .body)
        cell.location.adjustsFontForContentSizeCategory = true
        
        cell.titulo.font = scaledFont.font(forTextStyle: .body)
        cell.titulo.adjustsFontForContentSizeCategory = true
        
        
        
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

