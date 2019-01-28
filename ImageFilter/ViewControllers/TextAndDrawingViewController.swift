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
    
    @IBOutlet weak var textEditingMenu: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var whiteTextButton: UIButton!
    @IBOutlet weak var yellowTextButton: UIButton!
    @IBOutlet weak var redTextButton: UIButton!
    @IBOutlet weak var blueTextButton: UIButton!
    @IBOutlet weak var blackTextButton: UIButton!
    @IBOutlet weak var clearFillButton: UIButton!
    @IBOutlet weak var yellowFillButton: UIButton!
    @IBOutlet weak var redFillButton: UIButton!
    @IBOutlet weak var blueFillButton: UIButton!
    @IBOutlet weak var blackFillButton: UIButton!
    
    var delegate: PaintedImage?
    var mainImage: UIImage?
    var originalImage: UIImage?
    
    var selectedMode: Int?
    
    var isTextLabelSelected: Bool?
    var isResizable: Bool?
    var originalTextLabel: UILabel?
    var editedTextLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawingImageView.image = mainImage
        textImageView.image = mainImage
        originalImage = mainImage
        
        updateEditingMode()
        
        keyboardStatusListener()
        
        enterTextView.delegate = self
        
        isTextLabelSelected = false
        isResizable = false
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Save changes", message: "Do you want to save all the changes?", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (actionOk) in
            if self.selectedMode == 4 {
                //Get current graphics context
                UIGraphicsBeginImageContext(self.drawingImageView.bounds.size)
                guard let currentDrawingContext = UIGraphicsGetCurrentContext() else { return }
                self.drawingImageView.layer.render(in: currentDrawingContext)
                //Convert current context to UIImage
                guard let paintedImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
                UIGraphicsEndImageContext()
                self.delegate?.updateImageWithDrawings(image: paintedImage)
            }
            if self.selectedMode == 5 {
                UIGraphicsBeginImageContext(self.textImageView.bounds.size)
                guard let currentTextContext = UIGraphicsGetCurrentContext() else { return }
                self.textImageView.layer.render(in: currentTextContext)
                guard let imageWithText = UIGraphicsGetImageFromCurrentImageContext() else { return }
                UIGraphicsEndImageContext()
                self.delegate?.updateImageWithDrawings(image: imageWithText)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in }
        
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func undoButtonPressed(_ sender: Any) {
        if selectedMode == 4 {
            drawingImageView.image = originalImage
            drawingImageView.clearImage()
            scaleSlider.value = 5.0
            updateLineWidth()
        }
        if selectedMode == 5 {
            textImageView.image = originalImage
            //Removing text labels
            textImageView.subviews.forEach { $0.removeFromSuperview() }
        }
    }
    
    //MARK: - Add drawing
    func updateLineWidth() {
        drawingImageView.lineWidth = CGFloat(scaleSlider.value + 1)
        scaleImageWidth.constant = CGFloat(scaleSlider.value + 10)
        scaleImageHeight.constant = CGFloat(scaleSlider.value + 10)
        
        scaleImageView.layoutIfNeeded()
        scaleImageView.updateConstraints()
    }
    
    //MARK: - Line color buttons
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
    
    //MARK: - Text color buttons
    @IBAction func whiteTextButtonPressed(_ sender: Any) {
        editedTextLabel?.textColor = UIColor.white
    }
    
    @IBAction func yellowTextButtonPressed(_ sender: Any) {
        editedTextLabel?.textColor = UIColor.yellow
    }
    
    @IBAction func redTextButtonPressed(_ sender: Any) {
        editedTextLabel?.textColor = UIColor.red
    }
    
    @IBAction func blueTextButtonPressed(_ sender: Any) {
        editedTextLabel?.textColor = UIColor.blue
    }
    
    @IBAction func blackTextButtonPressed(_ sender: Any) {
        editedTextLabel?.textColor = UIColor.black
    }
    
    //MARK: - Fill color buttons
    
    @IBAction func clearFillButtonPressed(_ sender: Any) {
        editedTextLabel?.backgroundColor = UIColor.clear
    }
    
    @IBAction func yellowFillButtonPressed(_ sender: Any) {
        editedTextLabel?.backgroundColor = UIColor.yellow
    }
    
    @IBAction func redFillButtonPressed(_ sender: Any) {
        editedTextLabel?.backgroundColor = UIColor.red
    }
    
    @IBAction func blueFillButtonPressed(_ sender: Any) {
        editedTextLabel?.backgroundColor = UIColor.blue
    }
    
    @IBAction func blackFillButtonPressed(_ sender: Any) {
        editedTextLabel?.backgroundColor = UIColor.black
    }
    
    //MARK: - Rotate text label
    @IBAction func rotateButtonPressed(_ sender: UIButton) {
        sender.backgroundColor = UIColor.yellow
        isResizable = false
    }
    
    //MARK: - End text editing buttons
    @IBAction func okButtonPressed(_ sender: Any) {
        textEditingEnded()
        rotateButton.backgroundColor = UIColor.lightGray
        isTextLabelSelected = false
        setSelected(label: originalTextLabel!)
    }
    
    //MARK: - Modes updating
    func updateEditingMode() {
        if selectedMode == 4 {
            drawingMode()
        } else if selectedMode == 5 {
            textMode()
        }
    }
}

