//
//  weightViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class AlbumViewController: UIViewController, UIScrollViewDelegate {
#warning("save it to coreData")
    
    @IBOutlet weak var scrollView: UIScrollView!
    var weightArray = [Float]()
    
    var imageArray = [UIImage]() {
        didSet {
            print("new image has been added : \(imageArray.first?.description)")
            setupImages(imageArray)
        }
    }
    
    let picker = UIImagePickerController()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view) //set color
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        
        // Do any additional setup after loading the view.
        //addDogImages()
        //setupImages(imageArray)
        
        



    }
    
    @IBAction func addNewImage(_ sender: UIButton) {
        
        present(picker, animated: true)
    }
    
    func addDogImages () {
        imageArray = [#imageLiteral(resourceName: "dog2"), #imageLiteral(resourceName: "dog3"), #imageLiteral(resourceName: "dog1")]
    }
    
    func setupImages(_ images: [UIImage]){
        
        for i in 0..<images.count {
            
            let imageView = UIImageView() //create new instance of ImageView for eatch image
            imageView.image = images[i] //attach the actual image from eatch one to the new imageView
            
            
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height) //set eatch imageView's frame
            
            imageView.contentMode = .scaleAspectFit //save relative photo aspect
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            
            
            scrollView.addSubview(imageView) //add the imageView after setup to scroll view
            scrollView.delegate = self
            
            
        }
        
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
            
            imageArray.append(imagePicked)
            
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
