//
//  ViewController.swift
//  CollectionViewNisWs
//
//  Created by Никита Казанцев on 30.10.2020.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    let cellId = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SetupCollectionView()
    }
    
    func SetupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height / 5)
        
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .magenta
        view.addSubview(collectionView)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyCollectionViewCell
        
        
        
        
        return cell
    }


}

