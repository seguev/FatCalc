//
//  weightViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class AlbumViewController: UIViewController, UIScrollViewDelegate {
 
    /*
     add images to screen
     add swipe gesture with animation
     */
    
    var currentIndex = 0
    var currentPicture : UIImageView?
    
    var imageArray = [UIImage]() {
        didSet {
            setImages()
        }
    }
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //color setup
        Funcs.shared.addGradient(view: self.view)
        pickerSetup()
        
        //addDogImages() ;#warning("for debug")

        //setImages()
    }
    
    func pickerSetup () {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
    }
    func setDefaultImage () {
        if imageArray.isEmpty {
            let defaultImage = UIImage(systemName: "nosign")!
            imageArray.append(defaultImage)
        } else {
            if imageArray.contains(UIImage(systemName: "nosign")!){
                imageArray.remove(at: 0)
            }
        }
    }
    func addDogImages () {
        imageArray = [#imageLiteral(resourceName: "dog2"), #imageLiteral(resourceName: "dog3"), #imageLiteral(resourceName: "dog1")]
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDefaultImage() //set X if no images found
    }
    

   func setImages() {
       //create image view from image[index]
        let imageView = UIImageView(image: imageArray[currentIndex])
       
       //locate at the center
       imageView.frame = CGRect(x: self.view.frame.width/2-100, y: 200, width: 200, height: 260)
       imageView.contentMode = .scaleAspectFit
       imageView.isUserInteractionEnabled = true
       imageView.layer.borderColor = UIColor.darkGray.cgColor
       imageView.layer.borderWidth = 2
       
       self.view.addSubview(imageView)
       
       currentPicture = imageView
       
       let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.nextPicture))
       swipeLeft.direction = .left
       imageView.addGestureRecognizer(swipeLeft)
       
       let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.previousPicture))
       swipeRight.direction = .right
       imageView.addGestureRecognizer(swipeRight)
    }
    
    @objc func nextPicture () {
        print(#function)
        swipeLeftAnimation()
        animateInNextPicture()
        self.currentIndex += 1
        
    }
    func swipeLeftAnimation() {
        guard let currentPicture = currentPicture else {return}
        UIView.animate(withDuration: 0.5) {
            currentPicture.frame.origin.x = -currentPicture.frame.width
        }
    }
    
    func animateInNextPicture () {
        #warning("continue from here")
        swipeLeftAnimation()

    }
    
    @objc func previousPicture () {
        print(#function)

    }
    
    //button pressed
    @IBAction func addNewImage(_ sender: UIButton) {
        present(picker, animated: true)
    }
    
}

extension AlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[.originalImage] as? UIImage {
            
            imageArray.append(imagePicked)
            
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true)
        return
    }
 
    
    
    
    
    
    
}
