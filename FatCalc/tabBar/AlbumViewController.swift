//
//  weightViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class AlbumViewController: UIViewController, UIScrollViewDelegate {
    #warning("attach value to each photo")
    #warning("attach value to each date and weight")
    #warning("change date and weight when phhoto is swiped")
#warning("each photo present its weight, you can add weigh to each photo")
    #warning("save everything in coreData")
    @IBOutlet weak var imageDateLabel: UILabel!
    
    @IBOutlet weak var imageWeightLabel: UILabel!
    @IBOutlet var popUpView: UIView!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    var imageIndex : Int? { //every complited scroll
        didSet{ //when scrolled. index is set and weight text is changed to arrays[i] weight
            print("index has been set to \(imageIndex!)")
                imageWeightLabel.text = weightsArray[imageIndex!]
            #warning("out of range if no weights")
            #warning("only updated after scrolling")
        }
    }
    
    var weightsArray = [String]()
    
    let scrollView: UIScrollView = {
     let scroll = UIScrollView()
     scroll.isPagingEnabled = true
     scroll.showsVerticalScrollIndicator = false
     scroll.showsHorizontalScrollIndicator = false
        scroll.minimumZoomScale = 1
        scroll.maximumZoomScale = 1
     scroll.frame = CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-200)
         return scroll
     }()
    

    
    var imageArray = [UIImage]() {
        didSet {
            setupImages(imageArray) //add to scrollView
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDefaultImage()

    }
    
    @IBAction func setPressed(_ sender: UIButton) {
        
        animateOut(popUp: popUpView)
    }
    
    
    @IBAction func addNewImage(_ sender: UIButton) {
        present(picker, animated: true)
    }
    
    func addDogImages () {
        imageArray = [#imageLiteral(resourceName: "dog2"), #imageLiteral(resourceName: "dog3"), #imageLiteral(resourceName: "dog1")]
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
    
    
    
    
    @IBAction func xPressed(_ sender: UIButton) {
        #warning("delete image")
        animateOut(popUp: popUpView)
    }
    
}

extension AlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[.originalImage] as? UIImage {
            
            imageArray.append(imagePicked)
            
            
        }
        
        picker.dismiss(animated: true)
        animateIn(popUp: popUpView)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true)
        return
    }
    // MARK: - scrolling detection
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentImageIndex = Int(targetContentOffset.move().x/390)
        imageIndex = currentImageIndex
    }
    
}
// MARK: - weight popUp
extension AlbumViewController: UITextFieldDelegate {
   
    
    @IBAction func addWeight(_ sender: UIButton) {
        animateIn(popUp: popUpView)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {return}
        
        weightsArray.append(text)
        print("appending \(text) to weight array")
        print("weights are: \(weightsArray)")
//        imageDateLabel.text = Date().formatted(date: .numeric, time: .omitted)
        textField.text = ""
        resignFirstResponder()
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
   
               
            }

        }
        return true //allow range to change
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
        UIView.animate(withDuration: 0.2) {
            popUp.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            //make invisible
            popUp.alpha = 1
        }
        
    }
    
    
    func animateOut (popUp:UIView) {
        UIView.animate(withDuration: 0.2) {
            popUp.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            popUp.alpha = 0
        } completion: { _ in
            popUp.removeFromSuperview()
        }

       
    }
    
    
    
    
    
    
}
