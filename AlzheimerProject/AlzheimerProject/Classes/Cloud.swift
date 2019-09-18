//
//  Cloud.swift
//  AlzheimerProject
//
//  Created by Caio Azevedo on 26/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation
import CloudKit
import CoreData
import UIKit

let cloudContainer = CKContainer(identifier: "iCloud.Academy.AlzheimerProject")
let publicDataBase = cloudContainer.publicCloudDatabase

class Cloud {
    
    private init(){}
    static var cloud = Cloud()
    
    static func saveSala(nomeFamilia: String, idSala: String, idUsuario: [String], idCalendario: String, idPerfil: String, idHost: String) {
        
        let record = CKRecord(recordType: "Sala")
        
        record.setValue(nomeFamilia, forKeyPath: "nomeFamilia")
        record.setValue(idSala, forKeyPath: "idSala")
        record.setValue(idUsuario, forKeyPath: "idUsuarios")
        record.setValue(idCalendario, forKeyPath: "idCalendario")
        record.setValue(idPerfil, forKeyPath: "idPerfil")
        record.setValue(idHost, forKeyPath: "idHost")
        
        saveRequest(record: record)
    }
    
    static func saveUsuario(idUsuario: String, nome: String?, foto: Data?, idSala: String, host: Int64) {
        let record = CKRecord(recordType: "Usuario")
        
        
        record.setValue(idUsuario, forKeyPath: "idUsuario")
        record.setValue(nome, forKeyPath: "nome")
        record.setValue(foto, forKeyPath: "foto")
        record.setValue(idSala, forKeyPath: "idSala")
        record.setValue(host, forKey: "isHost")
        
        saveRequest(record: record)
    }
    
    static func saveCalendario(idCalendario: String, idEventos: [String]?) {
        
        let record = CKRecord(recordType: "Calendario")
        
        
        record.setValue(idCalendario, forKeyPath: "idCalendario")
        record.setValue(idEventos, forKeyPath: "idEventos")
        
        saveRequest(record: record)
    }
    
    static func saveEvento(idEvento: String, nome: String?, categoria: String, descricao: String?, dia: Date, hora: Date, idUsuario: String?, idCalendario: String, localizacao: String?, nomeCriador: String,dataCriacao: Date) {
        
        let record = CKRecord(recordType: "Evento")
        
        
        record.setValue(idEvento, forKeyPath: "idEvento")
        record.setValue(nome, forKeyPath: "nome")
        record.setValue(categoria, forKeyPath: "categoria")
        record.setValue(descricao, forKeyPath: "descricao")
        record.setValue(dia, forKeyPath: "dia")
        record.setValue(hora, forKeyPath: "hora")
        record.setValue(idUsuario, forKeyPath: "idUsuario")
        record.setValue(idCalendario, forKeyPath: "idCalendario")
        record.setValue(localizacao, forKey: "localizacao")
        record.setValue(nomeCriador, forKey: "nomeCriador")
        record.setValue(dataCriacao, forKey: "dataCriacao")
        
        saveRequest(record: record)
    }
    
    static func savePerfil(idPerfil: String, nome: String?, dataNascimento: Date?, telefone: String?, descricao: String?, fotoPerfil: CKAsset?, endereco: String?, remedios: String?, alergias: String?, tipoSanguineo: String?, planoSaude: String?) {
        
        let record = CKRecord(recordType: "Perfil")
        
        
        record.setValue(idPerfil, forKeyPath: "idPerfil")
        record.setValue(nome, forKeyPath: "nome")
        record.setValue(dataNascimento, forKeyPath: "dataNascimento")
        record.setValue(telefone, forKeyPath: "telefone")
        record.setValue(descricao, forKeyPath: "descricao")
        record.setValue(fotoPerfil, forKeyPath: "fotoPerfil")
        record.setValue(endereco, forKeyPath: "endereco")
        record.setValue(remedios, forKeyPath: "remedios")
        record.setValue(remedios, forKeyPath: "alergias")
        record.setValue(remedios, forKeyPath: "tipoSanguineo")
        record.setValue(remedios, forKeyPath: "planoSaude")
        
        saveRequest(record: record)
    }
    
