//
//  ProfileViewController.swift
//  core
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 09/09/19.
//  Copyright © 2019 Pedro Paulo Feitosa Rodrigues Carneiro. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageProfileBck: UIView!
    
    

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
        
        

        // Do any additional setup after loading the view.
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

