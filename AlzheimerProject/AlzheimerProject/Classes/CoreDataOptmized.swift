//
//  CoreDataOptmized.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 01/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CloudKit


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedObjectContext = appDelegate.persistentContainer.viewContext


class CoreDataRebased{
    
     var userID = ""
    
    private init(){
    }
    static var shared = CoreDataRebased()
    
    //MISC
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
        }
    }
    
    //✅ - Criar sala
    func createSala(){
        
        let userLoad = UserLoaded()
        
        let sala = Sala(context: managedObjectContext)
        let profile = PerfilUsuario(context: managedObjectContext)
        let calendar = Calendario(context: managedObjectContext)
        let usuarioFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        sala.id = UUID().uuidString
        profile.id = UUID().uuidString
        calendar.id = UUID().uuidString
        
        // Recuperar o id do host e atribuir o id dele aos campos "Usuarios" e "hostID"
        // atribuir nil para os campos que serão prenchidos depois aka "telefone"
        sala.telefoneUsuarios = nil
        
        // atribuir a Sala seu calendario e perfil
        sala.calendario = calendar
        sala.perfilUsuario = profile
        sala.idHost = userLoad.idUser
        sala.idUsuarios = [userLoad.idUser] as NSObject
        
        sala.idCalendario = calendar.id
        sala.idPerfil = profile.id
        
        do {
            let usuarioo = try managedObjectContext.fetch(usuarioFetchRequest)
            for usuario in usuarioo{
                if usuario.id == sala.idHost{
                    usuario.idSala = sala.id
                    print(usuario)
                }
            }
        } catch{
            print("error")
        }
        
        saveCoreData()

        
    }
    //✅ - Criar Usuario
    func createUsuario(email: String, fotoDoPerfil: UIImage?, Nome: String){

        let user = Usuario(context: managedObjectContext)
        user.id = userID
        user.email = email
        user.nome = Nome
        user.idSala = nil
        saveCoreData()
        
    }
    //✅ - Carregar dados Usuario
    func loadUserData() -> userData{
        let userLoad = UserLoaded()
        var user = userData()
        let usuarioFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        do {
            let usuarios = try managedObjectContext.fetch(usuarioFetchRequest)
            for usuario in usuarios {
                if userLoad.idUser == usuario.id && usuario.id != nil {
                    user.email = usuario.email
                    user.id = usuario.id
                    user.idSala = usuario.idSala
                    user.nome = usuario.nome
                }
            }
        } catch {
            print("Error")
        }
        return user
    }
    //✅ - Alterar dados usuário
    func updateUser(email: String, nome: String, fotoPerfil: UIImage){
        let userLoad = UserLoaded()
        let usuarioFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        do {
            let usuarios = try managedObjectContext.fetch(usuarioFetchRequest)
            
            for usuario in usuarios{
                if userLoad.idUser == usuario.id && usuario.id != nil {
                    usuario.email = email
                    usuario.nome = nome
//                    usuario.fotoPerfil = fotoPerfil
                }
            }
        } catch {
            print("Error")
        }
        saveCoreData()
    }
    //✅ - Criar Evento
    func createEvent(categoria: String, descricao: String, dia: Int64, horario: Int64){
        let userLoad = UserLoaded()
        let event = Evento(context: managedObjectContext)
        event.categoria = categoria
        event.descricao = descricao
        event.id = UUID().uuidString
        event.dia = dia
        event.horario = horario
        var eventArray = [String]()
        let calendarioRequest = NSFetchRequest<Calendario>.init(entityName: "Calendario")
        do{
            let calendarios = try managedObjectContext.fetch(calendarioRequest)
            for calendario in calendarios{
                if userLoad.idSalaCalendar == calendario.id && calendario.id != nil{
                    
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
    }
    //✅ - Alterar Evento (Atualizaçao no usuarios participantes)
    func updateEvent(evento: Evento,categoria: String, descricao: String, dia: Int64, horario: Int64){
        evento.categoria = categoria
        evento.descricao = descricao
        evento.dia = dia
        evento.horario = horario
        saveCoreData()
    }
    //✅ - Carregar Dados Evento
    func loadEvent(evento: Evento) -> eventData{
        var event = eventData()
        event.categoria = evento.categoria
        event.descricao = evento.descricao
        event.dia = evento.dia
        event.horario = evento.horario
        event.nome = evento.nome
        
        return event
    }
    //✅ - Deletar Evento
    func deleteEvento(evento: Evento){
       /*
        1. Transformar o array de idEventos em [String]
        2. Procurar o evento com o mesmo id do parametro passado
        3. Remover o evento no índice "X"
        4. Sobreescrever o vetor
        */
        let userLoad = UserLoaded()
        var contador = 0
        let calendarioFetchRequest = NSFetchRequest<Calendario>.init(entityName: "Calendario")
        var arrayEventos = [String]()
        do {
            let calendarios = try managedObjectContext.fetch(calendarioFetchRequest)
            
            for calendario in calendarios {
                if userLoad.idSalaCalendar == calendario.id && calendario.id != nil{
                    arrayEventos = (calendario.idEventos)?.mutableCopy() as! [String]
                    for id in arrayEventos {
                        if id == evento.id{
                            arrayEventos.remove(at: contador)
                        }
                        contador += 1
                    }
                }
            }
        } catch {
            print("Error")
        }
        saveCoreData()
    }
    //✅ - Carregar Dados Profile
    func loadProfileData() -> profileData{
        
        var prof = profileData()
        let userLoad = UserLoaded()
        let profileFetchRequest = NSFetchRequest<PerfilUsuario>.init(entityName: "PerfilUsuario")
        do {
            let profiles = try managedObjectContext.fetch(profileFetchRequest)
            for profile in profiles {
                if userLoad.idSalaProfile == profile.id && profile.id != nil {
                    prof.alergias = profile.alergias ?? ""
                    prof.Descricao = profile.descricao  ?? ""
                    prof.nome = profile.nome ?? ""
                    prof.endereco = profile.endereco ?? ""
                    prof.telefone = profile.telefone ?? ""
//                    prof?.fotoDePerfil = profile.fotoDePerfil
                    prof.planoDeSaude = profile.planoDeSaude ?? ""
                    prof.remedios = profile.remedios ?? ""
                    prof.tipoSanguineo = profile.tipoSanguineo ?? ""
                }
            }
        } catch {
            print("error")
        }
        return prof
    }
    //✅ - Alterar Dados Profile
    func updateProfile(alergias: String?, dataDeNascimento: Date?, descricao: String?, endereco: String?, fotoDePerfil: UIImage?, nome: String?, planoDeSaude: String?, remedios: String?, telefone: String?, tipoSanguineo: String?){
        let userLoad = UserLoaded()
        let profileFetchRequest = NSFetchRequest<PerfilUsuario>.init(entityName: "PerfilUsuario")
        
        do{
            let profiles = try managedObjectContext.fetch(profileFetchRequest)
            for prof in profiles{
                if userLoad.idSalaProfile == prof.id && prof.id != nil{
                    prof.alergias = alergias
                    prof.dataDeNascimento = dataDeNascimento as NSDate?
                    prof.descricao = descricao
                    prof.endereco = endereco
//                    prof.fotoDePerfil = fotoDePerfil as! NSData
                    prof.nome = nome
                    prof.telefone = telefone
                    prof.tipoSanguineo = tipoSanguineo
                    prof.remedios = remedios
                }
            }
        } catch {
            print("Error")
        }
        
        
        saveCoreData()
    }
    
    //***TESTES***
    
    func showData(){
        let profRequest = NSFetchRequest<Calendario>.init(entityName: "Calendario")
        do {
            let perfis = try managedObjectContext.fetch(profRequest)
            for i in perfis{
                print(i.idEventos)
            }
        } catch {
        }
    }
    
}
struct userData {
    var email : String?
    var fotoPerfil : UIImage?
    var id : String!
    var idSala : String?
    var nome : String?
}
struct eventData {
    var categoria : String?
    var descricao : String?
    var dia : Int64?
    var horario : Int64?
    var nome : String?
}
struct profileData {
    var alergias : String?
//    var dataDeNascimento : Date?
    var Descricao : String?
    var endereco : String?
//    var fotoDePerfil : UIImage?
    var nome : String?
    var planoDeSaude : String?
    var remedios : String?
    var telefone : String?
    var tipoSanguineo : String?
}
