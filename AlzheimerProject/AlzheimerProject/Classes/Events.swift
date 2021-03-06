//
//  Events.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 22/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation

class Events {
    var ID = String()
    var title = "title of event"
    var time = "time of event"
    var day = "day of event"
    var desc = "description of event"
    var categ = "category of event"
    var responsavel = [String]()
    var localization = "locatization of event"
    var creationDate = Date()
    
    init(titleParameter: String,timeParameter: String,descParameter: String,categParameter: String,responsavelParameter: [String],localizationParameter: String,idParameter: String) {
        self.title = titleParameter
        self.time = timeParameter
        self.desc = descParameter
        self.categ = categParameter
        self.responsavel = responsavelParameter
        self.localization = localizationParameter
        self.ID = idParameter
    
    }
    
    
    
    
    
    
}
