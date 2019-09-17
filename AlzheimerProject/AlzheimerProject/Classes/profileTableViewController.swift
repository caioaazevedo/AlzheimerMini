//
//  profileTableViewController.swift
//  core
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 09/09/19.
//  Copyright © 2019 Pedro Paulo Feitosa Rodrigues Carneiro. All rights reserved.
//

import UIKit

class profileTableViewController: UITableViewController {
    
    
    @IBOutlet weak var idosoLabel: UILabel!
    @IBOutlet weak var grupoLabel: UILabel!
    
    @IBOutlet weak var nomeDaFamiliaLabel: UILabel!
    
    @IBOutlet weak var meuPerfilLabel: UILabel!
    
    @IBOutlet weak var notificacoesLabel: UILabel!
    
    
    @IBOutlet weak var idosoImage: UIImageView!
    @IBOutlet weak var grupoImage: UIImageView!
    @IBOutlet weak var familiaImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var notificationImage: UIImageView!
    
    @IBOutlet weak var switchBtn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //arredondaIcones()
        tableView.tableFooterView = UIView()
        
        setUpDynamicFonts()
//        fixDynamicTypeForStaticTableViews()
   
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        if switchBtn.isOn{
//            Cloud.setupCloudKitNotifications()
//        } else {
//            Cloud.deleteCloudSubs()
//        }
//    }
    
//    func arredondaIcones(){
//
//        idosoImage.clipsToBounds = true
//        idosoImage.layer.cornerRadius = 20
//
//        grupoImage.clipsToBounds = true
//        grupoImage.layer.cornerRadius = 20
//
//        familiaImage.clipsToBounds = true
//        familiaImage.layer.cornerRadius = 20
//
//        profileImage.clipsToBounds = true
//        profileImage.layer.cornerRadius = 20
//
//        notificationImage.clipsToBounds = true
//        notificationImage.layer.cornerRadius = 20
//
//
//
//    }
//
        
        
        
        
        
        
        
    @IBAction func tuenNot(_ sender: Any) {
        if switchBtn.isOn{
            Cloud.setupCloudKitNotifications()
        } else {
            Cloud.deleteCloudSubs()
        }
    }
    
//    func fixDynamicTypeForStaticTableViews() {
//        // Remove the observer from the table view to prevent it from blanking out the cells
//        NotificationCenter.default.removeObserver(tableView!, name: UIContentSizeCategory.didChangeNotification, object: nil)
//        // Add our own observer and handle it ourselves
//        NotificationCenter.default.addObserver(self, selector: #selector(contentSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
//    }
//
//    @objc func contentSizeChanged() {
//        tableView.reloadData()
//        print("AHAHAHA")
//
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func setUpDynamicFonts(){
        
        
        
        let fontName = "SFProText-Regular"
        
        let scaledFont: ScaledFont = {
            return ScaledFont(fontName: fontName)
        }()
        
        idosoLabel.font = scaledFont.font(forTextStyle: .body)
        idosoLabel.adjustsFontForContentSizeCategory = true
        grupoLabel.font = scaledFont.font(forTextStyle: .body)
        grupoLabel.adjustsFontForContentSizeCategory = true
        nomeDaFamiliaLabel.font = scaledFont.font(forTextStyle: .body)
        nomeDaFamiliaLabel.adjustsFontForContentSizeCategory = true
        meuPerfilLabel.font = scaledFont.font(forTextStyle: .body)
        meuPerfilLabel.adjustsFontForContentSizeCategory = true
        notificacoesLabel.font = scaledFont.font(forTextStyle: .body)
        notificacoesLabel.adjustsFontForContentSizeCategory = true
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.section) - \(indexPath.row)")
        if indexPath.section == 0{
        switch(indexPath.row){
        case 0:
            performSegue(withIdentifier: "perfilIdoso", sender: self)
            
        case 1:
            performSegue(withIdentifier: "grupo", sender: self)
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
    
    
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
    
    
    
    func loadCoreDataUsers(){
        
        
        
        
        
    }
    
    
}
