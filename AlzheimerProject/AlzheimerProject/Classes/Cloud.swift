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
    
    private init(){
    }
    
    
    
    
    static var cloud = Cloud()
    
    static func saveSala(idSala: Int64, idUsuario: [String], idCalendario: Int64, idPerfil: Int64, idHost: Int64) {
        
        let record = CKRecord(recordType: "Sala")
        
        
        record.setValue(idSala, forKeyPath: "idSala")
        record.setValue(idUsuario, forKeyPath: "idUsuario")
        record.setValue(idCalendario, forKeyPath: "idCalendario")
        record.setValue(idPerfil, forKeyPath: "idPerfil")
        record.setValue(idHost, forKeyPath: "idHost")
        
        saveRequest(record: record)
    }
    
    static func saveUsuario(idUsuario: String, nome: String?, foto: CKAsset?, email: String?, idSala: Int64) {
        let record = CKRecord(recordType: "Usuario")
        
        
        record.setValue(idUsuario, forKeyPath: "idUsuario")
        record.setValue(nome, forKeyPath: "nome")
        record.setValue(foto, forKeyPath: "foto")
        record.setValue(email, forKeyPath: "email")
        record.setValue(idSala, forKeyPath: "sala")
        
        saveRequest(record: record)
    }
    
    static func saveCalendario(idCalendario: Int64, idEventos: [Int64]) {
        
        let record = CKRecord(recordType: "Calendario")
        
        
        record.setValue(idCalendario, forKeyPath: "idCalendario")
        record.setValue(idEventos, forKeyPath: "idEventos")
        
        saveRequest(record: record)
    }
    
    static func saveEvento(idEvento: Int64, nome: String?, categoria: String, descricao: String?, dia: Date, hora: Timer, idUsuario: String, idCalendario: Int64) {
        
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
    
    static func savePerfil(idPerfil: Int64, nome: String, dataNascimento: Date, telefone: String?, descricao: String?, fotoPerfil: CKAsset?, endereco: String?, remedios: String?, alergias: String?, tipoSanguineo: String?, planoSaude: String?) {
        
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
    
    static func querySala(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Sala", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["idSala", "idUsuario", "idCalendario", "idPerfil", "idHost"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            print("DADOS: ", record["idSala"]!, record["idUsuario"]!, record["idCalendario"]!,
                  record["idPerfil"]!, record["idHost"]!)
            
            publicDataBase.add(queryOp)
        }
    }
    
    static func queryUsuario(){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Usuario", predicate: predicate)
        
        let queryOp = CKQueryOperation(query: query)
        queryOp.desiredKeys = ["nome", "foto", "email", "sala"]
        queryOp.queuePriority = .veryHigh
        queryOp.resultsLimit = 10
        
        queryOp.recordFetchedBlock = { (record) -> Void in
            
            print("DADOS: ", record["nome"]!, record["email"]!, record["sala"]!)
            
            publicDataBase.add(queryOp)
        }
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
