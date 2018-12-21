//
//  TextAndDrawingViewController.swift
//  ImageFilter
//
//  Created by Jaroslav Stupinskyi on 13.12.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class TextAndDrawingViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: DrawingImageView!
    @IBOutlet weak var scaleSlider: UISlider!
    @IBOutlet weak var scaleImageView: UIImageView!
    @IBOutlet weak var scaleImageHeight: NSLayoutConstraint!
    @IBOutlet weak var scaleImageWidth: NSLayoutConstraint!
    
    var delegate: PaintedImage?
    var mainImage: UIImage?
    var originalImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainImageView.image = mainImage
        originalImage = mainImage
        
        mainImageView.lineColor = UIColor.black
        updateLineWidth()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Save changes", message: "Do you want to save all the changes?", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (actionOk) in
            //Get current graphics context
            UIGraphicsBeginImageContext(self.mainImageView.bounds.size)
            guard let currentContext = UIGraphicsGetCurrentContext() else { return }
            self.mainImageView.layer.render(in: currentContext)
            //Convert current context to UIImage
            guard let paintedImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
            UIGraphicsEndImageContext()
            
            self.delegate?.updateImageWithDrawings(image: paintedImage)
            self.navigationController?.popViewController(animated: true)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in }
        
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func undoButtonPressed(_ sender: Any) {
        mainImageView.image = originalImage
        mainImageView.clearImage()
        scaleSlider.value = 5.0
        updateLineWidth()
    }
    
    func updateLineWidth() {
        mainImageView.lineWidth = CGFloat(scaleSlider.value + 1)
        scaleImageWidth.constant = CGFloat(scaleSlider.value + 10)
        scaleImageHeight.constant = CGFloat(scaleSlider.value + 10)
        
        scaleImageView.layoutIfNeeded()
        scaleImageView.updateConstraints()
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        updateLineWidth()
    }
    
    @IBAction func yellowButtonPressed(_ sender: Any) {
        mainImageView.lineColor = UIColor.yellow
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        mainImageView.lineColor = UIColor.red
    }
    
    @IBAction func greenButtonPressed(_ sender: Any) {
        mainImageView.lineColor = UIColor.green
    }
    
    @IBAction func blueButtonPressed(_ sender: Any) {
        mainImageView.lineColor = UIColor.blue
    }
    
    @IBAction func blackButtonPressed(_ sender: Any) {
        mainImageView.lineColor = UIColor.black
    }
}
