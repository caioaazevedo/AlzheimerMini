//
//  Calendario+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 31/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension Calendario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calendario> {
        return NSFetchRequest<Calendario>(entityName: "Calendario")
    }

    @NSManaged public var id: String?
    @NSManaged public var idEventos: NSObject?
    @NSManaged public var evento: NSSet?
    @NSManaged public var ofUser: Sala?

}

// MARK: Generated accessors for evento
extension Calendario {

    @objc(addEventoObject:)
    @NSManaged public func addToEvento(_ value: Evento)

    @objc(removeEventoObject:)
    @NSManaged public func removeFromEvento(_ value: Evento)

    @objc(addEvento:)
    @NSManaged public func addToEvento(_ values: NSSet)

    @objc(removeEvento:)
    @NSManaged public func removeFromEvento(_ values: NSSet)

}
