//
//  TableViewTaskViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 02/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import CircleBar

class TableViewTaskViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = false
            vc.viewDidLayoutSubviews()
            //vc.self.selectedIndex = 2
            
        }
        setUpDynamicType()
    }
    @IBOutlet weak var horaLabel: UILabel!
    @IBOutlet weak var responLabel: UILabel!
    @IBOutlet weak var notificarEventoLabel: UILabel!
    @IBOutlet weak var notasLabel: UILabel!
    
    @IBOutlet weak var notas: UIView!
    
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var hora: UILabel!
    @IBOutlet weak var responsavel: UILabel!
    @IBOutlet weak var lembrete: UISwitch!
    @IBOutlet weak var descricao: UILabel!
    
    @IBOutlet weak var bolinha: UIImageView!
    @IBOutlet weak var categoriaLabel: UILabel!
    
    func setUpDynamicType(){
        let fontName = "SFProText-Regular"
        
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        horaLabel.font = scaledFont.font(forTextStyle: .body)
        horaLabel.adjustsFontForContentSizeCategory = true
        
        responLabel.font = scaledFont.font(forTextStyle: .body)
        responLabel.adjustsFontForContentSizeCategory = true
        
        notificarEventoLabel.font = scaledFont.font(forTextStyle: .body)
        notificarEventoLabel.adjustsFontForContentSizeCategory = true
        
        notasLabel.font = scaledFont.font(forTextStyle: .body)
        notasLabel.adjustsFontForContentSizeCategory = true
        
        hora.font = scaledFont.font(forTextStyle: .body)
        hora.adjustsFontForContentSizeCategory = true
        
        descricao.font = scaledFont.font(forTextStyle: .body)
        descricao.adjustsFontForContentSizeCategory = true
        
        categoriaLabel.font = scaledFont.font(forTextStyle: .body)
        categoriaLabel.adjustsFontForContentSizeCategory = true
        
        hora.font = scaledFont.font(forTextStyle: .body)
        hora.adjustsFontForContentSizeCategory = true
        
        
    }


}
