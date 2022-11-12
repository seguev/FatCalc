//
//  weightViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class AlbumViewController: UIViewController, UIScrollViewDelegate {
    
#warning("delete weight after setButtonPressed")
#warning("write show NoImage icon when array is blank")
#warning("create image and weight struct, each photo present its weight, you can add weigh to each photo")
    #warning("save everything in coreData")
    #warning("delete login page, too many bugs and not nessesery yet")
    
    @IBOutlet var popUpView: UIView!
    
    @IBOutlet weak var weightTextField: UITextField!
    let scrollView: UIScrollView = {
     let scroll = UIScrollView()
     scroll.isPagingEnabled = true
     scroll.showsVerticalScrollIndicator = false
     scroll.showsHorizontalScrollIndicator = false
     scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
     return scroll
     }()
    

    var weightArray = [Float]()
    
    var imageArray = [UIImage]() {
        didSet {
            setupImages(imageArray)
            print("new image has been added : \(imageArray.first!)")
        }
    }
    
    let picker = UIImagePickerController()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view) //set color
        weightTextField.delegate = self
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        view.addSubview(scrollView)
        view.layer.insertSublayer(scrollView.layer, at: 1)
        
        //set popUpView size
        //self.view.bounds.width * 0.2 = 20% from view's width
        popUpView.bounds = CGRect(x: 0, y: 0, width: 200 , height: 150)
        let xPosition = self.view.center.x
        let yPosition = self.view.center.y+30
        popUpView.center = .init(x: xPosition, y: yPosition)




    }
   
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        animateOut(popUp: popUpView)
    }
    
    @IBAction func addNewImage(_ sender: UIButton) {
        
        present(picker, animated: true)
    }
    
    func addDogImages () {
        imageArray = [#imageLiteral(resourceName: "dog2"), #imageLiteral(resourceName: "dog3"), #imageLiteral(resourceName: "dog1")]
    }
    
    
    func setupImages(_ images: [UIImage]){
        
        //n=count, for n times run for loop. i=n.
        for i in 0..<images.count {
            
            let imageView = UIImageView()
             imageView.image = images[i]
             let xPosition = UIScreen.main.bounds.width * CGFloat(i)
             imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
             imageView.contentMode = .scaleAspectFit

            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
             scrollView.addSubview(imageView)
             scrollView.delegate = self
            
            
        }
        
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
// MARK: - weight popUp
extension AlbumViewController: UITextFieldDelegate {
   
    
   
    
    
    @IBAction func addWeight(_ sender: UIButton) {
        animateIn(popUp: popUpView)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        animateOut(popUp: popUpView)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            print(text.count)
            #warning("still counting even when false and cant delete cause out of range")
            print("new character is \(string)") //new characters
            if text.contains(".") { //if theres a dot
                if string == "." { //dont allow any other dot
                    return false
                }
//                if text.count > 5 { //if theres a dot, max characters is 5
//                    return false
//                }
                
               
            }
//            if text.count > 3 { //if there isn't a dot, max character is 3
//                return false
//            }
        }
        return true //allow range to change
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("editing")
    }
    
    
    
    
    
    func animateIn (popUp:UIView) {
        let background = self.view!
        
        //make our popUp apear
        background.addSubview(popUp)
        
        
        //make it 120% bigger
        popUp.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        //make invisible
        popUp.alpha = 0
        
        //show
        UIView.animate(withDuration: 0.5) {
            popUp.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            //make invisible
            popUp.alpha = 1
        }
        
    }
    
    
    func animateOut (popUp:UIView) {
        UIView.animate(withDuration: 0.5) {
            popUp.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            popUp.alpha = 0
        } completion: { _ in
            popUp.removeFromSuperview()
        }

       
    }
    
    
    
    
    
    
}