extension TextAndDrawingViewController: UITextFieldDelegate {
    
    //Dissmiss keyboard and clear textField on return pressing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if enterTextView.text != "" {
            addTextLabel(withText: enterTextView.text ?? "")
            enterTextView.text = ""
        }
        return false
    }
    
    //MARK: - Add text
    func keyboardStatusListener() {
        //Keyboard showing listener
        NotificationCenter.default.addObserver(self, selector: #selector(TextAndDrawingViewController.handleKeyBoardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //Keyboard hiding listener
        NotificationCenter.default.addObserver(self, selector: #selector(TextAndDrawingViewController.handleKeyBoardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //OPTIONAL: Hide keyboard on tap
        //self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func addTextButtonPressed(_ sender: Any) {
        if enterTextView.text != "" {
            guard let text = enterTextView.text else { return }
            addTextLabel(withText: text)
            enterTextView.text = ""
        }
        //Dissmiss keyboard
        view.endEditing(true)
    }
    
    func addTextLabel(withText: String) {
        let label = UILabel(frame: CGRect(x: textImageView.frame.width / 2, y: textImageView.frame.height / 2, width: 0, height: 0))
        label.text = withText
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.sizeToFit()
        label.backgroundColor = UIColor.red
        textImageView.addSubview(label)
        label.isUserInteractionEnabled = true
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(TextAndDrawingViewController.wasDragged(_:)))
        label.addGestureRecognizer(dragGesture)
        
        let selectGesture = UITapGestureRecognizer(target: self, action: #selector(TextAndDrawingViewController.wasSelected(_:)))
        label.addGestureRecognizer(selectGesture)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(TextAndDrawingViewController.wasRotated(_:)))
        label.addGestureRecognizer(rotateGesture)
    }
    
    @objc func wasDragged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: textImageView)
        guard let draggableLabel = gesture.view as? UILabel else { return }
        //If label is in deselected mode - user cam change it's position on drag gesture
        if isTextLabelSelected == false {
            draggableLabel.center = CGPoint(x: draggableLabel.center.x + translation.x, y: draggableLabel.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: textImageView)
        //Else user can change the size of it's frame
        } else {
            if gesture.state == .ended {
                if isTextLabelSelected == true && isResizable == true {
                    let translation = gesture.translation(in: textImageView)
                    draggableLabel.transform = .identity
                    var newFrame = draggableLabel.frame
                    newFrame.size.width = newFrame.size.width + translation.x
                    newFrame.size.height = newFrame.size.height + translation.y
                    draggableLabel.frame = newFrame
                    draggableLabel.font = UIFont(name: "Avenir Next", size: draggableLabel.frame.size.height)
                }
            }
        }
    }
    
    @objc func wasSelected(_ gesture: UITapGestureRecognizer) {
        guard let selectedLabel = gesture.view as? UILabel else { return }
        isTextLabelSelected = true
        isResizable = true
        rotateButton.backgroundColor = UIColor.lightGray
        setSelected(label: selectedLabel)
        originalTextLabel = selectedLabel
        editedTextLabel = selectedLabel
        textEditingBegin()
    }
    
    @objc func wasRotated(_ gesture: UIRotationGestureRecognizer) {
        guard let rotatedLabel = gesture.view as? UILabel else { return }
        if isTextLabelSelected == true && isResizable == false {
            if gesture.state == .began || gesture.state == .changed {
                rotatedLabel.transform = rotatedLabel.transform.rotated(by: gesture.rotation)
                gesture.rotation = 0
            }
        }
    }
    
    func setSelected(label: UILabel) {
        if isTextLabelSelected == true {
            label.layer.borderColor = UIColor.blue.cgColor
            label.layer.borderWidth = 1
        } else {
            label.layer.borderColor = UIColor.clear.cgColor
            label.layer.borderWidth = 0
        }
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
}
