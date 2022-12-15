

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

    let animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: view)
        model.delegate = self
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        
        model.manageDefaultImage(view)
        //creates the first image
        model.createImage(view)
        
        model.sendToScreen(what: model.currentImageView!, from: .right)
    }
    
    @IBAction func addNewImage(_ sender: UIButton) {
        present(picker, animated: true)
    }
    
}


// MARK: - ImagePicker funcs
extension AlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[.originalImage] as? UIImage {
            
            if model.arrayIsDefault { //clean array if full of cats photos
                model.imagesArray = []
                model.arrayIsDefault = false
            }
            
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
