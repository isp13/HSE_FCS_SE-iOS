//
//  MyCollectionViewCell.swift
//  CollectionViewNisWs
//
//  Created by Никита Казанцев on 30.10.2020.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    let profileImageButton: UIButton = {
        let control = UIButton()
        control.backgroundColor = .red
        control.layer.cornerRadius = 5
        control.clipsToBounds = true
        control.setImage(UIImage(systemName: "macmini"), for: .normal)
        
        
        /*
         If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to false, and then provide a non ambiguous, nonconflicting set of constraints for the view.
         */
        control.translatesAutoresizingMaskIntoConstraints = false // required
        
        
        return control
    }()
    
    let dateLabel: UILabel = {
        let control = UILabel()
        control.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        control.textAlignment = .center
        control.textColor = .systemPink
        
        control.text = "13"

        
        
        /*
         If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to false, and then provide a non ambiguous, nonconflicting set of constraints for the view.
         */
        control.translatesAutoresizingMaskIntoConstraints = false // required
        
        
        return control
    }()
    
    let dayLabel: UILabel = {
        let control = UILabel()
        control.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        control.textAlignment = .left
        control.textColor = .systemPink
        
        control.text = "Friday"

        
        
        /*
         If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to false, and then provide a non ambiguous, nonconflicting set of constraints for the view.
         */
        control.translatesAutoresizingMaskIntoConstraints = false // required
        
        
        return control
    }()
    
    let distanceLabel: UILabel = {
        let control = UILabel()
        control.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        control.textAlignment = .left
        control.textColor = .systemPink
        
        control.text = "212 miles"

        
        /*
         If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to false, and then provide a non ambiguous, nonconflicting set of constraints for the view.
         */
        control.translatesAutoresizingMaskIntoConstraints = false // required
        
        
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        backgroundColor = .systemIndigo
        
        addSubview(profileImageButton)
        addSubview(dateLabel)
        addSubview(dayLabel)
        addSubview(distanceLabel)
        
        profileImageButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        profileImageButton.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        dateLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor, constant: 0).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: profileImageButton.rightAnchor, constant: 20).isActive = true
        
        dayLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor, constant: 5).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 10).isActive = true
        
        distanceLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor, constant: 5).isActive = true
        distanceLabel.centerXAnchor.constraint(equalTo: dayLabel.rightAnchor, constant: 10).isActive = true
        
        
    }
}
