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
    
    //✅ - Criar sala 😎
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
        /*
         1. Fetch do usuario
         Dados de Sala e Usuario prontos para uso
         */
        
        let usuario = fetchUsuario()
        
        
        
        Cloud.saveSala(idSala: sala.id!, idUsuario: [userLoad.idUser], idCalendario: sala.idCalendario!, idPerfil: sala.idPerfil!, idHost: sala.idHost!)
        Cloud.saveUsuario(idUsuario: usuario.id!, nome: usuario.nome!, foto: nil, email: usuario.email, idSala: usuario.idSala!)
        Cloud.saveCalendario(idCalendario: calendar.id!, idEventos: nil)
        Cloud.savePerfil(idPerfil: profile.id!, nome: nil, dataNascimento: nil, telefone: nil, descricao: nil, fotoPerfil: nil, endereco: nil, remedios: nil, alergias: nil, tipoSanguineo: nil, planoSaude: nil)
    }
    
    // ✅ - Fetch do usuario do core data 😎
    func fetchUsuario() -> Usuario{
        
        let userLoad = UserLoaded()
        
        let usuario = Usuario(context: managedObjectContext)
        
        let userFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        do {
            
            let usuarios = try managedObjectContext.fetch(userFetchRequest)
            
            for user in usuarios{
                if userLoad.idUser == user.id && user.id != nil {
                    usuario.id = user.id
                    usuario.email = user.email
                    usuario.nome = user.nome
                    usuario.idSala = user.idSala
                }
            }
        } catch  {
            print("Error")
        }
        
        return usuario
    }
    
    // ✅ - Fetch do sala do core data 🍁
    func fetchSala() -> Sala{
        
        let userLoad = UserLoaded()
        
        let salaCore = Sala(context: managedObjectContext)
        
        let salaFetchRequest = NSFetchRequest<Sala>.init(entityName: "Sala")
        do {
            
            let salas = try managedObjectContext.fetch(salaFetchRequest)
            
            for sala in salas{
                if userLoad.idSala == sala.id && sala.id != nil {
                    salaCore.id = sala.id
                    salaCore.idCalendario = sala.idCalendario
                    salaCore.idHost = sala.idHost
                    salaCore.idPerfil = sala.idPerfil
                    salaCore.idUsuarios = sala.idUsuarios
                }
            }
        } catch  {
            print("Error")
        }
        
        return salaCore
    }
    
    //✅ - Criar Usuario 😎
    func createUsuario(email: String, fotoDoPerfil: UIImage?, Nome: String){
        
        let userLoad = UserLoaded()
        
        let user = Usuario(context: managedObjectContext)
        user.id = userLoad.idUser
        user.email = email
        user.nome = Nome
        user.idSala = nil
        user.fotoPerfil = fotoDoPerfil?.pngData()! as NSData?
        saveCoreData()
        
        
        
    }
    
    //✅ - Criar Sala Guest 😎
    func createSalaGuest(){
        let sala = Sala(context: managedObjectContext)
        let calendario = Calendario(context: managedObjectContext)
        let perfil = PerfilUsuario(context: managedObjectContext)
        
        sala.id = DadosSala.sala.idSala
        sala.idHost = DadosSala.sala.idHost
        sala.idUsuarios = DadosSala.sala.idUsuarios as NSObject
        sala.idCalendario = DadosSala.sala.idCalendario
        sala.idPerfil = DadosSala.sala.idPerfil
        
        sala.calendario = calendario
        sala.perfilUsuario = perfil
        
        calendario.id = DadosSala.sala.idCalendario
        calendario.idEventos = DadosClendario.calendario.idEventos as NSObject
        
        perfil.id = DadosSala.sala.idPerfil
        
        perfil.nome = DadosPerfil.perfil.nome
        perfil.alergias = DadosPerfil.perfil.alergias as NSObject
        perfil.dataDeNascimento = DadosPerfil.perfil.dataNascimento as NSDate
        perfil.descricao = DadosPerfil.perfil.descricao
        perfil.endereco = DadosPerfil.perfil.endereco
        perfil.fotoDePerfil = DadosPerfil.perfil.fotoPerfil as NSData
        perfil.planoDeSaude = DadosPerfil.perfil.planoSaude
        perfil.remedios = DadosPerfil.perfil.remedios as NSObject
        perfil.tipoSanguineo = DadosPerfil.perfil.tipoSanguineo
        perfil.telefone = DadosPerfil.perfil.telefone
        
        CoreDataRebased.shared.saveCoreData()
    }
    
    //✅ - Criar Usuario - GUEST 😎
    func createUsuarioGuest(email: String, fotoDoPerfil: UIImage?, Nome: String, searchSala: String){
        
        let userLoad = UserLoaded()
        
        let user = Usuario(context: managedObjectContext)
        user.id = userLoad.idUser
        user.fotoPerfil = fotoDoPerfil?.pngData()! as NSData?
        user.email = email
        user.nome = Nome
        
        
        Cloud.querySala(searchRecord: searchSala) { (_) in
            print(DadosSala.sala.idCalendario)
            
            Cloud.queryCalendario(searchRecord: DadosSala.sala.idCalendario, completion: { (_) in
                
                Cloud.queryPerfil(searchRecord: DadosSala.sala.idPerfil, completion: { (_) in
                    self.createSalaGuest()
                    user.idSala = searchSala
                    print("ACABOU")
                    let sala = self.fetchSala()
                    var userArray = (DadosSala.sala.idUsuarios)
                    userArray.append(user.id!)
                    sala.idUsuarios = userArray as NSObject
                    CoreDataRebased.shared.saveCoreData()
                    print(user.id!)
                    let userIdent = user.id
                    
                    
                    Cloud.saveUsuario(idUsuario: userIdent ?? "", nome: user.nome, foto: nil, email: user.email, idSala: user.idSala!)
                    Cloud.updateSala(searchRecord: searchSala, idSala: DadosSala.sala.idSala, idUsuario: userArray, idCalendario: DadosSala.sala.idCalendario, idPerfil: DadosSala.sala.idPerfil, idHost: DadosSala.sala.idHost)
                    
                })
            })
            
        }
        
        
    }
    
    // MARK: ✅ - Carregar dados Usuario 😎
    func loadUserData() -> userData{
        let userLoad = UserLoaded()
        var user = userData()
        
        let usuarioFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        do {
            let usuarios = try managedObjectContext.fetch(usuarioFetchRequest)
            for usuario in usuarios {
                if userLoad.idUser == usuario.id && usuario.id != nil {
                    user.email = usuario.email ?? ""
                    user.id = usuario.id
                    user.idSala = usuario.idSala
                    user.nome = usuario.nome ?? ""
                    user.fotoPerfil = UIImage(data: usuario.fotoPerfil! as Data)
                }
            }
        } catch {
            print("Error")
        }
        return user
    }
    
    //✅ - Alterar dados usuário 😎
    func updateUser(email: String, nome: String, fotoPerfil: UIImage){
        let userLoad = UserLoaded()
        let usuarioFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        do {
            let usuarios = try managedObjectContext.fetch(usuarioFetchRequest)
            
            for usuario in usuarios{
                if userLoad.idUser == usuario.id && usuario.id != nil {
                    usuario.email = email
                    usuario.nome = nome
                    usuario.fotoPerfil = fotoPerfil.pngData()! as NSData
                    
                    let photoData = fotoPerfil.pngData()!
                    
                    Cloud.updateUsuario(searchRecord: userLoad.idUser, nome:usuario.nome , foto: photoData, email: usuario.email, idSala: usuario.idSala ?? "")
                }
            }
        } catch {
            print("Error")
        }
        
        
        
        
        
        
        saveCoreData()
    }
    
    //✅ - Criar Evento 🍁
    func createEvent(categoria: String, descricao: String, dia: Date, horario: Date, responsaveis: [String], nome: String){
        let userLoad = UserLoaded()
        let event = Evento(context: managedObjectContext)
        event.categoria = categoria
        event.descricao = descricao
        event.nome = nome
        event.id = UUID().uuidString
        event.dia = dia as NSDate
        event.horario = horario as NSDate
        event.idResponsavel = userLoad.idUser
        event.idUsuarios = responsaveis as NSObject
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
        
        Cloud.saveEvento(idEvento: event.id!, nome: event.nome, categoria: event.categoria!, descricao: event.descricao!, dia: Date(), hora: Timer(), idUsuario: nil, idCalendario: userLoad.idSalaCalendar!)
        Cloud.updateCalendario(searchRecord: userLoad.idSalaCalendar!, idEventos: eventArray)
        
        
    }
    
    //✅ - Alterar Evento (Atualizaçao no usuarios participantes) 😎 ****
    func updateEvent(evento: Evento,categoria: String, descricao: String, dia: Date, horario: Date, nome: String){
        let userLoad = UserLoaded()
        evento.categoria = categoria
        evento.descricao = descricao
        evento.dia = dia as NSDate
        evento.horario = horario as NSDate
        saveCoreData()
        
        let a = Date(timeInterval: 20, since: Date())
        let b = Timer(fire: a, interval: 2, repeats: false) { (Timer) in
        }
        
        Cloud.updateEvento(searchRecord: evento.id!, idEvento: evento.id!, nome: nome , categoria: categoria, descricao: descricao, dia: a, hora: b, idUsuario: userLoad.idUser, idCalendario: userLoad.idSalaCalendar!)
        
    }
    
    //✅ - Carregar Dados Evento 😎
    func loadEvent(evento: Evento) -> eventData{
        var event = eventData()
        event.categoria = evento.categoria ?? ""
        event.descricao = evento.descricao ?? ""
        event.dia = evento.dia as Date?
        event.horario = evento.horario as Date?
        event.nome = evento.nome ?? ""
        
        return event
    }
    
    //✅ - Deletar Evento 🍁
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
    
    //✅ - Carregar Dados Profile 🍁
    func loadProfileData() -> profileData{
        
        var prof = profileData()
        let userLoad = UserLoaded()
        let profileFetchRequest = NSFetchRequest<PerfilUsuario>.init(entityName: "PerfilUsuario")
        do {
            let profiles = try managedObjectContext.fetch(profileFetchRequest)
            for profile in profiles {
                if userLoad.idSalaProfile == profile.id && profile.id != nil {
                    prof.alergias = profile.alergias as? [String]
                    prof.Descricao = profile.descricao  ?? ""
                    prof.nome = profile.nome ?? ""
                    prof.endereco = profile.endereco ?? ""
                    prof.telefone = profile.telefone ?? ""
                    prof.fotoDePerfil = UIImage(data: profile.fotoDePerfil! as Data)
                    prof.planoDeSaude = profile.planoDeSaude ?? ""
                    prof.remedios = profile.remedios as? [String]
                    prof.tipoSanguineo = profile.tipoSanguineo ?? ""
                    
                }
            }
        } catch {
            print("error")
        }
        return prof
        
    }
    
    //✅ - Alterar Dados Profile 🍁
    func updateProfile(alergias: [String]?, dataDeNascimento: Date?, descricao: String?, endereco: String?, fotoDePerfil: UIImage?, nome: String?, planoDeSaude: String?, remedios: [String]?, telefone: String?, tipoSanguineo: String?){
        let userLoad = UserLoaded()
        let profileFetchRequest = NSFetchRequest<PerfilUsuario>.init(entityName: "PerfilUsuario")
        
        do{
            let profiles = try managedObjectContext.fetch(profileFetchRequest)
            for prof in profiles{
                if userLoad.idSalaProfile == prof.id && prof.id != nil{
                    prof.alergias = alergias as NSObject?
                    prof.dataDeNascimento = dataDeNascimento as NSDate?
                    prof.descricao = descricao ?? ""
                    prof.endereco = endereco ?? ""
                    prof.fotoDePerfil = fotoDePerfil?.pngData()! as NSData?
                    prof.nome = nome ?? ""
                    prof.telefone = telefone ?? ""
                    prof.tipoSanguineo = tipoSanguineo ?? ""
                    prof.remedios = remedios as NSObject?
                    
                    
                    Cloud.updatePerfil(searchRecord: userLoad.idSalaProfile!, idPerfil: userLoad.idSalaProfile!, nome: nome ?? "", dataNascimento: dataDeNascimento ?? Date(), telefone: telefone ?? "", descricao: descricao ?? "", fotoPerfil: fotoDePerfil?.pngData()!, endereco: endereco ?? "", remedios: remedios, alergias: alergias, tipoSanguineo: tipoSanguineo ?? "", planoSaude: planoDeSaude ?? "")
                    
                }
            }
        } catch {
            print("Error")
        }
        
        
        saveCoreData()
    }
    
    //***TESTES***
    
    func showData(){
        let profRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        do {
            let perfis = try managedObjectContext.fetch(profRequest)
            for i in perfis{
                print(i.nome)
                
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
    var dia : Date?
    var horario : Date?
    var nome : String?
}
struct profileData {
    var alergias : [String]?
    var dataDeNascimento : Date?
    var Descricao : String?
    var endereco : String?
    var fotoDePerfil : UIImage?
    var nome : String?
    var planoDeSaude : String?
    var remedios : [String]?
    var telefone : String?
    var tipoSanguineo : String?
}


/*
 1 -> ORDEM PARA CRIAR A SALA DO HOST
 
 A. CoreDataRebased.shared.createUsuario(email: <#T##String#>, fotoDoPerfil: <#T##UIImage?#>, Nome: <#T##String#>)
 B. CoreDataRebased.shared.createSala()
 
 2 -> ORDEM PARA CRIAR SALA DO GUEST
 
 A. CoreDataRebased.shared.createUsuarioGuest(email: <#T##String#>, fotoDoPerfil: <#T##UIImage?#>, Nome: <#T##String#>, searchSala: <#T##String#>)
 B. CoreDataRebased.shared.createSalaGuest()
 
 3 -> ORDEM PARA CRIAR EVENTO
 
 A. CoreDataRebased.shared.createEvent(categoria: <#T##String#>, descricao: <#T##String#>, dia: <#T##Date#>, horario: <#T##Date#>, responsaveis: <#T##[String]#>, nome: <#T##String#>)
 
 4 -> ORDEM PARA ATUALIZAR OS DADOS DO PROFILE DO IDOSO
 
 A. var usuarioLoad = CoreDataRebased.shared.loadProfileData() "RETORNA UMA STRUCT"
 B. CoreDataRebased.shared.updateProfile(alergias: <#T##[String]?#>, dataDeNascimento: <#T##Date?#>, descricao: <#T##String?#>, endereco: <#T##String?#>, fotoDePerfil: <#T##UIImage?#>, nome: <#T##String?#>, planoDeSaude: <#T##String?#>, remedios: <#T##[String]?#>, telefone: <#T##String?#>, tipoSanguineo: <#T##String?#>)
 
 5 -> ORDEM PARA ATUALIZAR OS DADOS USUARIO
 
 A. var usuarioLoad = CoreDataRebased.shared.loadUserData() "RETORNA UMA STRUCT"
 B. CoreDataRebased.shared.updateUser(email: <#T##String#>, nome: <#T##String#>, fotoPerfil: <#T##UIImage#>)
 
 6 -> ORDEM PARA ATUALIZAR OS DADOS EVENTO
 
 A. var eventoLoad = CoreDataRebased.shared.loadEvent(evento: <#T##Evento#>) "RETORNA UMA STRUCT"
 B. CoreDataRebased.shared.updateEvent(evento: <#T##Evento#>, categoria: <#T##String#>, descricao: <#T##String#>, dia: <#T##Date#>, horario: <#T##Date#>, nome: <#T##String#>)
 
 7 -> MISC DE METODOS QUE SERÃ0 CHAMADOS DEPOIS QUE O USUARIO JA TIVER ENTRADO EM UMA SALA COMO HOST OU GUEST
 
 A.Cloud.updateAllEvents()
 B.Cloud.updateCalendario()
 C.Cloud.updateUsuarioProfile()
 D.Cloud.updateSala()
 
 8 -> METODOS PARA CHAMAR NAS RELOADS
 
 A.Cloud.updateAllEvents()
 B.Cloud.updateCalendario()
 C.Cloud.updateUsuarioProfile()
 D.Cloud.updateSala()
 */
