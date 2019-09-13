//
//  CellCalendar.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 22/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation
import UIKit

class CellCalendar :  UITableViewCell {

    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var horario: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var responsavel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        bounds = bounds.inset(by: padding)
    }
    
}
