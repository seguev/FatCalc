//
//  ImageViewModel.swift
//  FatCalc
//
//  Created by segev perets on 27/11/2022.
//

import Foundation
import UIKit


class ImageViewModel {
    
    var controller : AlbumViewController? {
        didSet {
            print("ImageViewModel has a delegate : \(controller!)")
        }
    }

    /**
     sets "nosign" system image if imageArray is empty and removes it when its not .
     */
    func setDefaultImage () {
        if controller!.imageArray.isEmpty {
            let defaultImage = UIImage(systemName: "nosign")!
            controller!.imageArray.append(defaultImage)
        } else {
            if controller!.imageArray.contains(UIImage(systemName: "nosign")!){
                controller!.imageArray.remove(at: 0)
            }
        }
    }
    
 /**
  some random cute dog images.
  */
    func addDogImages () {
        controller!.imageArray = [#imageLiteral(resourceName: "dog2"), #imageLiteral(resourceName: "dog3"), #imageLiteral(resourceName: "dog1")]
        
    }
    
    /**
     creates UIImageView if index isn't out of range .
     - get UIImage global object and make ImageView from it
     - put it outside of the screen
     - add panGesture
     - set ImageView global object as the imageView created
     - making sure index isn't out of range
     - seting imageView to global object
     - if index is out of range, set index to 0 and start over
     */
    func setImage () {
        guard let controller = controller else {fatalError("no controller")}
        guard !controller.imageArray.isEmpty else {
            print("No pictures for now")
            return
        }
        
        if let currentImage = createImage() {
            controller.currentPicture = currentImage
            showPicture(currentImage)
        } else { //if index is out of range, make it zero and cycle func
            controller.currentIndex = 0
            setImage()
        }
    }
    

    private func createImage() -> UIImageView? {
        
        
        
        guard controller!.currentIndex < controller!.imageArray.count else {return nil}
        
        let imageView = UIImageView(image: controller!.imageArray[controller!.currentIndex])
                
        imageView.frame = CGRect(x: controller!.view.frame.width, y: controller!.view.center.y-130, width: 200, height: 260)
        
        let  pickUpGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        
        imageView.addGestureRecognizer(pickUpGesture)
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.isUserInteractionEnabled = true
        
        controller!.currentPicture = imageView
        
        return imageView
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
        guard let currentPicture = controller!.currentPicture else {fatalError()}
 
//        print(sender.location(in: controller!.view))
        let location = sender.location(in: controller!.view)
        

        switch sender.state{
            
        case .began,.changed:

            UIView.animate(withDuration: 0.5) {
                
                currentPicture.layer.shadowOpacity = 1
                currentPicture.layer.shadowRadius = currentPicture.bounds.height/2
                currentPicture.layer.shadowColor = UIColor.black.cgColor
                
            }

            currentPicture.center = location
            
            //cant do an action here cause this is called like 9000 times per second
            if location.x < 90 {
                controller!.currentPicture?.layer.shadowColor = UIColor.green.cgColor
            } else if location.x > 300 {
                    controller!.currentPicture?.layer.shadowColor = UIColor.red.cgColor
            } else {
                controller!.currentPicture?.layer.shadowColor = UIColor.gray.cgColor
            }

        

        case .ended,.failed:
            
            UIView.animate(withDuration: 0.5) {
                currentPicture.layer.shadowOpacity = 0
                currentPicture.layer.shadowColor = UIColor.clear.cgColor
            }
            if currentPicture.center.x < 90 {
                animateOut()
                self.setNextImage()
            } else {
                controller!.currentPicture?.layer.shadowColor = UIColor.gray.cgColor
            }
         
            break
            
        default: break
            
        }
    }
    
    /**
     call showImage to activate this func!
     */
    private func animateIn(_ imageView:UIImageView) {
        
        UIView.animate(withDuration: 0.3) {
            
            imageView.center = self.controller!.view.center
        }
    }
    
    /**
     add the imageView as a subView to the view and then animates it in.
     */
    func showPicture (_ imageView:UIImageView) {
        
        controller!.view.addSubview(imageView)

        animateIn(imageView)
    }
    
    private func setNextImage () {
        controller!.currentIndex += 1
        setImage()
        
    }
    
    
    private func animateOut() {
        guard let currentPicture = controller!.currentPicture else {return}
        UIView.animate(withDuration: 0.3) {
            currentPicture.frame.origin.x = -currentPicture.frame.width

        } completion: { _ in
            
            currentPicture.removeFromSuperview()
        }

    }
}

