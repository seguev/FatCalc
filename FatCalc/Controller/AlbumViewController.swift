//
//  weightViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class AlbumViewController: UIViewController, UIScrollViewDelegate {
    
    let model = ImageViewModel()
    var currentIndex = 0
    var currentPicture : UIImageView?
    var isActive = false
    let picker = UIImagePickerController()
    
    func pickerSetup () {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.controller = self
        
        Funcs.shared.addGradient(view: self.view)
        pickerSetup()
        
        model.addDogImages()
        model.setImage()
    }
    
    @IBAction func addNewImage(_ sender: UIButton) {
        present(picker, animated: true)
    }
    
    //1. once image has been added, setImage()
    var imageArray = [UIImage]()
//    = [] {
//        didSet {
//            model.setImage()
//            guard currentPicture != nil else {fatalError("setImage failed to set currentPicture object")}
//            model.showPicture(currentPicture!)
//        }
//    }
//
    
    
    deinit {
        print("albumController has been dealocated from memory! ho nooooo")
    }
    
}


// MARK: - ImagePicker funcs
extension AlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[.originalImage] as? UIImage {
            
            imageArray.append(imagePicked)
            
            if imageArray.count == 1 {
                model.setImage()
            }
            
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true)
        return
    }
    
}
