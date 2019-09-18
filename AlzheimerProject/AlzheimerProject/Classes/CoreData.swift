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


class CoreDataBase {
    var userID = ""
    init(){
    }
    static var shared = CoreDataBase()
    
    func createUsuario(fotoDoPerfil: UIImage?, id: UUID, idSala: UUID?, Nome: String){
        
            let user = Usuario(context: managedObjectContext)
            
            user.id = self.userID
            //        user.fotoPerfil = fotoDoPerfil as! NSData
            user.idSala = nil
            user.nome = Nome
            
            self.saveCoreData()
            
            let ur = NSFetchRequest<Usuario>.init(entityName: "Usuario")
            do{
                let task = try managedObjectContext.fetch(ur)
                for t in task{
                    print(t)
                }
            } catch{
                
            }
        

    }
    
    func createSala(nomeFamilia: String){
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
        
        print(sala)
        
    }
    
    func createEventRepaired(categorioa: String, descricao: String, dia: Date, horario: Date){
        
        /*
         1 - Olhar o ID da sala do USUARIO
         2 - Olhar o ID do calendario da SALA
         3 - criar evento
         4 - Adicionar ao idEventos o id do evento criado
         */
        
        
        // ---> 1
        var idSala = String()
        let userRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        do{
            let listaUser = try managedObjectContext.fetch(userRequest)
            for user in listaUser{
                if user.idSala != nil{
                    idSala = user.idSala!
                }
            }
        } catch {
            print("error")
        }
        // ---> 2
        var idCalendario = String()
        let salaRequest = NSFetchRequest<Sala>.init(entityName: "Sala")
        do{
            let salas = try managedObjectContext.fetch(salaRequest)
            for sala in salas{
                if idSala == sala.id && sala.id != nil{
                    idCalendario = sala.idCalendario!
                }
            }
        } catch {
            print("error")
        }
        // ---> 3
        let event = Evento(context: managedObjectContext)
        event.categoria = categorioa
        event.descricao = descricao
        event.id = UUID().uuidString
        event.dia = dia as NSDate
        event.horario = horario as NSDate
        // ---> 4
        var eventArray = [String]()
        let calendarioRequest = NSFetchRequest<Calendario>.init(entityName: "Calendario")
        do{
            let calendarios = try managedObjectContext.fetch(calendarioRequest)
            for calendario in calendarios{
                if idCalendario == calendario.id && calendario.id != nil{
                    
                    if calendario.idEventos == nil{
                        calendario.idEventos = [event.id] as NSObject
                    } else {
                        eventArray = (calendario.idEventos)!.mutableCopy() as! [String]
                        eventArray.append(event.id!)
                        calendario.idEventos = eventArray as NSObject
                    }
                }
            }
        }catch{
            print("error")
        }
        saveCoreData()
        
        do {
            
            let tasks = try managedObjectContext.fetch(calendarioRequest)
            
            for t in tasks{
                print(t)
            }
            
        } catch{
            
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
            let calendar = CalendarioViewController()
            calendar.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateEvent(event: Evento, descricao: String?, dia: Date, horario: Date, nome: String, participantes: [UUID]) {
        
        event.descricao = descricao
        //        event.categoria = categoria as? String // arrumar isso aqui
        event.dia = dia as NSDate
        event.horario = horario as NSDate
        event.nome = nome
        event.idUsuarios = participantes as NSObject // arrumar isso aqui
        
        saveCoreData()
    }
    
    func deleteEvent(event: Evento) {
        managedObjectContext.delete(event)
        saveCoreData()
    }
    
    func updateUser(user: Usuario,fotoDoPerfil: UIImage?, Nome: String?) {
        
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
    
    //Update perfil e do calendario
    func updatePerfilIdoso(perfil: PerfilUsuario, alergia: String, dataNasc: NSDate, descricao: String, endereco: String, nome: String, planoSaude: String, remedeios: String, telefone: String, tipoSanguinie: String, rg: String) {
        
        perfil.alergias = alergia as! String
        perfil.dataDeNascimento = dataNasc
        perfil.descricao = descricao
        perfil.endereco = endereco
        perfil.nome = nome
        perfil.planoDeSaude = planoSaude
        perfil.remedios = remedeios as! String
        perfil.telefone = telefone
        perfil.rg = rg
        
        saveCoreData()
    }
    
    func deletaEvento(calendario: Calendario, evento: Evento) {
        
        var idEventos = [String]()
        var cont = 0

        let fetch = NSFetchRequest<Calendario>.init(entityName: "Calendario")

        do {

            let calen = try managedObjectContext.fetch(fetch)

            for _ in calen{
                idEventos = (calen as NSArray).mutableCopy() as! [String]
            }
        } catch{
            print(error)
        }
        
        
        for x in idEventos{
            if evento.id == x{
                idEventos.remove(at: cont)
            }
            cont += 1
        }
        
        saveCoreData()
    }
    
    
    func updateEvento(Calendario: Calendario, evento: Evento, categoria: String, descricao: String, dia: Date, horario: Date, nome: String, idUsuarios: [String] ){
        
        evento.categoria = categoria
        evento.descricao = descricao
        evento.dia = dia as NSDate
        evento.horario = horario as NSDate
        evento.nome = nome
        evento.idUsuarios = idUsuarios as NSObject
        saveCoreData()
    }
    
    
    
}


enum Category{
    case doctor
    case fun
    case dinner
    case lunch
}

