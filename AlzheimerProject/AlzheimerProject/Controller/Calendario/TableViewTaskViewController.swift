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
    }
    
    @IBOutlet weak var notas: UIView!
    @IBOutlet weak var categoria: UIImageView!
    @IBOutlet weak var hora: UILabel!
    @IBOutlet weak var responsavel: UILabel!
    @IBOutlet weak var lembrete: UISwitch!
    @IBOutlet weak var descricao: UILabel!
    
    @IBOutlet weak var bolinha: UIImageView!
    @IBOutlet weak var categoriaLabel: UILabel!
    
    


}
