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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arredondaIcones()
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
        switch(indexPath.row){
        case 0:
            performSegue(withIdentifier: "perfilIdoso", sender: self)
            
        case 1:
            performSegue(withIdentifier: "usuariosGrupo", sender: self)
        case 2:
            performSegue(withIdentifier: "familia", sender: self)
        case 3:
            performSegue(withIdentifier: "meuPerfil", sender: self)
        default:
            print()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
    func loadCoreDataUsers(){
        
        
        
        
        
    }
    
    
}
