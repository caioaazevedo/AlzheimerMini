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
import CloudKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedObjectContext = appDelegate.persistentContainer.viewContext
var arrayCheck = Ids(context: managedObjectContext)


class CoreDataBase {
    var userID = ""
    init(){
    }
    
    static var shared = CoreDataBase()
    
    func createUsuario(email: String, fotoDoPerfil: UIImage?, id: UUID, idSala: UUID?, Nome: String){
        
        let user = Usuario(context: managedObjectContext)
        recuperarId()
        sleep(2)
        
        user.id = userID
        user.email = email
        //        user.fotoPerfil = fotoDoPerfil as! NSData
        user.idSala = nil
        user.nome = Nome
        
        print(user)
    }
    
    func createSala(){
        let sala = Sala(context: managedObjectContext)
        let profile = PerfilUsuario(context: managedObjectContext)
        let calendar = Calendario(context: managedObjectContext)
        _ = Usuario(context: managedObjectContext)
        let usuarioFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        
        let hostId = UUID().uuidString
        // gerando id
        sala.id = UUID().uuidString
        profile.id = UUID().uuidString
        calendar.id = UUID().uuidString
        
        // Recuperar o id do host e atribuir o id dele aos campos "Usuarios" e "hostID"
        
        
        // atribuir nil para os campos que serão prenchidos depois aka "telefone"
        sala.telefoneUsuarios = nil
        
        // atribuir a Sala seu calendario e perfil
        sala.calendario = calendar
        sala.perfilUsuario = profile
        sala.idHost = userID
        sala.idUsuarios = [userID] as NSObject
        
        sala.idCalendario = calendar.id
        sala.idPerfil = profile.id
        
        
        
        do {
            
            let tasks = try managedObjectContext.fetch(usuarioFetchRequest)
            
            for task in tasks{
                if task.id == sala.idHost{
                    print(sala.id!)
                    userIdSalaUpdate(idSala: sala.id, user: task)
                    print(task)
                }
            }
            
            
        } catch{
            print("error")
        }
        
        saveCoreData()
        
    }
    
    func createEvent(descricao: String?, categoria: Category, dia: Int64, horario: Int64, nome: String, participantes: [UUID]){
        
        let event = Evento(context: managedObjectContext)
        let sala = Sala(context: managedObjectContext)
        
        let fetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        let salaFetchRequest = NSFetchRequest<Sala>.init(entityName: "Sala")
        let calendarioFetchRequest = NSFetchRequest<Calendario>.init(entityName: "Calendario")
        
        //Gerando um ID para o evento
        event.id = UUID().uuidString
        event.descricao = descricao
        //        event.categoria = categoria as? String // arrumar isso aqui
        event.dia = dia
        event.horario = horario
        event.nome = nome
        //        event.idUsuarios = participantes as NSObject // arrumar isso aqui
        
        
        var idSala : String!
        var idCalendario : String!
        
        /*Recuperando o ID do calendario
         -> Olhar o ID da sala do usuário do core data.
         -> Procuro na lista de salas do core data se algum ID é igual ao do usuário.
         -> Olho o ID do calendario da sala.
         -> Procuro dentro do calendário o calendário específico do ID
         -> Adiciono ao calendário encontrado o evento criado.
         */
        
        
        // Salvando o ID da sala ✅
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            for task in tasks {
                idSala = task.id
            }
        } catch{
            print("ERROR")
        }
        // Salvando o ID do calendario da sala ✅
        do {
            
            let tasks = try managedObjectContext.fetch(salaFetchRequest)
            for task in tasks{
                if task.id == idSala{
                    idCalendario = task.idCalendario
                }
            }
        } catch {
            print("error")
        }
        // Salvando o ID do evento criado dentro do calendario
        do {
            let tasks = try managedObjectContext.fetch(calendarioFetchRequest)
            for task in tasks{
                if task.id == idCalendario{
                    var eventoAdd : [String] = []
                    if task.idEventos == nil{
                        eventoAdd = [event.id!]
                    } else {
                        eventoAdd = ((task.idEventos)?.mutableCopy() as? [String])!
                        eventoAdd.append(event.id!)
                    }
                    task.idEventos = eventoAdd as NSObject
                }
            }
        } catch{
            print("Error")
        }
        
        
        
        //SALVAR
        do {
            try managedObjectContext.save()
        } catch {
            print("error")
        }
        
    }
    
    //Busca o ID Único do ICLOUD e faz o tratamento de error
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
    
    func recuperarId(){
        //Verifica se está logado no icloud
        if FileManager.default.ubiquityIdentityToken != nil {
            
            //Chamada da funçao para recuperar o ID
            iCloudUserIDAsync { (recordID: CKRecord.ID?, error: NSError?) in
                self.userID = recordID?.recordName ?? "Fetched iCloudID was nil"
                print("UserID = \(self.userID)")
            }
            
        } else {
            
            print("iCloud Unavailable")
            
            //Pede que o usuário abra as configurações para que faça o login no icloud
            func openSettings(alert: UIAlertAction!) {
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            
            let alert = UIAlertController(title: "Login no icloud",
                                          message: "We identify that you are not log in to icloud. Please log in to save your data , ",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Open Settings",
                                          style: UIAlertAction.Style.default,
                                          handler: openSettings))
            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: UIAlertAction.Style.destructive,
                                          handler: nil))
            
            
            //Passar a viewController que deve ser apresentada
            //            z.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateEvent(event: Evento, descricao: String?, dia: Int64, horario: Int64, nome: String, participantes: [UUID]) {
        
        event.descricao = descricao
        //        event.categoria = categoria as? String // arrumar isso aqui
        event.dia = dia
        event.horario = horario
        event.nome = nome
        event.idUsuarios = participantes as NSObject // arrumar isso aqui
        
        saveCoreData()
    }
    
    func deleteEvent(event: Evento) {
        managedObjectContext.delete(event)
        saveCoreData()
    }
    
    func updateUser(user: Usuario,email: String?, fotoDoPerfil: UIImage?, Nome: String?) {
        
        user.email = email
        user.fotoPerfil = fotoDoPerfil as! NSData
        user.nome = Nome
        
        saveCoreData()
    }
    
    func userIdSalaUpdate(idSala: String?, user: Usuario){
        user.idSala = idSala
    }
    
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


enum Category{
    case doctor
    case fun
    case dinner
    case lunch
}

