//
//  Dados.swift
//  AlzheimerProject
//
//  Created by Caio Azevedo on 29/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

class DadosSala {
    var idSala = String()
    var idUsuarios = [String]()
    var idCalendario = String()
    var idPerfil = String()
    var idHost = String()
    
    private init(){
        
    }
    
    static var sala = DadosSala()
    
    
    
//    init(idSala: String, idUsuarios: [String], idCalendario: String, idPerfil: String, idHost: String) {
//        self.idSala = idSala
//        self.idUsuarios = idUsuarios
//        self.idCalendario = idCalendario
//        self.idPerfil = idPerfil
//        self.idHost = idHost
//    }
    
}
