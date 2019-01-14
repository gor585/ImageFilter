//
//  TextAndDrawingViewController.swift
//  ImageFilter
//
//  Created by Jaroslav Stupinskyi on 13.12.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class TextAndDrawingViewController: UIViewController {
    
    @IBOutlet weak var drawingImageView: DrawingImageView!
    @IBOutlet weak var drawingMenuBottomStack: UIStackView!
    @IBOutlet weak var scaleSlider: UISlider!
    @IBOutlet weak var scaleImageView: UIImageView!
    @IBOutlet weak var scaleImageHeight: NSLayoutConstraint!
    @IBOutlet weak var scaleImageWidth: NSLayoutConstraint!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    
    @IBOutlet weak var textImageView: UIImageView!
    @IBOutlet weak var composeTextView: UIView!
    @IBOutlet weak var enterTextView: UITextField!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var delegate: PaintedImage?
    var mainImage: UIImage?
    var originalImage: UIImage?
    
    var selectedMode: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawingImageView.image = mainImage
        textImageView.image = mainImage
        originalImage = mainImage
        
        updateEditingMode()
        
        keyboardStatusListener()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Save changes", message: "Do you want to save all the changes?", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (actionOk) in
            //Get current graphics context
            UIGraphicsBeginImageContext(self.drawingImageView.bounds.size)
            guard let currentContext = UIGraphicsGetCurrentContext() else { return }
            self.drawingImageView.layer.render(in: currentContext)
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
        drawingImageView.image = originalImage
        drawingImageView.clearImage()
        scaleSlider.value = 5.0
        updateLineWidth()
    }
    
    //MARK: - Add drawing
    func updateLineWidth() {
        drawingImageView.lineWidth = CGFloat(scaleSlider.value + 1)
        scaleImageWidth.constant = CGFloat(scaleSlider.value + 10)
        scaleImageHeight.constant = CGFloat(scaleSlider.value + 10)
        
        scaleImageView.layoutIfNeeded()
        scaleImageView.updateConstraints()
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        updateLineWidth()
    }
    
    @IBAction func yellowButtonPressed(_ sender: Any) {
        drawingImageView.lineColor = UIColor.yellow
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        drawingImageView.lineColor = UIColor.red
    }
    
    @IBAction func greenButtonPressed(_ sender: Any) {
        drawingImageView.lineColor = UIColor.green
    }
    
    @IBAction func blueButtonPressed(_ sender: Any) {
        drawingImageView.lineColor = UIColor.blue
    }
    
    @IBAction func blackButtonPressed(_ sender: Any) {
        drawingImageView.lineColor = UIColor.black
    }
    
    //MARK: - Add text
    func keyboardStatusListener() {
        //Keyboard showing listener
        NotificationCenter.default.addObserver(self, selector: #selector(TextAndDrawingViewController.handleKeyBoardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //Keyboard hiding listener
        NotificationCenter.default.addObserver(self, selector: #selector(TextAndDrawingViewController.handleKeyBoardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Hide keyboard on tap
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func addTextButtonPressed(_ sender: Any) {
        
        
        //Dissmiss keyboard
        enterTextView.endEditing(true)
    }
    
    @objc func handleKeyBoardNotification(notification: Notification) {
        //Getting keyboard frame from whatever device it is launched
        if let userInfo = notification.userInfo {
            guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            //Checking if keyboard is showing. If not - bottom constraint of textView will be set to 30
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            textViewBottomConstraint.constant = isKeyboardShowing ? keyboardFrame.height : 30
            
            //Animation
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in })
        }
    }
    
    //MARK: - Modes updating
    func updateEditingMode() {
        if selectedMode == 4 {
            drawingMode()
        } else if selectedMode == 5 {
            textMode()
        }
    }
    
    func drawingMode() {
        drawingImageView.isHidden = false
        drawingImageView.lineColor = UIColor.black
        updateLineWidth()
        
        drawingMenuBottomStack.isHidden = false
        scaleSlider.isHidden = false
        scaleSlider.isEnabled = true
        scaleImageView.isHidden = false
        scaleLabel.isHidden = false
        yellowButton.isHidden = false
        yellowButton.isEnabled = true
        redButton.isHidden = false
        redButton.isEnabled = true
        greenButton.isHidden = false
        greenButton.isEnabled = true
        blueButton.isHidden = false
        blueButton.isEnabled = true
        blackButton.isHidden = false
        blackButton.isEnabled = true
        
        textImageView.isHidden = true
        composeTextView.isHidden = true
        enterTextView.isHidden = true
        enterTextView.isEnabled = false
        addTextButton.isHidden = true
        addTextButton.isEnabled = false
    }
    
    func textMode() {
        textImageView.isHidden = false
        composeTextView.isHidden = false
        enterTextView.isHidden = false
        enterTextView.isEnabled = true
        addTextButton.isHidden = false
        addTextButton.isEnabled = true
        
        drawingImageView.isHidden = true
        drawingMenuBottomStack.isHidden = true
        scaleSlider.isHidden = true
        scaleSlider.isEnabled = false
        scaleImageView.isHidden = true
        scaleLabel.isHidden = true
        yellowButton.isHidden = true
        yellowButton.isEnabled = false
        redButton.isHidden = true
        redButton.isEnabled = false
        greenButton.isHidden = true
        greenButton.isEnabled = false
        blueButton.isHidden = true
        blueButton.isEnabled = false
        blackButton.isHidden = true
        blackButton.isEnabled = false
    }
}
