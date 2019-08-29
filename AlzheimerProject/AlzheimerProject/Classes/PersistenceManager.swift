//
//  PersistenceManager.swift
//  AlzheimerProject
//
//  Created by Eduardo Airton on 29/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation
import CoreData

class PersistenceManager {
    private init(){}
    
    func saveCoreData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Dados salvos no coreData")
            } catch {
                let nserror = error as NSError
                fatalError("Error \(nserror), \(nserror.userInfo)")
            }
            
        }
    }
    
    func deleteObjectInCoreData(_ object: NSManagedObject) {
        managedObjectContext.delete(object)
        saveCoreData()
    }
    
    func filtrar(_ filter: String){
        let fetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        
        let predicate = NSPredicate(format: "nome contains %@", filter)
        fetchRequest.predicate = predicate
    }
    
    
}
