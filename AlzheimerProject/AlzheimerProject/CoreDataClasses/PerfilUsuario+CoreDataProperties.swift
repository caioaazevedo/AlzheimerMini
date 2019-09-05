//
//  PerfilUsuario+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 04/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension PerfilUsuario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PerfilUsuario> {
        return NSFetchRequest<PerfilUsuario>(entityName: "PerfilUsuario")
    }

    @NSManaged public var alergias: NSObject?
    @NSManaged public var dataDeNascimento: NSDate?
    @NSManaged public var descricao: String?
    @NSManaged public var endereco: String?
    @NSManaged public var fotoDePerfil: NSData?
    @NSManaged public var id: String?
    @NSManaged public var nome: String?
    @NSManaged public var planoDeSaude: String?
    @NSManaged public var remedios: NSObject?
    @NSManaged public var telefone: String?
    @NSManaged public var tipoSanguineo: String?
    @NSManaged public var ofSala: Sala?

}
