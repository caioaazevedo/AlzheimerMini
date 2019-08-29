//
//  CoreData.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 27/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedObjectContext = appDelegate.persistentContainer.viewContext
var arrayCheck = Ids(context: managedObjectContext)

class CoreDataBase {
    
//    let table = Sala(context: managedObjectContext)
//    let profile = PerfilUsuario(context: managedObjectContext)
//    let event = Evento(context: managedObjectContext)
//    let user = Usuario(context: managedObjectContext)
//    let calendar = Calendario(context: managedObjectContext)
    
    private init(){
        
    }
    static var shared = CoreDataBase()
    
    func createUsuario(email: String, fotoDoPerfil: UIImage, id: UUID, idSala: UUID?, Nome: String){
        
        let user = Usuario(context: managedObjectContext)
        
        user.email = email
        user.fotoPerfil = fotoDoPerfil as! NSData
        //user.id = xxx
        user.idSala = nil
        user.nome = Nome
    }
    

    func createSala(hostID: NSObject){
        let sala = Sala(context: managedObjectContext)
        let profile = PerfilUsuario(context: managedObjectContext)
        let calendar = Calendario(context: managedObjectContext)
        
        // gerando id
        sala.id = codeGenType.eTable.generateID()
        profile.id = codeGenType.eProfile.generateID()
        calendar.id = codeGenType.eCalendar.generateID()
        
        // Recuperar o id do host e atribuir o id dele aos campos "Usuarios" e "hostID"
        
        sala.idHost = hostID // ARRUMAR
        
        // atribuir nil para os campos que serão prenchidos depois aka "telefone"
        sala.telefoneUsuarios = nil
        
        // atribuir a Sala seu calendario e perfil
        sala.calendario = calendar
        sala.perfilUsuario = profile
        
    }
    
    func createEvent(descricao: String?, categoria: category, dia: Int64, horario: Int64, nome: String, participantes: [UUID]){
        
        let event = Evento(context: managedObjectContext)
        
        
        let fetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        
        //Gerando um ID para o evento
        event.id = codeGenType.eEvent.generateID()
        event.descricao = descricao
        event.categoria = categoria as? String // arrumar isso aqui
        event.dia = dia
        event.horario = horario
        event.nome = nome
        event.idUsuarios = participantes as NSObject // arrumar isso aqui
        
        /*Recuperando o ID do calendario
         -> Olhar o ID da sala do usuário do core data.
         -> Procuro na lista de salas do core data se algum ID é igual ao do usuário.
         -> Olho o ID do calendario da sala.
         -> Procuro dentro do calendário o calendário específico do ID
         -> Adiciono ao calendário encontrado o evento criado.
         */
        
        
        
        
        
    }

}


extension CoreDataBase : Any {

    private enum codeGenType{
        case eTable
        case eCalendar
        case eEvent
        case eProfile

        func generateID() -> UUID {
            var idCode = UUID()
            switch self {
            case .eTable:
                let arrayTable = arrayCheck.tableIDS as! [UUID]
                while arrayTable.contains(idCode){
                    idCode = UUID()
                }
            case .eCalendar:
                let arrayCalendar = arrayCheck.calendarIDS as! [UUID]
                while arrayCalendar.contains(idCode){
                    idCode = UUID()
                }
            case .eEvent:
                let arrayEvent = arrayCheck.eventIDS as! [UUID]
                while arrayEvent.contains(idCode){
                    idCode = UUID()
                }
            case .eProfile:
                let arrayProfile = arrayCheck.profileIDS as! [UUID]
                while arrayProfile.contains(idCode){
                    idCode = UUID()
                }
            }
            return idCode
        }

    }
    
    enum category{
        case doctor
        case fun
        case dinner
        case lunch
    }
}
