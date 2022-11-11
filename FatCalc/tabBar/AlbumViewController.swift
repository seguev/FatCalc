//
//  weightViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class AlbumViewController: UIViewController {
    #warning("save it to coreData")
    
    var weightArray = [Float]()
    
    let picker = UIImagePickerController()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view) //set color
        picker.delegate = self 
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraFlashMode = .auto
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //get current name from shared func
        let currentControllerName = Funcs.shared.fetchNameFromCurrent(self)
        
        if Funcs.shared.isLoged == false {
            print("guest!")
        }
        
        print("current controller is \(currentControllerName)")

    }
    
    func setWeight () { //present alert with textField and convert to Float
        var textField = UITextField()
        let alert = UIAlertController(title: "Add your weight", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD", style: .default) { action in
            //save text to array
            if let newWeight = textField.text { //if textfield text isnt nil
                print(newWeight)
                if let floatWeight = Float(newWeight) {
                    print(floatWeight)
                    self.weightArray.append(floatWeight)
                    print(self.weightArray)
                } else {print("could not convert into float")}
            } else {print("textField.text is nil!")}
        }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            textField = alertTextField
        }
        present(alert, animated: true)
    }
    
    
    
    
}

extension AlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[.originalImage] as? UIImage {
            
           
                
            //save photo
        }
        
        picker.dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true)
        return
    }
    
    
}
