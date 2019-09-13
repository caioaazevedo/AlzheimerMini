//
//  GroupTableViewController.swift
//  AlzheimerProject
//
//  Created by Caio Azevedo on 13/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//
/*
 1. Copiar o que esta no coredata PEssoas para um array
 2. Popular o array com os dados.
 3. Carregar a view
 4.
 5.
 
 
 */


import UIKit

class GroupTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableGroup: UITableView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Cloud.getPeople {
            DispatchQueue.main.async {
                self.tableGroup.reloadData()
            }
        }
        
        self.shareButton.layer.cornerRadius = 11
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableGroup.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sala = CoreDataRebased.shared.fetchSala()
        let usuarios = (sala.idUsuarios as! NSArray).mutableCopy() as! [String]
        
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellG", for: indexPath) as! GroupCell
        
        let sala = CoreDataRebased.shared.fetchSala()
        let usuarios = (sala.idUsuarios as! NSArray).mutableCopy() as! [String]
        
        if ckData.count > 0 {
            for i in 0...usuarios.count-1{
                for j in 0...ckData.count-1{
                    if usuarios[i] == ckData[j].0 {
                        cell.imageGroup.image = UIImage(data: ckData[j].2)
                        cell.labelGroup.text = ckData[j].1
                    }
                }
            }
        }
        
        return cell
    }
    
    @IBAction func exitGroup(_ sender: Any) {
        
    }
    
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let vw = UIView()
            vw.backgroundColor = .darkGray
            return "                    "
        }
    
    @IBAction func shareGroup(_ sender: Any) {
        let userload = UserLoaded()

        let user = CoreDataRebased.shared.loadUserData()

        let url = URL(string: "login://" + "\(userload.idSala!)")

        let text = "\(user.nome!) would like your participation in the family group. Access key: \(url!)."

        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            let sala = CoreDataRebased.shared.fetchSala()
            let usuarios = (sala.idUsuarios as! NSArray).mutableCopy() as! [String]
            
            Cloud.deleteTable(searchRecord: usuarios[indexPath.row], searchKey: "idUsuario", searchTable: "Usuario")
            
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

