//
//  CoreData.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 27/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedObjectContext = appDelegate.persistentContainer.viewContext
var arrayCheck = Ids(context: managedObjectContext)

class CoreDataBase {
    
    let table = Sala(context: managedObjectContext)
    let calendar = Calendario(context: managedObjectContext)
    let profile = PerfilUsuario(context: managedObjectContext)
    let event = Evento(context: managedObjectContext)
    let user = Usuario(context: managedObjectContext)
    
    private init(){
        
    }
    static var shared = CoreDataBase()

     func createSala(){
        table.id = codeGenType.eTable.generateID()
        profile.id = codeGenType.eProfile.generateID()
        calendar.id = codeGenType.eCalendar.generateID()
        
        // Atribuir a sala o host
        
        
        // atribuir nil para os campos que serão prenchidos depois aka "telefone usuários"
        
    }

}


extension CoreDataBase : Any {

    private enum codeGenType{
        case eTable
        case eCalendar
        case eEvent
        case eProfile

        func generateID() -> UUID {
            var idCode = UUID()
            switch self {
            case .eTable:
                let arrayTable = arrayCheck.tableIDS as! [UUID]
                while arrayTable.contains(idCode){
                    idCode = UUID()
                }
            case .eCalendar:
                let arrayCalendar = arrayCheck.calendarIDS as! [UUID]
                while arrayCalendar.contains(idCode){
                    idCode = UUID()
                }
            case .eEvent:
                let arrayEvent = arrayCheck.eventIDS as! [UUID]
                while arrayEvent.contains(idCode){
                    idCode = UUID()
                }
            case .eProfile:
                let arrayProfile = arrayCheck.profileIDS as! [UUID]
                while arrayProfile.contains(idCode){
                    idCode = UUID()
                }
            }
            return idCode
        }

    }

}