    static func checkUsuario (searchUsuario: String, completion: @escaping (_ result: Bool) -> ()){
        var usuarioExists = false
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Sala", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            let array: [String] = (record["idUsuarios"] as! NSArray).mutableCopy() as! [String]
            
            for user in array {
                if searchUsuario == user {
                    usuarioExists = true
                }
            }
            
            
        }
        
        queryOp.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    if usuarioExists {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                }
            }
        }
        publicDataBase.add(queryOp)
    }
    
    static func querySala(searchRecord: String, completion: @escaping (_ result: Bool) -> ()){
        var exixst = false
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Sala", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idSala"] == searchRecord {
                
                let array: [String] = (record["idUsuarios"] as! NSArray).mutableCopy() as! [String]
                
                DadosSala.sala.nomeFamilia = record["nomeFamilia"]!
                DadosSala.sala.idSala = record["idSala"]!
                DadosSala.sala.idUsuarios = array
                DadosSala.sala.idCalendario = record["idCalendario"]!
                DadosSala.sala.idPerfil = record["idPerfil"]!
                DadosSala.sala.idHost = record["idHost"]!
                
                print("DADOS: ", record["idSala"]!, array, record["idCalendario"]!, record["idPerfil"]!, record["idHost"]!)
                
                exixst = true
                //                print(array)
            } else {
                print("NAO")
            }
            
            
        }
        
        queryOp.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    if exixst {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                }
            }
        }
        
        publicDataBase.add(queryOp)
    }
    
    static func queryArrayUsuarios(searchUsuarios: [String], completion: @escaping (_ result: Bool) -> ()) {
        var count = 0
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            print("=-=-=-=-=-=> ", count)
//            print("Search: \(searchUsuarios[count]) ===== Record: \(record["idUsuario"]!)")
            if count < searchUsuarios.count {
                if searchUsuarios[count] == record["idUsuario"] {
                    DadosArrayUsuarios.array.id.append(record["idUsuario"]!)
                    DadosArrayUsuarios.array.nome.append(record["nome"]!)
                    DadosArrayUsuarios.array.foto?.append(record["foto"]!)
                    
                    count += 1
                    
                    print("=-=-=-=-=-=> ", count)
                }
            }
        }
        
        queryOp.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                completion(true)
            }
        }
        publicDataBase.add(queryOp)
    }
    
    static func queryUsuario(searchRecord: String, completion: @escaping (_ result: Bool) -> ()){
        var found = false
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idUsuario"] == searchRecord {
                
                DadosUsuario.usuario.idUsuario = record["idUsuario"]!
                DadosUsuario.usuario.nome = record["nome"]!
                DadosUsuario.usuario.foto = record["foto"]!
                DadosUsuario.usuario.idSala = record["idSala"]!
                DadosUsuario.usuario.isHost = record["isHost"]!
                
                found = true
                
                print("DADOS: ", record["nome"], record["idSala"])
                
            }
        }
        
        queryOp.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    if found {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                }
            }
        }
        publicDataBase.add(queryOp)
    }
    
    static func queryCalendario(searchRecord: String, completion: @escaping (_ result: Bool) -> ()){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Calendario", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idCalendario"] == searchRecord {
                
                DadosClendario.calendario.idCalendario = record["idCalendario"]!
                if let rec = record["idEventos"] {
                    DadosClendario.calendario.idEventos = ((rec as! NSArray).mutableCopy() as? [String])!
                    
                }
                //                print("DADOS: ", record["idCalendario"]!, record["idEventos"]!)
                
                completion(true)
                
            }
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func queryEventos(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Evento", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            print("DADOS: ", record["idEvento"]!, record["nome"]!, record["categoria"]!,
                  record["descricao"]!, record["hora"]!, record["idUsuario"]!, record["idCalendario"]!)
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func queryPerfil(searchRecord: String, completion: @escaping (_ result: Bool) -> ()){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Perfil", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idPerfil"] == searchRecord {
                
                DadosPerfil.perfil.idPerfil = record["idPerfil"]!
                DadosPerfil.perfil.nome = record["nome"] ?? ""
                DadosPerfil.perfil.dataNascimento = record["dataNascimento"]
                DadosPerfil.perfil.telefone = record["telefone"] ?? ""
                DadosPerfil.perfil.descricao = record["descricao"] ?? ""
                DadosPerfil.perfil.fotoPerfil = record["fotoPerfil"] 
                DadosPerfil.perfil.endereco = record["endereco"] ?? ""
                if record["remedios"] != nil {
                    DadosPerfil.perfil.remedios = (record["remedios"] as! NSArray).mutableCopy() as! [String]
                }
                if record["alergias"] != nil {
                    DadosPerfil.perfil.remedios = (record["alergias"] as! NSArray).mutableCopy() as! [String]
                }
                DadosPerfil.perfil.tipoSanguineo = record["tipoSanguineo"] ?? ""
                DadosPerfil.perfil.planoSaude = record["planoSaude"] ?? ""
                
                //            print("DADOS: ", record["idPerfil"]!, record["nome"]!, record["dataNascimento"]!,
                //                  record["telefone"]!, record["descricao"]!, record["fotoPerfil"]!, record["endereco"]!, record["remedios"]!, record["alergias"]!, record["tipoSanguineo"]!, record["planoSaude"]!)
                
                completion(true)
            }
        }
        publicDataBase.add(queryOp)
    }
    
    static func updateSala(nomeFamilia: String, searchRecord: String, idSala: String, idUsuario: [String], idCalendario: String, idPerfil: String, idHost: String) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Sala", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idSala"] == searchRecord {
                
                record.setValue(nomeFamilia, forKeyPath: "nomeFamilia")
                record.setValue(idSala, forKeyPath: "idSala")
                record.setValue(idUsuario, forKeyPath: "idUsuarios")
                record.setValue(idCalendario, forKeyPath: "idCalendario")
                record.setValue(idPerfil, forKeyPath: "idPerfil")
                record.setValue(idHost, forKeyPath: "idHost")
                
                publicDataBase.save(record, completionHandler: { (record, error) in
                    if error != nil{
                        print(error!)
                    } else {
                        print("Success!")
                    }
                })
                
            }
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func updateUsuario(searchRecord: String, nome: String?, foto: Data?, idSala: String) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idUsuario"] == searchRecord {
                
                record.setValue(nome, forKeyPath: "nome")
                record.setValue(foto, forKeyPath: "foto")
                
                publicDataBase.save(record, completionHandler: { (record, error) in
                    if error != nil{
                        print(error!)
                    } else {
                        print("Success!")
                    }
                })
                
            }
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func updateCalendario(searchRecord: String, idEventos: [String]) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Calendario", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idCalendario"] == searchRecord {
                
                record.setValue(idEventos, forKeyPath: "idEventos")
                
                publicDataBase.save(record, completionHandler: { (record, error) in
                    if error != nil{
                        print(error!)
                    } else {
                        print("Success!")
                    }
                })
                
            }
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func updateEvento(searchRecord: String, idEvento: String, nome: String?, categoria: String, descricao: String?, dia: Date, hora: Date, idUsuario: String?, idCalendario: String,localizacao: String) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Evento", predicate: predicate)
        let hoje = Date()
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idEvento"] == searchRecord {
                
                record.setValue(nome, forKeyPath: "nome")
                record.setValue(categoria, forKeyPath: "categoria")
                record.setValue(descricao, forKeyPath: "descricao")
                record.setValue(dia, forKeyPath: "dia")
                record.setValue(hora, forKeyPath: "hora")
                record.setValue(idUsuario, forKeyPath: "idUsuario")
                record.setValue(localizacao, forKeyPath: "localizacao")
                record.setValue(hoje, forKey: "dataCriacao")
                
                publicDataBase.save(record, completionHandler: { (record, error) in
                    if error != nil{
                        print(error!)
                    } else {
                        print("Success!")
                    }
                })
                
            }
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func updatePerfil(searchRecord: String, idPerfil: String, nome: String, dataNascimento: Date, telefone: String?, descricao: String?, fotoPerfil: Data?, endereco: String?, remedios: [String]?, alergias: [String]?, tipoSanguineo: String?, planoSaude: String?) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Perfil", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idPerfil"] == searchRecord {
                
                record.setValue(nome, forKeyPath: "nome")
                record.setValue(dataNascimento, forKeyPath: "dataNascimento")
                record.setValue(telefone, forKeyPath: "telefone")
                record.setValue(descricao, forKeyPath: "descricao")
                record.setValue(fotoPerfil, forKeyPath: "fotoPerfil")
                record.setValue(endereco, forKeyPath: "endereco")
                record.setValue(remedios, forKeyPath: "remedios")
                record.setValue(alergias, forKeyPath: "alergias")
                record.setValue(tipoSanguineo, forKeyPath: "tipoSanguineo")
                record.setValue(planoSaude, forKeyPath: "planoSaude")
                
                publicDataBase.save(record, completionHandler: { (record, error) in
                    if error != nil{
                        print(error!)
                    } else {
                        print("Success!")
                    }
                })
                
            }
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func deleteTable(searchRecord: String, searchKey: String, searchTable: String){
        
        print("\(searchTable) - \(searchRecord) - \(searchKey)")
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "\(searchTable)", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["\(searchKey)"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["\(searchKey)"] == searchRecord {
                
                let delete = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [record.recordID])
                
                publicDataBase.add(delete)
                
                publicDataBase.save(record, completionHandler: { (record, error) in
                    if error != nil{
                        print(error!)
                    } else {
                        print("Record was deleted!")
                    }
                })
                
            }
            
        }
        publicDataBase.add(queryOp)
        
    }
    
    
    
    
    // ✅
    
    static func updateAllEvents(completion: @escaping (_ result: Bool) -> ()){
        
        /*
         1. Deletar todos os eventos do coreData
         2. Carregar cada evento do cloud
         3. Salvar os eventos em novas instancias no coreData
         */
        
        let userLoad = UserLoaded()

        // 2 -> ✅
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Evento", predicate: predicate)
        let queryOp = CKQueryOperation(query: query)
        let secondOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idCalendario"] == userLoad.idSalaCalendar{
                let eventCreate = Evento(context: managedObjectContext)
                eventCreate.nomeCriador = record["nomeCriador"]
                eventCreate.id = record["idEvento"]
                eventCreate.categoria = record["categoria"]
                eventCreate.descricao = record["descricao"]
                eventCreate.dia = record["dia"] as? NSDate
                eventCreate.horario = record["hora"] as? NSDate
                eventCreate.idUsuarios = record["idUsuarios"] as? NSObject
                eventCreate.idCalendario = record["idCalendario"]
                eventCreate.idResponsavel = record["idUsuario"]
                eventCreate.nome = record["nome"]
                eventCreate.localizacao = record["localizacao"]
                CoreDataRebased.shared.saveCoreData()
            }
        }
        secondOp.recordFetchedBlock = { (record) -> Void in
            
            completion(true)
            
            
        }
        
        secondOp.addDependency(queryOp)
        
        publicDataBase.add(queryOp)
        publicDataBase.add(secondOp)
        
    }
    // ✅
    static func updateUsuarioProfile(){
        
        /*
         1.Procuro o id do profile no cloud
         2.Procuro o profile no coreData
         3.Atualizo os dados do profile
         */
        
        let userLoad = UserLoaded()
        let profileFetchRequest = NSFetchRequest<PerfilUsuario>.init(entityName: "PerfilUsuario")
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "PerfilUsuario", predicate: predicate)
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idPerfil"] == userLoad.idSalaProfile{
                
                do{
                    let perfis = try managedObjectContext.fetch(profileFetchRequest)
                    for profile in perfis{
                        
                        if profile.id == userLoad.idSalaProfile{
                            profile.alergias = record["alergias"] as? NSObject
                            profile.dataDeNascimento = record["dataNascimento"]
                            profile.descricao = record["descricao"]
                            profile.endereco = record["endereco"]
                            profile.fotoDePerfil = record["fotoPerfil"]
                            profile.id = record["idPerfil"]
                            profile.nome = record["nome"]
                            profile.planoDeSaude = record["planoSaude"]
                            profile.remedios = record["remedios"] as? NSObject
                            profile.tipoSanguineo = record["tipoSanguineo"]
                            CoreDataRebased.shared.saveCoreData()
                        }
                        
                        
                    }
                } catch{
                    print("Error")
                }
            }
        }
        
        publicDataBase.add(queryOp)
        
    }
    // ✅
    static func updateCalendario(completion: @escaping (_ result: Bool) -> ()){
        
        let userLoad = UserLoaded()
        let calendarioFetchRequest = NSFetchRequest<Calendario>.init(entityName: "Calendario")
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Calendario", predicate: predicate)
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idCalendario"] == userLoad.idSalaCalendar{
                do{
                    let calendarios = try managedObjectContext.fetch(calendarioFetchRequest)
                    for calend in calendarios{
                        if calend.id == userLoad.idSalaCalendar{
                            calend.id = record["idCalendario"]
                            calend.idEventos = record["idEventos"] as? NSObject
                            CoreDataRebased.shared.saveCoreData()
                            completion(true)
                        }
                    }
                } catch{
                    print("Error")
                }
                
            }
            
        }
        
        publicDataBase.add(queryOp)
        
        
    }
    // ✅
    static func updateSala(completion: @escaping (_ result: Bool) -> ()){
        let userLoad = UserLoaded()
        let salaFetchRequest = NSFetchRequest<Sala>.init(entityName: "Sala")
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Sala", predicate: predicate)
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        
        
        queryOp.recordFetchedBlock = {(record) -> Void in
            
            if record["idSala"] == userLoad.idSala{
                do{
                    let salas = try managedObjectContext.fetch(salaFetchRequest)
                    
                    for sala in salas{
                        if sala.id == userLoad.idSala{
                            sala.idUsuarios = record["idUsuarios"] as? NSObject
//                            sala.telefoneUsuarios = record["telefoneUsuarios"] as? NSObject
                            
                            CoreDataRebased.shared.saveCoreData()
                        }
                    }
                    completion(true)
                } catch {
                    print("Error")
                }
            } else {
                print("Nao achou")
            }
            
        }
        
        publicDataBase.add(queryOp)
    }
    
    
    static func deleteCloudSubs(){
        publicDataBase.fetchAllSubscriptions { subscriptions, error in
            if error == nil {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        print("AQUI O MEME",subscription)
                        publicDataBase.delete(withSubscriptionID: subscription.subscriptionID) { str, error in
                            if error != nil {
                                // do your error handling here!
                                print(error!.localizedDescription)
                            }
                        }
                    }
                    // more code to come!
                }
            } else {
                // do your error handling here!
                print(error!.localizedDescription)
            }
        }
    }
    
    static func cloudUpdateCalendarioEventos(array: [String]){
        let userLoad = UserLoaded()
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Calendario", predicate: predicate)
        let queryOp = CKQueryOperation(query: query)
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            if record["idCalendario"] == userLoad.idSalaCalendar{
                record["idEvetos"] = array
                publicDataBase.save(record, completionHandler: { (record, error) in
                    if error != nil{
                        print(error!)
                    }
                })
            }
        }
        publicDataBase.add(queryOp)
        
    }
    
    static func cloudDeleteEvento(eventoId: String){
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Evento", predicate: predicate)
        let queryOp = CKQueryOperation(query: query)
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idEvento"] == eventoId{
                let delete = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [record.recordID])
                publicDataBase.add(delete)
                publicDataBase.save(record, completionHandler: { (record, error) in
                    if error != nil{
                        print(error!)
                    }
                })
            }
            
        }
        
        publicDataBase.add(queryOp)
    }
    
    //Cloud Push-Up notifications ⚡️
    static func setupCloudKitNotifications(){
        
        let userLoad = UserLoaded()
        
        let predicate = NSPredicate(format: "%K == %@", argumentArray: ["idCalendario", userLoad.idSalaCalendar!])
        let subscription = CKQuerySubscription(recordType: "Evento", predicate: predicate, options: .firesOnRecordCreation)
        let notificationInfo = CKQuerySubscription.NotificationInfo()
        
        notificationInfo.alertBody = "Novo evento criado! Venha conferir!"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo
        
        publicDataBase.save(subscription) { (sub, error) in
            if let error = error{
                print("Error ao criar o request",error)
            } else {
                print("Tudo certo")
            }
        }
        
        
    }
    
