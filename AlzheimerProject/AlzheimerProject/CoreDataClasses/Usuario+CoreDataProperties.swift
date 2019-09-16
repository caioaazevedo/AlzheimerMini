//
//  Usuario+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Caio Azevedo on 16/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension Usuario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuario> {
        return NSFetchRequest<Usuario>(entityName: "Usuario")
    }

    @NSManaged public var fotoPerfil: NSData?
    @NSManaged public var id: String?
    @NSManaged public var idSala: String?
    @NSManaged public var nome: String?
    @NSManaged public var isHost: Int64
    @NSManaged public var ofUser: NSSet?

}

// MARK: Generated accessors for ofUser
extension Usuario {

    @objc(addOfUserObject:)
    @NSManaged public func addToOfUser(_ value: Sala)

    @objc(removeOfUserObject:)
    @NSManaged public func removeFromOfUser(_ value: Sala)

    @objc(addOfUser:)
    @NSManaged public func addToOfUser(_ values: NSSet)

    @objc(removeOfUser:)
    @NSManaged public func removeFromOfUser(_ values: NSSet)

}
