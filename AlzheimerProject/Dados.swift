//
//  Dados.swift
//  AlzheimerProject
//
//  Created by Caio Azevedo on 29/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class DadosSala {
    var nomeFamilia = String()
    var idSala = String()
    var idUsuarios = [String]()
    var idCalendario = String()
    var idPerfil = String()
    var idHost = String()
    
    private init(){
        
    }
    
    static var sala = DadosSala()
    
}

class DadosUsuario {
    var idUsuario = String()
    var nome = String()
    var foto = Data()
    var idSala = String()
    
    private init(){
        
    }
    
    static var usuario = DadosUsuario()
    
}

class DadosClendario {
    var idCalendario = String()
    var idEventos = [String]()
    
    private init(){
        
    }
    
    static var calendario = DadosClendario()
    
}

class DadosPerfil {
    var idPerfil = String()
    var nome = String()
    var dataNascimento: Date?
    var telefone = String()
    var descricao = String()
    var fotoPerfil: Data?
    var endereco = String()
    var remedios = [String]()
    var alergias = [String]()
    var tipoSanguineo = String()
    var planoSaude = String()
    
    private init(){
        
    }
    
    static var perfil = DadosPerfil()
    
}

class DadosEvento {
    var idEvento = String()
    var nome = String()
    var categoria = String()
    var descricao = String()
    var dia = Date()
    var hora = Date()
    var idUsuario = String()
    var idClendario = String()
    
    private init(){
        
    }
    
    static var evento = DadosEvento()
    
}

class DadosArrayUsuarios {
    var id = [String]()
    var foto: [Data]?
    var nome = [String]()
    
    private init(){
        
    }
    
    static var array = DadosArrayUsuarios()
    
}

var ckData: [(String, String, Data)] = []
