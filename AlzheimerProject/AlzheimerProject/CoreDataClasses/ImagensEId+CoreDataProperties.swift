//
//  ImagensEId+CoreDataProperties.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 16/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension ImagensEId {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImagensEId> {
        return NSFetchRequest<ImagensEId>(entityName: "ImagensEId")
    }

    @NSManaged public var imagem: NSData?
    @NSManaged public var id: String?

}