//    Deleta as Pessoas do CoreData
    static func deletePessoas(completion: @escaping (_ result: Bool) -> ()) {
        let fetchRequest = NSFetchRequest<Pessoas>.init(entityName: "Pessoas")
        
        do{
            let peoples = try managedObjectContext.fetch(fetchRequest)
            for p in peoples{
                managedObjectContext.delete(p)
                CoreDataRebased.shared.saveCoreData()
                completion(true)
            }
        }catch{
            print("Error")
        }
    }
    //Cloud Push-Up notifications ⚡️
    
    
    
    
    //Cloud ⚡️
//    static func getPeople(delegate: FetchPeopleDelegate ){
    static func getPeople(_ completion: @escaping () -> Void) {
        let newPeople = Pessoas(context: managedObjectContext)
        let userLoad = UserLoaded()
        /*
         0. DELETAR O QUE ESTIVER NO CORE DATA!
         1. Procurar os usuarios na nuvem que pertecem a mesma sala
         2. Salvar o nome, o ID e a foto
         3. ESSE METODO TEM QUE SER CHAMADO QUANDO ENTRAR NA TELA DE CRIAR EVENTO
         */
        
        
//        Cloud.deletePessoas { (_) in
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: "Usuario", predicate: predicate)
            let queryOp = CKQueryOperation(query: query)
        
            ckData = []
            var arrayUsuarios = [String]()
        
            queryOp.recordFetchedBlock = { (record) -> Void in
                
//                newPeople.foto = record["foto"] as? NSData
//                newPeople.id = record["idUsuario"]
//                newPeople.nome = record["nome"]
//                newPeople.selecionado = falserefreshControl.endRefreshing()
                let imageDefault = UIImage(named: "ProfilePicture")
                ckData.append((record["idUsuario"]!, record["nome"]!, record["foto"] ?? ((imageDefault?.pngData()!)!)))
                
                if userLoad.idSala == record["idSala"]! {
                    arrayUsuarios.append(record["idUsuario"]!)
                    CoreDataRebased.shared.updateSala(idUsuarios: arrayUsuarios)
                }
                
                
                //CoreDataRebased.shared.saveCoreData()
            }
        
            queryOp.completionBlock = completion
        
            publicDataBase.add(queryOp)
