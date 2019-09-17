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
    
    // ✅ Deletar todos os eventos
    func deleteAllEvents(){
        let eventFetchRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        
        
        //  1 -> ✅
        do{
            let eventosExistentes = try managedObjectContext.fetch(eventFetchRequest)
            for even in eventosExistentes{
                managedObjectContext.delete(even)
            }
        } catch {
            print("Error")
        }
        CoreDataRebased.shared.saveCoreData()
    }
    
    
    //✅ - Criar sala 😎
    func createSala(nomeFamilia: String){
        
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
        sala.nomeFamilia = nomeFamilia
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
        
        
        
        Cloud.saveSala(nomeFamilia: sala.nomeFamilia!, idSala: sala.id!, idUsuario: [userLoad.idUser], idCalendario: sala.idCalendario!, idPerfil: sala.idPerfil!, idHost: sala.idHost!)
        Cloud.saveUsuario(idUsuario: usuario.id!, nome: usuario.nome!, foto: usuario.fotoPerfil as! Data, idSala: usuario.idSala!, host: usuario.isHost)
        Cloud.saveCalendario(idCalendario: calendar.id!, idEventos: nil)
        Cloud.savePerfil(idPerfil: profile.id!, nome: nil, dataNascimento: nil, telefone: nil, descricao: nil, fotoPerfil: nil, endereco: nil, remedios: nil, alergias: nil, tipoSanguineo: nil, planoSaude: nil)
    }
    
    // ✅ - Fetch do usuario do core data 😎
    func fetchUsuario() -> Usuario {
        let userFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        return try! managedObjectContext.fetch(userFetchRequest)[0]
        
        //        let userLoad = UserLoaded()
        //
        //        //let usuario = Usuario(context: managedObjectContext)
        //        let usuario: Usuario
        //
        //        let userFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")zxc
        //        do {
        //
        //            let usuarios = try managedObjectContext.fetch(userFetchRequest)
        //            usuario = usuarios[0]
        //
        //            for user in usuarios{
        //                if userLoad.idUser == user.id && user.id != nil {
        //                    usuario.id = user.id
        //                    usuario.email = user.email
        //                    usuario.nome = user.nome
        //                    usuario.idSala = user.idSala
        //                }
        //            }
        //        } catch  {
        //            print("Error")
        //        }
        //
        //        return usuario
    }
    
    // ✅ - Fetch do sala do core data 🍁
    func fetchSala() -> Sala{
        
        let salaFetchRequest = NSFetchRequest<Sala>.init(entityName: "Sala")
        return try! managedObjectContext.fetch(salaFetchRequest)[0]
        //
        //        let userLoad = UserLoaded()
        //
        //        let salaCore = Sala(context: managedObjectContext)
        //
        //        do {
        //
        //            let salas = try managedObjectContext.fetch(salaFetchRequest)
        //
        //            for sala in salas{
        //                if userLoad.idSala == sala.id && sala.id != nil {
        //                    salaCore.id = sala.id
        //                    salaCore.idCalendario = sala.idCalendario
        //                    salaCore.idHost = sala.idHost
        //                    salaCore.idPerfil = sala.idPerfil
        //                    salaCore.idUsuarios = sala.idUsuarios
        //                }
        //            }
        //        } catch  {
        //            print("Error")
        //        }
        //
        //        return salaCore
    }
    
    func fetchPessoas() -> [Pessoas]{
        
        let pessoasFetchRequest = NSFetchRequest<Pessoas>.init(entityName: "Pessoas")
        return try! managedObjectContext.fetch(pessoasFetchRequest)
    }
    
    //✅ - Criar Usuario 😎
    func createUsuario(fotoDoPerfil: UIImage?, Nome: String, host: Int64){
        
        let userLoad = UserLoaded()
        
        let user = Usuario(context: managedObjectContext)
        user.id = userLoad.idUser
        user.nome = Nome
        user.idSala = nil
        user.fotoPerfil = fotoDoPerfil?.jpegData(compressionQuality: 0.2) as NSData?
        user.isHost = host
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
        perfil.dataDeNascimento = DadosPerfil.perfil.dataNascimento as NSDate?
        perfil.descricao = DadosPerfil.perfil.descricao
        perfil.endereco = DadosPerfil.perfil.endereco
        perfil.fotoDePerfil = DadosPerfil.perfil.fotoPerfil as NSData?
        perfil.planoDeSaude = DadosPerfil.perfil.planoSaude
        perfil.remedios = DadosPerfil.perfil.remedios as NSObject
        perfil.tipoSanguineo = DadosPerfil.perfil.tipoSanguineo
        perfil.telefone = DadosPerfil.perfil.telefone
        
        CoreDataRebased.shared.saveCoreData()
    }
    
    func reloadUsuario(searchUsuario: String){
        
       //✅ - Carregando informações do informações do Usuario da Nuvem 😎
        
        Cloud.queryUsuario(searchRecord: searchUsuario) { (_) in
            
            Cloud.querySala(searchRecord: DadosUsuario.usuario.idSala) { (_) in
                print(DadosSala.sala.idCalendario)
                
                Cloud.queryCalendario(searchRecord: DadosSala.sala.idCalendario, completion: { (_) in
                    
                    Cloud.queryPerfil(searchRecord: DadosSala.sala.idPerfil, completion: { (_) in
                        self.createSalaGuest()
                    })
                })
                
            }
        }
        
    }
    
    //✅ - Criar Usuario - GUEST 😎
    func createUsuarioGuest(fotoDoPerfil: UIImage?, Nome: String, searchSala: String, host: Int64){
        
        print("Search Sala: ", searchSala)
        
        let userLoad = UserLoaded()
        
        let user = Usuario(context: managedObjectContext)
        user.id = userLoad.idUser
        user.fotoPerfil = fotoDoPerfil?.pngData()! as NSData?
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
                    print("=======> :", user.idSala!)
                    print("=======> :", userArray)
                    
                    
                    Cloud.saveUsuario(idUsuario: user.id!, nome: user.nome, foto: nil, idSala: user.idSala!, host: host)
                    
                    Cloud.updateSala(nomeFamilia: "",searchRecord: searchSala, idSala: DadosSala.sala.idSala, idUsuario: userArray, idCalendario: DadosSala.sala.idCalendario, idPerfil: DadosSala.sala.idPerfil, idHost: DadosSala.sala.idHost)
                    
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
                    user.id = usuario.id
                    user.idSala = usuario.idSala
                    user.nome = usuario.nome ?? ""
                    
                    user.fotoPerfil = UIImage(data: usuario.fotoPerfil! as Data)
                    print(usuario.fotoPerfil)
                }
            }
        } catch {
            print("Error")
        }
        return user
    }
    
    //✅ - Alterar dados usuário 😎
    func updateUser(nome: String, fotoPerfil: UIImage){
        let userLoad = UserLoaded()
        let usuarioFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        do {
            let usuarios = try managedObjectContext.fetch(usuarioFetchRequest)
            
            for usuario in usuarios{
                if userLoad.idUser == usuario.id && usuario.id != nil {
                    usuario.nome = nome
                    usuario.fotoPerfil = fotoPerfil.pngData()! as NSData
                    
                    let photoData = fotoPerfil.pngData()!
                    
                    Cloud.updateUsuario(searchRecord: userLoad.idUser, nome:usuario.nome , foto: photoData, idSala: usuario.idSala ?? "")
                }
            }
        } catch {
            print("Error")
        }
        
        saveCoreData()
    }
    
    // Update Sala
    func updateSala(idUsuarios: [String]){
        let salaFetchRequest = NSFetchRequest<Sala>.init(entityName: "Sala")
        do {
            let sala = try managedObjectContext.fetch(salaFetchRequest)[0]
            
            sala.idUsuarios = idUsuarios as NSObject
        } catch {
            print("Error")
        }
        
        saveCoreData()
    }
    
    //✅ - Criar Evento 🍁
    func createEvent(categoria: String, descricao: String?, dia: Date, horario: Date, responsaveis: [String], nome: String, localizacao: String?, nomeCriador: String){
        

        
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
        event.idCalendario = userLoad.idSalaCalendar
        event.localizacao = localizacao
        event.nomeCriador = nomeCriador
        event.dataCriacao = Date() as NSDate
        var eventArray = [String]()
        
        let calendarioRequest = NSFetchRequest<Calendario>.init(entityName: "Calendario")
        do{
            
            let calendarios = try managedObjectContext.fetch(calendarioRequest)
            for calendario in calendarios{
                if userLoad.idSalaCalendar! == calendario.id && calendario.id != nil{
                    
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
        
        Cloud.saveEvento(idEvento: event.id!, nome: event.nome, categoria: event.categoria!, descricao: event.descricao ?? "", dia: event.dia as! Date, hora: event.horario as! Date, idUsuario: event.idResponsavel, idCalendario: userLoad.idSalaCalendar!, localizacao: event.localizacao ?? "",nomeCriador: nomeCriador, dataCriacao: event.dataCriacao as! Date)
        Cloud.updateCalendario(searchRecord: userLoad.idSalaCalendar!, idEventos: eventArray)
        
        
    }
    
    //✅ - Alterar Evento (Atualizaçao no usuarios participantes) 😎 ****
    func updateEvent(evento: Evento,categoria: String, descricao: String, dia: Date, horario: Date, nome: String, responsaveis: [String],localizacao: String){
        let userLoad = UserLoaded()
        evento.categoria = categoria
        evento.descricao = descricao
        evento.dia = dia as NSDate
        evento.horario = horario as NSDate
        evento.idUsuarios = responsaveis as NSObject
        evento.localizacao = localizacao
        saveCoreData()
        
        Cloud.updateEvento(searchRecord: evento.id!, idEvento: evento.id!, nome: nome , categoria: categoria, descricao: descricao, dia: dia, hora: horario, idUsuario: userLoad.idUser, idCalendario: userLoad.idSalaCalendar!,localizacao: localizacao)
        
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
    func deleteEvento(eventoId: String, completion: @escaping (_ result: [String]) -> ()){
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
                        if id == eventoId{
                            arrayEventos.remove(at: contador)
                            completion(arrayEventos)
                        }
                        contador += 1
                    }
                }
            }
        } catch {
            print("Error")
        }
        saveCoreData()
        let eventoFetchRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        do{
            
            let eventos = try managedObjectContext.fetch(eventoFetchRequest)
            
            for e in eventos{
                if e.id == eventoId{
                    managedObjectContext.delete(e)
                    saveCoreData()
                }
            }
            
            
        } catch{
            print("Error")
        }
        
        
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
                //    prof.fotoDePerfil = UIImage(data: profile.fotoDePerfil! as Data)
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
    
    
    func deleteEvent(eventID: String){
        
        let eventFetchRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        
        do{
            let eventos = try managedObjectContext.fetch(eventFetchRequest)
            for eve in eventos{
                if eve.id == eventID{
                    managedObjectContext.delete(eve)
                }
            }
        } catch{
            print("Error")
        }
        
        
    }
    
    func deleteAll(){
        
        let eventFetchRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        let salaFetchRequest = NSFetchRequest<Sala>.init(entityName: "Sala")
        let usuarioFetchRequest = NSFetchRequest<Usuario>.init(entityName: "Usuario")
        let calendarioFetchRequest = NSFetchRequest<Calendario>.init(entityName: "Calendario")
        let perfilUsuarioFetchRequest = NSFetchRequest<PerfilUsuario>.init(entityName: "PerfilUsuario")
        let FeedFetchRequest = NSFetchRequest<Feed>.init(entityName: "Feed")
        
        
        
        do{
            
            let eventos = try  managedObjectContext.fetch(eventFetchRequest)
            
            for i in eventos{
                managedObjectContext.delete(i)
                saveCoreData()
            }
            let salas = try managedObjectContext.fetch(salaFetchRequest)
            for i in salas{
                managedObjectContext.delete(i)
                saveCoreData()
            }
            let usuarios = try managedObjectContext.fetch(usuarioFetchRequest)
            for i in usuarios{
                managedObjectContext.delete(i)
                saveCoreData()
            }
            let calendarios = try managedObjectContext.fetch(calendarioFetchRequest)
            for i in calendarios{
                managedObjectContext.delete(i)
                saveCoreData()
            }
            let perfis = try managedObjectContext.fetch(perfilUsuarioFetchRequest)
            for i in perfis{
                managedObjectContext.delete(i)
                saveCoreData()
            }
            let feeds = try managedObjectContext.fetch(FeedFetchRequest)
            for i in feeds{
                managedObjectContext.delete(i)
                saveCoreData()
            }
            
        } catch{
            
            print("error")
            
            
        }
        
    }
    
    
    //***TESTES***
    
    func showData(){

        let profRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        do {
            let perfis = try managedObjectContext.fetch(profRequest)
            for i in perfis{
                print(i.id)
                print(i.dia)
                print(i.horario)
            }
        } catch {
        }
        
    }
    // ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
    func recuperarDadosEventos(completion: @escaping (_ result: [feedPerson]) -> (), indici: Int){
        var myFeed : [feedPerson] = []
        let eventosFetchRequest = NSFetchRequest<Evento>.init(entityName: "Evento")
        
        if indici == 0{
            let a = DispatchQueue.global()
            
            a.sync {
                do{
                    let eventos = try managedObjectContext.fetch(eventosFetchRequest)
                    for e in eventos{
                        let formate = DateFormatter()
                        formate.dateFormat = "dd-MM-yyyy"
                        var z = feedPerson(nomeEvento: e.nome ?? "nao tem nome", nomeCriador: e.nomeCriador ?? "nao tem criador", dataEvento: formate.string(from: e.dia! as Date), fotoCriador: nil, idCriador: e.idResponsavel ?? "nao tem", dataCriada: e.dataCriacao as! Date)
                        myFeed.append(z)
                    } //17FBCDF6-BA84-46E0-B70E-32A7E1D8743E
                } catch{
                }
            }
            a.sync {
                completion(myFeed)
            }
            
        } else {
            let b = DispatchQueue.global()
            
            b.sync {
                do{
                    let eventos = try managedObjectContext.fetch(eventosFetchRequest)
                    for e in eventos{
                        let formate = DateFormatter()
                        formate.dateFormat = "dd-MM-yyyy"
                        if e.idResponsavel == UserLoaded().idUser{
                            var z = feedPerson(nomeEvento: e.nome ?? "nao tem nome", nomeCriador: e.nomeCriador ?? "nao tem criador", dataEvento: formate.string(from: e.dia! as Date), fotoCriador: nil, idCriador: e.idResponsavel ?? "nao tem", dataCriada: e.dataCriacao as! Date)
                            myFeed.append(z)
                        }
                    }
                } catch{
                }
            }
            b.sync {
                completion(myFeed)
            }
            
            
        }
        

    }
 
    
    func getImages(){
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Usuarios", predicate: predicate)
        let queryOp = CKQueryOperation(query: query)
        queryOp.queuePriority = .veryHigh
        queryOp.recordFetchedBlock = { (record) -> Void in
            if record["idSala"] == UserLoaded().getSalaID(){
                let imgUsr = ImagensEId(context: managedObjectContext)
                imgUsr.id = record["idUsuario"]
                imgUsr.imagem = record["foto"] as? NSData
                self.saveCoreData()
            }
        }
    }
    
}







struct userData {
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

struct feedPerson{
    var nomeEvento: String
    var nomeCriador: String
    var dataEvento : String
    var fotoCriador: UIImage?
    var idCriador: String
    var dataCriada: Date
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

