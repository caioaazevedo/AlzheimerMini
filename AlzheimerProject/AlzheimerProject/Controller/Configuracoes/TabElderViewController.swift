//
//  TabElderViewController.swift
//  AlzheimerProject
//
//  Created by Caio Azevedo on 25/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class TabElderViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLabelNrml()
        setLabelBold()
        
    }
    
    
    @IBOutlet weak var dataNasc: UITextField!
    @IBOutlet weak var RG: UITextField!
    @IBOutlet weak var tipo: UITextField!

    @IBOutlet weak var plano: UITextField!
    @IBOutlet weak var telefone: UITextField!
    
    @IBOutlet weak var endereco: UITextView!
    @IBOutlet weak var alergia: UITextView!
    @IBOutlet weak var medicamento: UITextView!
    @IBOutlet weak var observacoes: UITextView!
    
    
    @IBOutlet weak var dataNascBold: UILabel!
    
    @IBOutlet weak var rgBold: UILabel!
    
    @IBOutlet weak var telefoneBold: UILabel!
    
    @IBOutlet weak var planoBold: UILabel!
    
    @IBOutlet weak var tipoBold: UILabel!
    
    @IBOutlet weak var medicamentoBold: UILabel!
    
    @IBOutlet weak var alergiaBold: UILabel!
    
    @IBOutlet weak var enderecoBold: UILabel!
    
    @IBOutlet weak var obsBold: UILabel!
    
    func setLabelBold(){
        
        let fontName = "SFProText-Bold"
        
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        dataNascBold.font = scaledFont.font(forTextStyle: .body)
        dataNascBold.adjustsFontForContentSizeCategory = true
        
        rgBold.font = scaledFont.font(forTextStyle: .body)
        rgBold.adjustsFontForContentSizeCategory = true
        
        tipoBold.font = scaledFont.font(forTextStyle: .body)
        tipoBold.adjustsFontForContentSizeCategory = true
        
        planoBold.font = scaledFont.font(forTextStyle: .body)
        planoBold.adjustsFontForContentSizeCategory = true
        
        telefoneBold.font = scaledFont.font(forTextStyle: .body)
        telefoneBold.adjustsFontForContentSizeCategory = true
        
        enderecoBold.font = scaledFont.font(forTextStyle: .body)
        enderecoBold.adjustsFontForContentSizeCategory = true
        
        alergia.font = scaledFont.font(forTextStyle: .body)
        alergia.adjustsFontForContentSizeCategory = true
        
        medicamentoBold.font = scaledFont.font(forTextStyle: .body)
        medicamentoBold.adjustsFontForContentSizeCategory = true
        
        obsBold.font = scaledFont.font(forTextStyle: .body)
        obsBold.adjustsFontForContentSizeCategory = true
        
        
        
    }
    
    func setLabelNrml(){
        let fontName = "SFProText-Regular"
        
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        dataNasc.font = scaledFont.font(forTextStyle: .body)
        dataNasc.adjustsFontForContentSizeCategory = true
        
        RG.font = scaledFont.font(forTextStyle: .body)
        RG.adjustsFontForContentSizeCategory = true
        
        tipo.font = scaledFont.font(forTextStyle: .body)
        tipo.adjustsFontForContentSizeCategory = true
        
        plano.font = scaledFont.font(forTextStyle: .body)
        plano.adjustsFontForContentSizeCategory = true
        
        telefone.font = scaledFont.font(forTextStyle: .body)
        telefone.adjustsFontForContentSizeCategory = true
        
        endereco.font = scaledFont.font(forTextStyle: .body)
        endereco.adjustsFontForContentSizeCategory = true
        
        alergia.font = scaledFont.font(forTextStyle: .body)
        alergia.adjustsFontForContentSizeCategory = true
        
        medicamento.font = scaledFont.font(forTextStyle: .body)
        medicamento.adjustsFontForContentSizeCategory = true
        
        observacoes.font = scaledFont.font(forTextStyle: .body)
        observacoes.adjustsFontForContentSizeCategory = true
        
        
        
        
        
        
    }
    
    var selecionado = Int()
    var flag = 0
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selecionado = indexPath.row
        tableView.reloadData()
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selecionado == indexPath.row && selecionado > 4 {
            flag += 1
            if flag == 2{
                flag = 0
                return 98
            }
            return 220
            
        }
        return 98
    }
    
    
    

}

class cellConfig: UITableViewCell{
    
    
    
    
}
