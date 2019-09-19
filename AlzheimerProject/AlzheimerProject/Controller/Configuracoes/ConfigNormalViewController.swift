//
//  ConfigNormalViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 19/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class ConfigNormalViewController: UIViewController {
    let cdr = CoreDataRebased.shared.fetchSala()
    
    @IBOutlet weak var nomeFamilia: UILabel!
    
    @IBOutlet weak var nomeIdoso: UILabel!
    
    @IBOutlet weak var fotoIdoso: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fotoIdoso.clipsToBounds = true
        self.fotoIdoso.layer.cornerRadius = self.fotoIdoso.frame.height/2
        if cdr.nomeFamilia == ""{
            nomeFamilia.text = "Nome da Familia"
            
        } else{
            nomeFamilia.text = cdr.nomeFamilia
        }
        
        if CoreDataRebased.shared.loadProfileData().nome == "" {
            nomeIdoso.text = "Nome do Idoso"
        }else {
             nomeIdoso.text = CoreDataRebased.shared.loadProfileData().nome
        }
        
        
        if CoreDataRebased.shared.loadProfileData().fotoDePerfil == nil{
            fotoIdoso.image = UIImage(named: "ProfileElder")
        } else{
            fotoIdoso.image =  CoreDataRebased.shared.loadProfileData().fotoDePerfil
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
