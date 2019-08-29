//
//  Ids+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 29/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension Ids {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ids> {
        return NSFetchRequest<Ids>(entityName: "Ids")
    }

    @NSManaged public var calendarIDS: NSObject?
    @NSManaged public var eventIDS: NSObject?
    @NSManaged public var profileIDS: NSObject?
    @NSManaged public var tableIDS: NSObject?

}
