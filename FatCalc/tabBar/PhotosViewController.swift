//
//  photosViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class PhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    let picker = UIImagePickerController()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        print("pressed")
        present(picker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view) //set color
        picker.delegate = self //set delegate
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraFlashMode = .auto
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        let currentControllerName = Funcs.shared.fetchNameFromCurrent(self)
        if Funcs.shared.isLoged == false {
            print("guest!")
        }
        print("current controller is \(currentControllerName)")
    }
    
    func loadPhotos () {
        print("loading photos")
        
        loadPhotos()
        #warning("load from core Data")
    }
    
    func save (_ image:CIImage) {
        print("saving")
        
    }
    // MARK: - Picker Delegate funcs
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[.originalImage] as? UIImage {
            
            if let coreImage = imagePicked as? CIImage {
                save(coreImage)
                #warning("save to core Data")
                
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
