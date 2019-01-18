//
//  BigPosterViewController.swift
//  BoxOffice
//
//  Created by 강준영 on 14/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import UIKit

class BigPosterViewController: UIViewController {
    
    var imageView =  UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapGesture)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        setupImageView()
       
    }
    
    //MARK:- Setup Function
    func setupImageView() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
    }
    
    @objc func dismissModal(gestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
