//
//  Sala+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 27/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension Sala {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sala> {
        return NSFetchRequest<Sala>(entityName: "Sala")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var idCalendario: UUID?
    @NSManaged public var idHost: NSObject?
    @NSManaged public var idPerfil: UUID?
    @NSManaged public var idUsuarios: NSObject?
    @NSManaged public var telefoneUsuarios: NSObject?
    @NSManaged public var calendario: Calendario?
    @NSManaged public var perfilUsuario: PerfilUsuario?
    @NSManaged public var usuario: NSSet?

}

// MARK: Generated accessors for usuario
extension Sala {

    @objc(addUsuarioObject:)
    @NSManaged public func addToUsuario(_ value: Usuario)

    @objc(removeUsuarioObject:)
    @NSManaged public func removeFromUsuario(_ value: Usuario)

    @objc(addUsuario:)
    @NSManaged public func addToUsuario(_ values: NSSet)

    @objc(removeUsuario:)
    @NSManaged public func removeFromUsuario(_ values: NSSet)

}
