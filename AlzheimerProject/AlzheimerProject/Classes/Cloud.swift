//
//  Cloud.swift
//  AlzheimerProject
//
//  Created by Caio Azevedo on 26/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation
import CloudKit

let cloudContainer = CKContainer(identifier: "iCloud.Academy.AlzheimerProject")
let publicDataBase = cloudContainer.publicCloudDatabase

class Cloud {
    
    private init(){}
    
    static var cloud = Cloud()
    
    static func saveSala(idSala: String, idUsuario: [String], idCalendario: String, idPerfil: String, idHost: String) {
        
        let record = CKRecord(recordType: "Sala")
        
        
        record.setValue(idSala, forKeyPath: "idSala")
        record.setValue(idUsuario, forKeyPath: "idUsuarios")
        record.setValue(idCalendario, forKeyPath: "idCalendario")
        record.setValue(idPerfil, forKeyPath: "idPerfil")
        record.setValue(idHost, forKeyPath: "idHost")
        
        saveRequest(record: record)
    }
    
    static func saveUsuario(idUsuario: String, nome: String?, foto: CKAsset?, email: String?, idSala: String) {
        let record = CKRecord(recordType: "Usuario")
        
        
        record.setValue(idUsuario, forKeyPath: "idUsuario")
        record.setValue(nome, forKeyPath: "nome")
        record.setValue(foto, forKeyPath: "foto")
        record.setValue(email, forKeyPath: "email")
        record.setValue(idSala, forKeyPath: "sala")
        
        saveRequest(record: record)
    }
    
    static func saveCalendario(idCalendario: String, idEventos: [String]) {
        
        let record = CKRecord(recordType: "Calendario")
        
        
        record.setValue(idCalendario, forKeyPath: "idCalendario")
        record.setValue(idEventos, forKeyPath: "idEventos")
        
        saveRequest(record: record)
    }
    
    static func saveEvento(idEvento: String, nome: String?, categoria: String, descricao: String?, dia: Date, hora: Timer, idUsuario: String?, idCalendario: String) {
        
        let record = CKRecord(recordType: "Evento")
        
        
        record.setValue(idEvento, forKeyPath: "idEvento")
        record.setValue(nome, forKeyPath: "nome")
        record.setValue(categoria, forKeyPath: "categoria")
        record.setValue(descricao, forKeyPath: "descricao")
        record.setValue(dia, forKeyPath: "dia")
        record.setValue(hora, forKeyPath: "hora")
        record.setValue(idUsuario, forKeyPath: "idUsuario")
        record.setValue(idCalendario, forKeyPath: "idCalendario")
        
        saveRequest(record: record)
    }
    
    static func savePerfil(idPerfil: String, nome: String, dataNascimento: Date, telefone: String?, descricao: String?, fotoPerfil: CKAsset?, endereco: String?, remedios: String?, alergias: String?, tipoSanguineo: String?, planoSaude: String?) {
        
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
    
    static func querySala(searchRecord: String){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Sala", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["idSala", "idUsuarios", "idCalendario", "idPerfil", "idHost"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
             if record["idSala"] == searchRecord {
            
                var array: [String] = (record["idUsuarios"] as! NSArray).mutableCopy() as! [String]
                
                DadosSala.sala.idSala = record["idSala"]!
                DadosSala.sala.idUsuarios = array
                DadosSala.sala.idCalendario = record["idCalendario"]!
                DadosSala.sala.idPerfil = record["idPerfil"]!
                DadosSala.sala.idHost = record["idHost"]!
                
                print("DADOS: ", record["idSala"]!, array, record["idCalendario"]!, record["idPerfil"]!, record["idHost"]!)
//
//                print(array)
            }
            
            
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func queryUsuario(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["nome", "foto", "email", "idSala"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            print("DADOS: ", record["nome"], record["email"], record["idSala"])
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func queryCalendario(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Calendario", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["idCalendario", "idEventos"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            print("DADOS: ", record["idCalendario"]!, record["idEventos"]!)
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func queryEvento(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Evento", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["idEvento", "nome", "categoria", "descricao", "dia", "hora", "idUsuario", "idCalendario"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            print("DADOS: ", record["idEvento"]!, record["nome"]!, record["categoria"]!,
                  record["descricao"]!, record["hora"]!, record["idUsuario"]!, record["idCalendario"]!)
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func queryPerfil(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Perfil", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["idPerfil", "nome", "dataNascimento", "telefone", "descricao", "fotoPerfil", "endereco", "remedios", "remedios", "tipoSanguineo", "planoSaude"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            print("DADOS: ", record["idPerfil"]!, record["nome"]!, record["dataNascimento"]!,
                  record["telefone"]!, record["descricao"]!, record["fotoPerfil"]!, record["endereco"]!, record["remedios"]!, record["remedios"]!, record["tipoSanguineo"]!, record["planoSaude"]!)
            
        }
        publicDataBase.add(queryOp)
    }
    
    static func updateSala(searchRecord: String, idSala: String, idUsuario: [String], idCalendario: String, idPerfil: String, idHost: String) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Sala", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["idSala", "idUsuarios", "idCalendario", "idPerfil", "idHost"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idSala"] == searchRecord {
                
                record.setValue(idSala, forKeyPath: "idSala")
                record.setValue(idUsuario, forKeyPath: "idUsuario")
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
    
    static func updateUsuario(searchRecord: String, nome: String?, foto: CKAsset?, email: String?, idSala: String) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["nome", "foto", "email", "idSala"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idUsuario"] == searchRecord {
                
                record.setValue(nome, forKeyPath: "nome")
                record.setValue(foto, forKeyPath: "foto")
                record.setValue(email, forKeyPath: "email")
                
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
        queryOp.desiredKeys = ["idEventos"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
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
    
    static func updateEvento(searchRecord: String, idEvento: String, nome: String?, categoria: String, descricao: String?, dia: Date, hora: Timer, idUsuario: String?, idCalendario: String) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Evento", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["nome", "categoria", "descricao", "dia", "hora", "idUsuario"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idEvento"] == searchRecord {
                
                record.setValue(nome, forKeyPath: "nome")
                record.setValue(categoria, forKeyPath: "categoria")
                record.setValue(descricao, forKeyPath: "descricao")
                record.setValue(dia, forKeyPath: "dia")
                record.setValue(hora, forKeyPath: "hora")
                record.setValue(idUsuario, forKeyPath: "idUsuario")
                
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
    
    static func updatePerfil(searchRecord: String, idPerfil: String, nome: String, dataNascimento: Date, telefone: String?, descricao: String?, fotoPerfil: CKAsset?, endereco: String?, remedios: String?, alergias: String?, tipoSanguineo: String?, planoSaude: String?) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Perfil", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["nome", "dataNascimento", "telefone", "descricao", "fotoPerfil", "endereco", "remedios", "alergias", "tipoSanguineo", "planoSaude"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            if record["idPerfil"] == searchRecord {
                
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
