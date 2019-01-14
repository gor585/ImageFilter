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
        chooseImage()
    }
    
    @IBAction func savePhotoButtonPressed(_ sender: Any) {
        guard let imageData = UIImagePNGRepresentation(mainImageView.image!) else { return }
        guard let compressedImage = UIImage(data: imageData) else { return }
        UIImageWriteToSavedPhotosAlbum(compressedImage, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
    
    @IBAction func addTextButtonPressed(_ sender: Any) {
        selectedMode = 5
        performSegue(withIdentifier: "toTextAndDrawing", sender: self)
    }
    
    @IBAction func addDrawingButtonPressed(_ sender: Any) {
        selectedMode = 4
        performSegue(withIdentifier: "toTextAndDrawing", sender: self)
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
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilters" {
            guard let filterVC = segue.destination as? FiltersViewController else { return }
            filterVC.selectedMode = selectedMode
            filterVC.mainImage = mainImageView.image
            filterVC.delegate = self
        }
        if segue.identifier == "toTextAndDrawing" {
            guard let txtAnddrawVC = segue.destination as? TextAndDrawingViewController else { return }
            txtAnddrawVC.selectedMode = selectedMode
            txtAnddrawVC.mainImage = mainImageView.image
            txtAnddrawVC.delegate = self
        }
     }
}

//MARK: - Filter Image delegate method
extension ViewController: FilterImage {
    func updateImage(image: UIImage) {
        mainImageView.image = image
    }
}

//MARK: - Drawing on image delegate image
extension ViewController: PaintedImage {
    func updateImageWithDrawings(image: UIImage) {
        mainImageView.image = image
    }
}

//MARK: - Image picker delegate methods
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Image source", message: "Choose your image source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (cameraAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (photoLibraryAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        mainImageView.image = pickedImage.updateImageOrientionUpSide()
        originalImage = pickedImage.updateImageOrientionUpSide()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

