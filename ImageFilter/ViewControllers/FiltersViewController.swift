//
//  FiltersViewController.swift
//  ImageFilter
//
//  Created by Jaroslav Stupinskyi on 05.12.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import CoreImage

class FiltersViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    private var originalImage: UIImage?
    
    @IBOutlet weak var filtersStackView: UIStackView!
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var brightnessStackView: UIStackView!
    @IBOutlet weak var brigtnessSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var exposureStackView: UIStackView!
    @IBOutlet weak var exposureSlider: UISlider!
    @IBOutlet weak var gammaSlider: UISlider!
    
    var mainImage: UIImage?
    var ciImage: CIImage?
    var delegate: FilterImage?
    var selectedMode: Int?
    
    var brightnessFilter: CIFilter?
    var contrastFilter: CIFilter?
    var exposureFilter: CIFilter?
    var gammaFilter: CIFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImageView.image = mainImage
        originalImage = mainImageView.image
        
        guard let image = mainImageView.image else { return }
        guard let cgImage = image.cgImage else { return }
        ciImage = CIImage(cgImage: cgImage)
        
        updateEditingMode()
    }
    
    @IBAction func undoButtonPressed(_ sender: Any) {
        mainImageView.image = originalImage
        guard let originalCG = originalImage?.cgImage else { return }
        ciImage = CIImage(cgImage: originalCG)
        brigtnessSlider.value = 0.5
        contrastSlider.value = 0.5
        exposureSlider.value = 0.5
        gammaSlider.value = 0.5
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Save changes", message: "Do you want to save all the changes?", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (actionOk) in
            guard let image = self.mainImageView.image else { return }
            self.delegate?.updateImage(image: image)
            self.navigationController?.popViewController(animated: true)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (actionCancel) in }
        
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Filter applying
    func applyFilterTo(image: UIImage, filterEffect: Filter) -> UIImage? {
        guard let openGLContext = EAGLContext(api: .openGLES3) else { return nil }
        let context = CIContext(eaglContext: openGLContext)
        
        var filteredImage: UIImage?
        
        let filter = CIFilter(name: filterEffect.filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        //Checking if selected filter has any effect value properties
        if let filterEffectValue = filterEffect.filterEffectValue,
            let filterEffectValueName = filterEffect.filterEffectValueName {
            filter?.setValue(filterEffectValue, forKey: filterEffectValueName)
        }
        
        //Getting filter output
        if let filterOutput = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
            let cgImageResult = context.createCGImage(filterOutput, from: filterOutput.extent) {
            filteredImage = UIImage(cgImage: cgImageResult)
        }
        
        return filteredImage
    }
    
    //MARK: - Filters
    @IBAction func sepiaFilter(_ sender: Any) {
        //Allowing to use only one filter at a time
        mainImageView.image = originalImage
        guard let image = mainImageView.image else { return }
        let sepiaFilter = Filter(filterName: "CISepiaTone", filterEffectValue: 0.80, filterEffectValueName: kCIInputIntensityKey)
        mainImageView.image = applyFilterTo(image: image, filterEffect: sepiaFilter)
    }
    
    @IBAction func invertFilter(_ sender: Any) {
        mainImageView.image = originalImage
        guard let image = mainImageView.image else { return }
        let invertFilter = Filter(filterName: "CIColorInvert", filterEffectValue: nil, filterEffectValueName: nil)
        mainImageView.image = applyFilterTo(image: image, filterEffect: invertFilter)
    }
    
    @IBAction func fadeFilter(_ sender: Any) {
        mainImageView.image = originalImage
        guard let image = mainImageView.image else { return }
        let fadeFilter = Filter(filterName: "CIPhotoEffectFade", filterEffectValue: nil, filterEffectValueName: nil)
        mainImageView.image = applyFilterTo(image: image, filterEffect: fadeFilter)
    }
    
    @IBAction func processFilter(_ sender: Any) {
        mainImageView.image = originalImage
        guard let image = mainImageView.image else { return }
        let processFilter = Filter(filterName: "CIPhotoEffectProcess", filterEffectValue: nil, filterEffectValueName: nil)
        mainImageView.image = applyFilterTo(image: image, filterEffect: processFilter)
    }
    
    @IBAction func transferFilter(_ sender: Any) {
        mainImageView.image = originalImage
        guard let image = mainImageView.image else { return }
        let transferFilter = Filter(filterName: "CIPhotoEffectTransfer", filterEffectValue: nil, filterEffectValueName: nil)
        mainImageView.image = applyFilterTo(image: image, filterEffect: transferFilter)
    }
    
    @IBAction func noirFilter(_ sender: Any) {
        mainImageView.image = originalImage
        guard let image = mainImageView.image else { return }
        let noirFilter = Filter(filterName: "CIPhotoEffectNoir", filterEffectValue: nil, filterEffectValueName: nil)
        mainImageView.image = applyFilterTo(image: image, filterEffect: noirFilter)
    }
    
    //MARK: - Brightness & Contrast
    func brightnessAndContrastSlidersChanged() {
        var inputImage = ciImage
        if brigtnessSlider.isContinuous == true {
            brightnessFilter = CIFilter(name: "CIColorControls")
            brightnessFilter?.setValue(inputImage, forKey: "inputImage")
            //Setting filter intencity to slider value - 0.5 (to 0.0)
            brightnessFilter?.setValue(brigtnessSlider.value - 0.5, forKey: "inputBrightness")
            guard let outputImage = brightnessFilter?.outputImage else { return }
            guard let imageContext = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return }
            mainImageView.image = UIImage(cgImage: imageContext)
            inputImage = CIImage(cgImage: imageContext)
        }
        if contrastSlider.isContinuous == true {
            contrastFilter = CIFilter(name: "CIColorControls")
            contrastFilter?.setValue(inputImage, forKey: "inputImage")
            //Setting filter intencity to slider value + 0.5 (to 0.0)
            contrastFilter?.setValue(contrastSlider.value + 0.5, forKey: "inputContrast")
            guard let outputImage = contrastFilter?.outputImage else { return }
            guard let imageContext = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return }
            mainImageView.image = UIImage(cgImage: imageContext)
            inputImage = CIImage(cgImage: imageContext)
        }
    }
    
    @IBAction func brightnessSliderValueChanged(_ sender: UISlider) {
        brightnessAndContrastSlidersChanged()
    }
    
    @IBAction func contrastSliderValueChanged(_ sender: UISlider) {
        brightnessAndContrastSlidersChanged()
    }
    
    //MARK: - Exposure & Gamma
    func exposureAndGammaSlidersChanged() {
        var inputImage = ciImage
        if exposureSlider.isContinuous == true {
            exposureFilter = CIFilter(name: "CIExposureAdjust")
            exposureFilter?.setValue(inputImage, forKey: "inputImage")
            //Setting filter intencity to slider value - 0.48 (to 0.0)
            exposureFilter?.setValue(exposureSlider.value - 0.48, forKey: "inputEV")
            guard let outputImage = exposureFilter?.outputImage else { return }
            guard let imageContext = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return }
            mainImageView.image = UIImage(cgImage: imageContext)
            inputImage = CIImage(cgImage: imageContext)
        }
        if gammaSlider.isContinuous == true {
            gammaFilter = CIFilter(name: "CIGammaAdjust")
            gammaFilter?.setValue(inputImage, forKey: "inputImage")
            //Setting filter intencity to slider value + 0.52 (to 0.0)
            gammaFilter?.setValue(gammaSlider.value + 0.52, forKey: "inputPower")
            guard let outputImage = gammaFilter?.outputImage else { return }
            guard let imageContext = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return }
            mainImageView.image = UIImage(cgImage: imageContext)
            inputImage = CIImage(cgImage: imageContext)
        }
    }
    
    @IBAction func exposureSliderValueChanged(_ sender: UISlider) {
        exposureAndGammaSlidersChanged()
    }
    
    @IBAction func gammaSliderValueChanged(_ sender: UISlider) {
        exposureAndGammaSlidersChanged()
    }
    
    
    
    //MARK: - Modes updating
    func updateEditingMode() {
        if selectedMode == 1 {
            filterMode()
        } else if selectedMode == 2 {
            brightnessMode()
        } else if selectedMode == 3 {
            exposureMode()
        }
    }
    
    func filterMode() {
        filtersStackView.isHidden = false
        labelsStackView.isHidden = false
        
        brightnessStackView.isHidden = true
        brigtnessSlider.isEnabled = false
        
        exposureStackView.isHidden = true
        exposureSlider.isEnabled = false
    }
    
    func brightnessMode() {
        filtersStackView.isHidden = true
        labelsStackView.isHidden = true
        
        brightnessStackView.isHidden = false
        brigtnessSlider.isEnabled = true
        
        exposureStackView.isHidden = true
        exposureSlider.isEnabled = false
    }
    
    func exposureMode() {
        filtersStackView.isHidden = true
        labelsStackView.isHidden = true
        
        brightnessStackView.isHidden = true
        brigtnessSlider.isEnabled = false
        
        exposureStackView.isHidden = false
        exposureSlider.isEnabled = true
    }
}
