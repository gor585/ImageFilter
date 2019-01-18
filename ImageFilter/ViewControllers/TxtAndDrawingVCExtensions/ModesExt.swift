//
//  ModesExt.swift
//  ImageFilter
//
//  Created by Jaroslav Stupinskyi on 17.01.19.
//  Copyright © 2019 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension TextAndDrawingViewController {
    
    //MARK: - Drawing mode
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
    
    //MARK: - Text mode
    func textEditingBegin() {
        textEditingMenu.isHidden = false
        whiteTextButton.isEnabled = true
        yellowTextButton.isEnabled = true
        redTextButton.isEnabled = true
        blueTextButton.isEnabled = true
        blackTextButton.isEnabled = true
        clearFillButton.isEnabled = true
        yellowFillButton.isEnabled = true
        redFillButton.isEnabled = true
        blueFillButton.isEnabled = true
        blackFillButton.isEnabled = true
        okButton.isEnabled = true
        okButton.layer.cornerRadius = 10
    }
    
    func textEditingEnded() {
        textEditingMenu.isHidden = true
        whiteTextButton.isEnabled = false
        yellowTextButton.isEnabled = false
        redTextButton.isEnabled = false
        blueTextButton.isEnabled = false
        blackTextButton.isEnabled = false
        clearFillButton.isEnabled = false
        yellowFillButton.isEnabled = false
        redFillButton.isEnabled = false
        blueFillButton.isEnabled = false
        blackFillButton.isEnabled = false
        okButton.isEnabled = false
    }
}
