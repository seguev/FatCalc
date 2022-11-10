//
//  mainViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class MainViewController: UIViewController  {
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //get current name from shared func
        let currentControllerName = Funcs.shared.fetchNameFromCurrent(self)
        
        if Funcs.shared.isLoged == false {
            print("guest!")
        }
        
        print("current controller is \(currentControllerName)")
        
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func addWeight(_ sender: UIButton) {
        comingSoon()

    }
    @IBAction func calcWithCaliper(_ sender: UIButton) {
        comingSoon()

    }
    
    @IBAction func calcWithTape(_ sender: UIButton) {
        comingSoon()
    }
    private func comingSoon () {
        self.present(Funcs.shared.comingSoonAlertController(), animated: true)
    }
    
}
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[.originalImage] as? UIImage {
            
            //save imagePicked
            #warning("save with coreData or realm")
        }
        
        picker.dismiss(animated: true)
        
        
        comingSoon()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true)
        return
    }
}
