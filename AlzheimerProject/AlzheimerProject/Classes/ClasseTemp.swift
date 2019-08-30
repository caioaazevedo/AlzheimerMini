////
////  ClasseTemp.swift
////  AlzheimerProject
////
////  Created by Eduardo Airton on 29/08/19.
////  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
////
//
//import Foundation
//import CloudKit
//import UIKit
//
//class ClasseTemp: CoreDataBase {
//
//    private init() {}
//
//    var userID = ""
//
//    //Busca o ID Único do ICLOUD e faz o tratamento de error
//    func iCloudUserIDAsync(complete: @escaping (_ instance: CKRecord.ID?, _ error: NSError?) -> ()) {
//        let container = CKContainer.default()
//        container.fetchUserRecordID() {
//            recordID, error in
//            if error != nil {
//                print(error!.localizedDescription)
//                complete(nil, error as NSError?)
//            } else {
//                //print("fetched ID \(recordID?.recordName ?? "")")
//                complete(recordID, nil)
//            }
//        }
//    }
//
//    func recuperarId(){
//        //Verifica se está logado no icloud
//        if FileManager.default.ubiquityIdentityToken != nil {
//
//            //Chamada da funçao para recuperar o ID
//            iCloudUserIDAsync { (recordID: CKRecord.ID?, error: NSError?) in
//                self.userID = recordID?.recordName ?? "Fetched iCloudID was nil"
//                print("UserID = \(self.userID)")
//            }
//
//        } else {
//
//            print("iCloud Unavailable")
//
//            //Pede que o usuário abra as configurações para que faça o login no icloud
//            func openSettings(alert: UIAlertAction!) {
//                if let url = URL.init(string: UIApplication.openSettingsURLString) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            }
//
//            let alert = UIAlertController(title: "Login no icloud",
//                                          message: "We identify that you are not log in to icloud. Please log in to save your data , ",
//                                          preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Open Settings",
//                                          style: UIAlertAction.Style.default,
//                                          handler: openSettings))
//            alert.addAction(UIAlertAction(title: "Cancel",
//                                          style: UIAlertAction.Style.destructive,
//                                          handler: nil))
//
//
//            //Passar a viewController que deve ser apresentada
//            //self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    let persistenceManager: PersistenceManager
//    func updateEvent(event: Evento, descricao: String?, categoria: category, dia: Int64, horario: Int64, nome: String, participantes: [UUID]) {
//
//        event.descricao = descricao
//        event.categoria = categoria as? String // arrumar isso aqui
//        event.dia = dia
//        event.horario = horario
//        event.nome = nome
//        event.idUsuarios = participantes as NSObject // arrumar isso aqui
//
//        persistenceManager.saveCoreData()
//    }
//
//    func deleteEvent(event: Evento) {
//        managedObjectContext.delete(event)
//        persistenceManager.saveCoreData()
//    }
//
//    func updateUser(user: Usuario,email: String, fotoDoPerfil: UIImage, Nome: String) {
//
//        user.email = email
//        user.fotoPerfil = fotoDoPerfil as! NSData
//        user.nome = Nome
//
//        persistenceManager.saveCoreData()
//    }
//
//}
