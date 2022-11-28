//
//  ImageViewModel.swift
//  FatCalc
//
//  Created by segev perets on 27/11/2022.
//

import Foundation
import UIKit


class ImageViewModel {
    
    var currentIndex = 0
    var currentPicture : UIImageView?
    var isActive = false
    var imageArray = [UIImage]()

    var album : AlbumViewController?

    /**
     sets "nosign" system image if imageArray is empty and removes it when its not .
     */
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
    
 /**
  some random cute dog images.
  */
    func addDogImages () {
        imageArray = [#imageLiteral(resourceName: "dog2"), #imageLiteral(resourceName: "dog3"), #imageLiteral(resourceName: "dog1")]
        
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
    func setImage (_ view:UIView) {
        guard !imageArray.isEmpty else {
            print("No pictures for now")
            return
        }
        
        if let currentImage = createImage(view: view) {
            currentPicture = currentImage
            showPicture(currentImage, view: view)
            self.currentIndex += 1
        } else { //if index is out of range, make it zero and cycle func
            currentIndex = 0
            setImage(view)
        }
    }
    

    private func createImage(view:UIView) -> UIImageView? {
        
        
        
        guard currentIndex < imageArray.count else {return nil}
        
        let imageView = UIImageView(image: imageArray[currentIndex])
                
        imageView.frame = CGRect(x: view.frame.width, y: view.center.y-130, width: 200, height: 260)
        
        let pickUpGesture = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        
        imageView.addGestureRecognizer(pickUpGesture)
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.isUserInteractionEnabled = true
        
        currentPicture = imageView
        
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
        guard let currentPicture = currentPicture else {fatalError()}
        
        guard let view = album?.view else {fatalError()}

        let location = sender.location(in: view)
        

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
                currentPicture.layer.shadowColor = UIColor.green.cgColor
            } else if location.x > 300 {
                    currentPicture.layer.shadowColor = UIColor.red.cgColor
            } else {
                currentPicture.layer.shadowColor = UIColor.gray.cgColor
            }

        

        case .ended,.failed:
            
            UIView.animate(withDuration: 0.5) {
                currentPicture.layer.shadowOpacity = 0
                currentPicture.layer.shadowColor = UIColor.clear.cgColor
            }
            if currentPicture.center.x < 90 {
                animateOut()
                setImage(view)
            } else {
                currentPicture.layer.shadowColor = UIColor.gray.cgColor
            }
         
            break
            
        default: break
            
        }
    }
    
 
    
    /**
     add the imageView as a subView to the view and then animates it in.
     */
    func showPicture (_ imageView:UIImageView, view:UIView) {
        
        view.addSubview(imageView)
                
        UIView.animate(withDuration: 0.3) {
            
            imageView.center = view.center
        }
    }
    

    
    
    private func animateOut() {
        guard let currentPicture = currentPicture else {return}
        UIView.animate(withDuration: 0.3) {
            currentPicture.frame.origin.x = -currentPicture.frame.width

        } completion: { _ in
            
            currentPicture.removeFromSuperview()
        }

    }
}

