//
//  UserLoaded.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 01/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation
import CoreData
import CloudKit



class UserLoaded {
    var idSala : String?
    var idSalaCalendar : String?
    var idSalaProfile : String?
    var idUser = ""
    init() {
        
        idUser = recuperarId()
//        idSala = getSalaID()
//        idSalaCalendar = getCalendarID()
//        idSalaProfile = getProfileID()
        
        print("ID USUARIO -> \(idUser)")
//        print("ID SALA -> \(idSala ?? "")")
//        print("ID CALENDARIO -> \(idSalaCalendar ?? "")")
//        print("ID PROFILE -> \(idSalaProfile ?? "")")
        
    }
    
    func iCloudUserIDAsync(complete: @escaping (_ instance: CKRecord.ID?, _ error: NSError?) -> ()) {
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(nil, error as NSError?)
            } else {
                //print("fetched ID \(recordID?.recordName ?? "")")
                complete(recordID, nil)
            }
        }
    }
    func recuperarId() -> String{
        
        var id = String()
        //Verifica se está logado no icloud
        if FileManager.default.ubiquityIdentityToken != nil {
            
            //Chamada da funçao para recuperar o ID
            iCloudUserIDAsync { (recordID: CKRecord.ID?, error: NSError?) in
                self.idUser = recordID?.recordName ?? "Fetched iCloudID was nil"
                print(self.idUser)
                id = self.idUser
            }
        } else {
            print("iCloud Unavailable")
        }
        
        return id
    }
    func getSalaID() -> String{
        
        var id = String()
        let userFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        
        do {
            let usuarios = try managedObjectContext.fetch(userFetchRequest)
            for user in usuarios{
                if idUser == user.id{
                    id = user.idSala ?? "nilooo"
                }
            }
        } catch {
            print("Error")
        }
        
        return id
        
    }
    func getProfileID() -> String{
        
        var id = String()
        let salaFetchRequest = NSFetchRequest<Sala>.init(entityName: "Sala")
        var array = [String]()
        do {
            let salas = try managedObjectContext.fetch(salaFetchRequest)
            for sala in salas{
                array = (sala.idUsuarios)?.mutableCopy() as! [String]
                if array.contains(idUser) {
                    id = sala.idPerfil!
                }
            }
        } catch {
            print("Error")
        }
        return id
        
    }
    func getCalendarID() -> String{
        
        var id = String()
        let salaFetchRequest = NSFetchRequest<Sala>.init(entityName: "Sala")
        var array = [String]()
        do {
            let salas = try managedObjectContext.fetch(salaFetchRequest)
            for sala in salas{
                array = (sala.idUsuarios)?.mutableCopy() as! [String]
                if array.contains(idUser) {
                    id = sala.idCalendario!
                }
            }
        } catch {
            print("Error")
        }
        return id
        
    }
}
