//
//  HideKeyboardOnTap.swift
//  ImageFilter
//
//  Created by Jaroslav Stupinskyi on 14.01.19.
//  Copyright © 2019 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