//        }
        
    }
    //Cloud ⚡️
    
    
//    static func getIdPicName() -> [peopleIdPicName]{
//
//        /*
//         1.Procurar nos usuarios do cloud os que tem o id da sala e armazenar em um array
//         2.coletar o nome, foto e id
//         */
//        var array = [peopleIdPicName]()
//
//        let userLoad = UserLoaded()
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: "Usuario", predicate: predicate)
//        let queryOp = CKQueryOperation(query: query)
//        queryOp.queuePriority = .veryHigh
//
//        queryOp.recordFetchedBlock = { (record) -> Void in
//
//
//            if record["idSala"] == userLoad.idSala{
//                var item = peopleIdPicName(nome:record["nome"]!, id: record["id"]!, img:record["foto"]!)
//                array.append(item)
//            }
//            return array
//
//
//
//        }
//
//        
//
//
//    }
    
    
    static func getIdUsuariosSala(completion: @escaping (_ result: Bool) -> ()){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Sala", predicate: predicate)
        let queryOp = CKQueryOperation(query: query)
        let query2 = CKQuery(recordType: "Usuario", predicate: predicate)
        let queryOp2 = CKQueryOperation(query: query2)
        let userLoad = UserLoaded()
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            var i = 0
            if record["idSala"] == userLoad.idSala{
                var arrayPeople = (record["idUsuarios"] as! NSArray).mutableCopy() as! [String]
                for per in arrayPeople{
                    if per == userLoad.idUser{
                        arrayPeople.remove(at: i)
                    }
                    i += 1
                }
                record["idUsuarios"] = arrayPeople
                
                
                
                
                publicDataBase.save(record) { (record, error) in
                    
                    if error != nil {
                        print("Error: ", error!)
                    } else {
                        print("Success!")
                    }
                    
                }
                
                
                completion(true)
            }
            
            
        }
        queryOp2.recordFetchedBlock = { (record) -> Void in
            
            if record["idUsuario"] == userLoad.idUser{
                
                let delete = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [record.recordID])
                publicDataBase.add(delete)
                publicDataBase.save(record, completionHandler: { (record, error) in
                    if error != nil{
                        print(error!)
                    }
                })
                
            }
        }
        
        publicDataBase.add(queryOp)
        publicDataBase.add(queryOp2)
        
        
    }
    
    
    
    
    static func geraAleatorio() -> Int64{
        let ran:Int64 = Int64(arc4random_uniform(1000000))
        
        return ran
    }
    
    private static func saveRequest(record: CKRecord){
        publicDataBase.save(record) { (record, error) in
            
            if error != nil {
                print("Error: ", error!)
            } else {
                print("Success!")
            }
            
        }
    }
    
}


struct peopleIdPicName{
    
    var nome: String
    var id: String
    var img : Data
    
    
}
