//
//  ProfileViewController.swift
//  core
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 09/09/19.
//  Copyright © 2019 Pedro Paulo Feitosa Rodrigues Carneiro. All rights reserved.
//

import UIKit
import CircleBar

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageProfileBck: UIView!
    
    @IBOutlet weak var container: UIView!
    

    @IBOutlet weak var img1: UIView!
    @IBOutlet weak var img2: UIView!
    @IBOutlet weak var img3: UIView!
    @IBOutlet weak var imf4: UIView!
    @IBOutlet weak var img5: UIView!
    
    @IBOutlet weak var pic1: UIImageView!
    @IBOutlet weak var pic2: UIImageView!
    @IBOutlet weak var pic3: UIImageView!
    @IBOutlet weak var pic4: UIImageView!
    @IBOutlet weak var pic5: UIImageView!
    
    
    //37x37
    //133 - 151
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfile.layer.cornerRadius = 80
        imageProfile.clipsToBounds = true
        
        imageProfileBck.layer.cornerRadius = 80
        imageProfileBck.clipsToBounds = true
        
        imageProfileBck.layer.shadowColor = UIColor.red.cgColor
        imageProfileBck.layer.shadowOpacity = 1
        imageProfileBck.layer.shadowOffset = .zero
        imageProfileBck.layer.shadowRadius = 5
        
        shadowView()
        arredondaPessoas()
        arredondaImagemPerfis()
        
        var tableController : profileTableViewController {
            return self.children.first as! profileTableViewController
        }
        
       
        
        tableController.tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let vc = self.tabBarController as! SHCircleBarController?{
            vc.circleView.isHidden = false
            vc.circleImageView.isHidden = false
               vc.tabBarController?.tabBar.isHidden = false
        }
        
    }
    
    
    func arredondaPessoas(){
        
        img1.clipsToBounds = true
        img1.layer.cornerRadius = 20
        
        img2.clipsToBounds = true
        img2.layer.cornerRadius = 20
        
        img3.clipsToBounds = true
        img3.layer.cornerRadius = 20
        
        imf4.clipsToBounds = true
        imf4.layer.cornerRadius = 20
        
        img5.clipsToBounds = true
        img5.layer.cornerRadius = 20
        
        
        
    }
    
    func arredondaImagemPerfis(){
        
        pic1.clipsToBounds = true
        pic1.layer.cornerRadius = 18
        
        pic2.clipsToBounds = true
        pic2.layer.cornerRadius = 18
        
        pic3.clipsToBounds = true
        pic3.layer.cornerRadius = 18
        
        pic4.clipsToBounds = true
        pic4.layer.cornerRadius = 18
        
        pic5.clipsToBounds = true
        pic5.layer.cornerRadius = 18
        
    }
    
    
    func shadowView(){
        let viewShadow = UIView(frame: CGRect(x: 126, y: 126, width: 170, height: 170))
        viewShadow.backgroundColor = UIColor.white
        viewShadow.layer.shadowColor = UIColor.black.cgColor
        viewShadow.layer.shadowOpacity = 0.3
        viewShadow.layer.shadowOffset = CGSize.zero
        viewShadow.layer.shadowRadius = 2
        self.view.addSubview(viewShadow)
        viewShadow.addSubview(imageProfile)
        viewShadow.layer.cornerRadius = 85
    }


}


extension ProfileViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            
            performSegue(withIdentifier: "seguePerfil", sender: self)
        case 1:
            
            performSegue(withIdentifier: "segueMeuPerfil", sender: self)
            
        case 2:
            performSegue(withIdentifier: "segueShow", sender: self)
        default:
            print()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupTableViewCell
        
        cell.imgGroup.image = UIImage(named: "hamster 2")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let vw = UIView()
        vw.backgroundColor = .darkGray
        return "                    "
    }
    
    
    
    
}

