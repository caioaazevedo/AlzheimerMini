//
//  PerfilViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 20/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

struct Tabelas {
    var name : String?
    var imageName: String?
}

class PerfilViewController: UIViewController {
    
    var PerfilTableView : PerfilTableViewController {
        return self.children.first as! PerfilTableViewController
    }
    
    
    var imagePickedBlock: ((UIImage) -> Void)?
    fileprivate var currentVC: UIViewController!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var gestureView: UIView!
    
    
    
    
    static let shared = PerfilViewController()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PerfilTableView.tableView.delegate = self
        setPhoto()
        fixView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(PerfilViewController.moreInfo(_:)))
        gestureView.addGestureRecognizer(tap)
        self.view.addSubview(gestureView)
        
        
        
    }
    
    func fixView(){
        dadosPaciente.frame = self.view.frame
        meuPerfil.frame = self.view.frame
        suporte.frame = self.view.frame
        
    }
    
    func setPhoto(){
        profilePhoto.image = UIImage(named: "sample")
        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
        
    }
    
    func camera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            currentVC.present(picker, animated: true, completion: nil)
        }
    }
    
    func galeria(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            currentVC.present(picker, animated: true, completion: nil)
        }
    }
    
    
    
    
    func presentOption(vc: UIViewController) {
        currentVC = vc
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.galeria()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    @objc func moreInfo(_ sender: UITapGestureRecognizer? = nil){
        
        PerfilViewController.shared.presentOption(vc: self)
        PerfilViewController.shared.imagePickedBlock = { (image) in
            self.profilePhoto.image = image
        }
    }
    
    
    
    
    
}



extension PerfilViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
            
        }else{
            print("Something went wrong")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
}

extension PerfilViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106.75
    }
}
