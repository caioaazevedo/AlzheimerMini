//
//  Evento+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 04/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension Evento {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Evento> {
        return NSFetchRequest<Evento>(entityName: "Evento")
    }

    @NSManaged public var categoria: String?
    @NSManaged public var descricao: String?
    @NSManaged public var dia: NSDate?
    @NSManaged public var horario: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var idCalendario: Int64
    @NSManaged public var idUsuarios: NSObject?
    @NSManaged public var nome: String?
    @NSManaged public var ofCalendar: Calendario?

}
