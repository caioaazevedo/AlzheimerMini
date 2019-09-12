//
//  profileTableViewController.swift
//  core
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 09/09/19.
//  Copyright © 2019 Pedro Paulo Feitosa Rodrigues Carneiro. All rights reserved.
//

import UIKit

class profileTableViewController: UITableViewController {
    
    
    
    @IBOutlet weak var idosoImage: UIImageView!
    @IBOutlet weak var grupoImage: UIImageView!
    @IBOutlet weak var familiaImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var notificationImage: UIImageView!
    
    @IBOutlet weak var idosoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arredondaIcones()
        tableView.tableFooterView = UIView()
   
    }
    
    
    func arredondaIcones(){
        
        idosoImage.clipsToBounds = true
        idosoImage.layer.cornerRadius = 20
        
        grupoImage.clipsToBounds = true
        grupoImage.layer.cornerRadius = 20
        
        familiaImage.clipsToBounds = true
        familiaImage.layer.cornerRadius = 20
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 20
        
        notificationImage.clipsToBounds = true
        notificationImage.layer.cornerRadius = 20
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.section) - \(indexPath.row)")
        if indexPath.section == 0{
        switch(indexPath.row){
        case 0:
            performSegue(withIdentifier: "perfilIdoso", sender: self)
            
        case 1:
            performSegue(withIdentifier: "usuariosGrupo", sender: self)
        case 2:
            performSegue(withIdentifier: "familia", sender: self)
        default:
            print()
        }
        }else{
            if indexPath.row == 0{
                performSegue(withIdentifier: "seguePerfil", sender: self)
            }
        
            
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    
    func loadCoreDataUsers(){
        
        
        
        
        
    }
    
    
}
