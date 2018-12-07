//
//  ViewController.swift
//  ImageFilter
//
//  Created by Jaroslav Stupinskyi on 04.12.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    private var originalImage: UIImage?
    
    var selectedMode: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainImageView.image = UIImage(named: "Giza")
        originalImage = mainImageView.image
    }
    
    @IBAction func loadPhotoButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func addTextButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func addDrawingButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func savePhotoButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func filtersButtonPressed(_ sender: Any) {
        selectedMode = 1
        performSegue(withIdentifier: "toFilters", sender: self)
    }
    
    @IBAction func brightnessButtonPressed(_ sender: Any) {
        selectedMode = 2
        performSegue(withIdentifier: "toFilters", sender: self)
    }
    
    @IBAction func exposureButtonPressed(_ sender: Any) {
        selectedMode = 3
        performSegue(withIdentifier: "toFilters", sender: self)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Undo changes", message: "Do you want to undo all changes?", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (actionOk) in
            self.mainImageView.image = self.originalImage
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (actionCancel) in }
        
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilters" {
            guard let filterVC = segue.destination as? FiltersViewController else { return }
            filterVC.selectedMode = selectedMode
            filterVC.mainImage = mainImageView.image
            filterVC.delegate = self
        }
    }
}

extension ViewController: FilterImage {
    func updateImage(image: UIImage) {
        mainImageView.image = image
    }
}
