//
//  Events.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 22/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation

class Events {
    var ID = Int()
    var title = "title of event"
    var time = "time of event"
    var day = "day of event"
    var desc = "description of event"
    var categ = "category of event"
    var responsavel = "responsable of event"
    var localization = "locatization of event"
    
    init(titleParameter: String,timeParameter: String,descParameter: String,categParameter: String,responsavelParameter: String,localizationParameter: String) {
        self.title = titleParameter
        self.time = timeParameter
        self.desc = descParameter
        self.categ = categParameter
        self.responsavel = responsavelParameter
        self.localization = localizationParameter
    
    }
    
    
    
    
    
    
    
    
}
