

/*
delete scrollView V
 add imageView stack insted V
 add swiping animation
 add date label with index attached to each photo
 add images to coreData and load when entring app
 */

import UIKit

class AlbumViewController: UIViewController, UIScrollViewDelegate {
    
    let model = ImageViewModel()

    
    let picker = UIImagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()
        model.album = self
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        Funcs.shared.addGradient(view: self.view)
        model.addDogImages()
        model.setImage(self.view)
    }
    
    @IBAction func addNewImage(_ sender: UIButton) {
        present(picker, animated: true)
    }
    

}


// MARK: - ImagePicker funcs
extension AlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[.originalImage] as? UIImage {
            
            model.imageArray.append(imagePicked)
            
            if model.imageArray.count == 1 {
                model.setImage(self.view)
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
