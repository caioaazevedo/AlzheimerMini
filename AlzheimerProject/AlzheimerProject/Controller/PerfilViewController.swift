//
//  PerfilViewController.swift
//  AlzheimerProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 20/08/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {
    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var collectionScreens: UICollectionView!
    
    
    var tarefas = [String]()
    
    @IBOutlet weak var gestureView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhoto()
        setScrollView()
        setLayout()

        let tap = UITapGestureRecognizer(target: self, action: #selector(PerfilViewController.moreInfo(_:)))
        gestureView.addGestureRecognizer(tap)
        self.view.addSubview(gestureView)
        
        tarefas.append("Sangue")
        tarefas.append("Remedio")
        
        UserLoaded()
       

    }
    
    func setLayout(){
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height/2)
        layout.scrollDirection = .horizontal
        
        
        
        collectionScreens.collectionViewLayout = layout
    }
    
    func setScrollView(){
        var invisibleScrolLView = UIScrollView(frame: self.view.bounds)
        invisibleScrolLView.translatesAutoresizingMaskIntoConstraints = false
        invisibleScrolLView.isPagingEnabled = true
        invisibleScrolLView.showsVerticalScrollIndicator = false
    }
    
    
    
    func setPhoto(){
        profilePhoto.image = UIImage(named: "sample")
        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
        
    }
    
    @objc func moreInfo(_ sender: UITapGestureRecognizer? = nil){
        print("clicou")
        performSegue(withIdentifier: "moreInfoSegue", sender: self)
        
    }
}

extension PerfilViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tarefas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let tarefa = tarefas[indexPath.row]
        cell.textLabel?.text = tarefa
        return cell
    }
    
    
}

extension PerfilViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        return cell
    }
    
    
    
    
    
    
    
    
}

class CollectionViewCell: UICollectionViewCell{
    
    
    
    
}
