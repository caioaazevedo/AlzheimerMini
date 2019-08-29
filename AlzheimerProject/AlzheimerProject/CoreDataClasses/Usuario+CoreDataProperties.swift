//
//  Usuario+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 29/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension Usuario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuario> {
        return NSFetchRequest<Usuario>(entityName: "Usuario")
    }

    @NSManaged public var email: String?
    @NSManaged public var fotoPerfil: NSData?
    @NSManaged public var id: String?
    @NSManaged public var idSala: String?
    @NSManaged public var nome: String?
    @NSManaged public var ofUser: Sala?

}
