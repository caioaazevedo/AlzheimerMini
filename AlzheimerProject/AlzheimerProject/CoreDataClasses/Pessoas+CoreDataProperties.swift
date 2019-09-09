//
//  Pessoas+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 09/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension Pessoas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pessoas> {
        return NSFetchRequest<Pessoas>(entityName: "Pessoas")
    }

    @NSManaged public var nome: String?
    @NSManaged public var foto: NSData?
    @NSManaged public var id: String?

}
