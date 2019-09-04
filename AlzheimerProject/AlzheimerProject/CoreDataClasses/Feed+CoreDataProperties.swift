//
//  Feed+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 04/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed")
    }

    @NSManaged public var dia: String?
    @NSManaged public var horario: String?
    @NSManaged public var localizacao: String?
    @NSManaged public var paciente: String?
    @NSManaged public var responsavel: String?
    @NSManaged public var titulo: String?

}
