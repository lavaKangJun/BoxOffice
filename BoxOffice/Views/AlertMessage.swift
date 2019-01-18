//
//  AlertMessage.swift
//  BoxOffice
//
//  Created by 강준영 on 12/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import Foundation
import UIKit

func showAlert(viewcontroller: UIViewController, title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ok", style: .default)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    
    viewcontroller.present(alertController, animated: true, completion: nil)
}

func showErrorAlert(viewcontroller: UIViewController) {
    let alertController = UIAlertController(title: "문제발생", message: "데이터를 가져올 수 없습니다.", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) in
        viewcontroller.navigationController?.popViewController(animated: true)
    }
    
    alertController.addAction(okAction)
    
    viewcontroller.present(alertController, animated: true, completion: nil)
}
