

/*
delete scrollView V
 add imageView stack insted V
 add swiping animation
 add date label with index attached to each photo
 add images to coreData and load when entring app
 */

import UIKit

class AlbumViewController: UIViewController, UIScrollViewDelegate {
    
    var model = AlbumViewModel()
    
    let picker = UIImagePickerController()

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.album = self
        
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        
        Funcs.shared.addGradient(view: view)
        model.addDefaultPhotos()
        model.makeSureIndexIsValid(andAddTo: view)

        //swipes left, pic animateOut to the left, index += 1 and imageArray( i ) is created and animates in from the right
        //swipes right, pic animateOut to the right, index -= 1 and imageArray( i ) is created and animates in from the left
    
    }
    
    @IBAction func addNewImage(_ sender: UIButton) {
        present(picker, animated: true)
    }
    

    
    /**
     the draging animation
     - checks if currentPic object isn't nil
     - switch sender.state
     - if began or changed: set shadow (looks like picking it up)
     - and set currentImage object's center as the draging finger's location.
     - when dragging is ended, removes shadow
     */
    @objc func drag (_ sender: UIPanGestureRecognizer) {
        guard let imageView = sender.view else {fatalError()}
        
        //let location on screen and speed
        let location = sender.location(in: view)
        let speed = sender.velocity(in: view)
        
        //set alpha according to position
        if location.x < view.frame.width/2 {
            let distanceFromEdge = location.x/(view.frame.width/2)
            imageView.alpha = distanceFromEdge
        } else {
            let distanceFromEdge = abs(location.x-view.frame.width)/view.frame.width
            imageView.alpha = distanceFromEdge
        }
        
        switch sender.state {
            
        case .began,.changed:
            
            //moving functionality
            imageView.center.x = location.x
            
            //swipe if fast gesture
            if speed.x < -1500 {
                model.currentIndex += 1
                model.nextImage()
            } else if speed.x > 1500 {
                model.currentIndex -= 1
                model.priviousImage()
            }
            
            //if pic is at edge, swipe
        case .ended,.failed:
            UIView.animate(withDuration: 0.5) {
                imageView.layer.shadowOpacity = 0
                imageView.layer.shadowColor = UIColor.clear.cgColor
            }
            
            if imageView.center.x < 90 {
                model.currentIndex += 1
                model.nextImage()
                
            } else if imageView.center.x > 300 {
                model.currentIndex -= 1
                model.priviousImage()
            }
            
            break
            
        default: break
        }
    }
    
    
    

}


// MARK: - ImagePicker funcs
extension AlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[.originalImage] as? UIImage {
            
            model.imagesArray.append(imagePicked)
            
            
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true)
        return
    }
    
}
