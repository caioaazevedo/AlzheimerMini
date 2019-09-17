//
//  Evento+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Caio Azevedo on 17/09/19.
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
    @NSManaged public var dataCriacao: NSDate?
    @NSManaged public var descricao: String?
    @NSManaged public var dia: NSDate?
    @NSManaged public var horario: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var idCalendario: String?
    @NSManaged public var idResponsavel: String?
    @NSManaged public var idUsuarios: NSObject?
    @NSManaged public var localizacao: String?
    @NSManaged public var nome: String?
    @NSManaged public var nomeCriador: String?
    @NSManaged public var ofCalendar: Calendario?

}
