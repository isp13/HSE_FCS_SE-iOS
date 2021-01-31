//
//  ViewController.swift
//  TripCard
//
//  Created by Никита Казанцев on 25.01.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,
                      UICollectionViewDataSource, TripCollectionCellDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    
    private var trips = [Trip(tripId: "Paris001", city: "Paris", country: "France",
                              featuredImage: UIImage(named: "paris"), price: 2000, totalDays: 5, isLiked:
                                false),
                         Trip(tripId: "Rome001", city: "Rome", country: "Italy", featuredImage:
                                UIImage(named: "rome"), price: 800, totalDays: 3, isLiked: false),
                         Trip(tripId: "Istanbul001", city: "Istanbul", country: "Turkey",
                              featuredImage: UIImage(named: "istanbul"), price: 2200, totalDays: 10, isLiked:
                                false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.backgroundColor = UIColor.clear
        
        if UIScreen.main.bounds.size.height == 568.0 {
            let flowLayout = self.collectionView.collectionViewLayout as!
                UICollectionViewFlowLayout
            flowLayout.itemSize = CGSize(width: 250.0, height: 330.0)}
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
                            section: Int) -> Int {
        return trips.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
                            indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as! TripCollectionViewCell
        // Configure the cell
        cell.delegate = self
        cell.cityLabel.text = trips[indexPath.row].city
        cell.countryLabel.text = trips[indexPath.row].country
        cell.imageView.image = trips[indexPath.row].featuredImage
        cell.priceLabel.text = "$\(String(trips[indexPath.row].price))"
        cell.totalDaysLabel.text = "\(trips[indexPath.row].totalDays) days"
        cell.isLiked = trips[indexPath.row].isLiked
        // Apply round corner
        cell.layer.cornerRadius = 4.0
        return cell
    }
    
    func didLikeButtonPressed(cell: TripCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            trips[indexPath.row].isLiked.toggle()
            cell.isLiked = trips[indexPath.row].isLiked
        }
    }
}

