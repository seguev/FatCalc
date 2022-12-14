
//  ImageViewModel.swift
//  FatCalc
//
//  Created by segev perets on 27/11/2022.
//

/*
 look at tutotial logic again V
 write it down V
 copy the fuck out of it V
 debug the shit out of it!@#$%
 make pics smaller with round corners
 learn how to make round corenrs and shadows
 add picking app and shadow animation
 learn how to add data to the camera roll
 add body position from privious picture to camera roll
 add date to every picture
 */


import Foundation
import UIKit

class AlbumViewModel {
    
    weak var delegate : AlbumViewController? {
        didSet {
            print("Album delegate has been set!")
        }
    }
    
    var currentImageView : UIImageView?
    
    var imagesArray = [UIImage]()
    var arrayIsDefault = true
    var currentIndex = 0


    enum Direction {
        case right
        case left
    }

    /**
     If func is being called and array is empty, it adds noSign image.
     - call this func again to delete sign image.
     */
    func manageDefaultImage (_ view:UIView) {
        
        if imagesArray.isEmpty {
            
        arrayIsDefault = true
            
            for i in 1...7 {
                imagesArray.append(UIImage(named: "cat\(i)")!)
            }
            
        }
    }
    
   

    
    /**
     takes an image[index] from imageArray, initialize it, add to screen outside of view and asign global var to eat to be refered from next func.
     - dont forget to check is index isn't out of range before calling this func.
     - set index to the desired image in the array before calling this func.
     - adds pan gesture
     - add animation.
     */
    func createImage(_ view:UIView) {

        guard !imagesArray.isEmpty else {fatalError("you need to have photos to call this func")}
        
        let imageView = UIImageView(image: imagesArray[currentIndex])
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width*0.6, height: view.frame.height*0.7)
        
        imageView.center = view.center
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        
        imageView.addGestureRecognizer(pan)
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.isUserInteractionEnabled = true

        view.addSubview(imageView)
        
        addAnimation(imageView, animator: delegate!.animator)
        
        currentImageView = imageView //so I can refer to it globaly
        
        #warning("add photos undernith eatch other at a later stage")
        
//        view.insertSubview(<#T##view: UIView##UIView#>, belowSubview: <#T##UIView#>)
        
    }
    
    private func addAnimation (_ imageView:UIImageView, animator: UIViewPropertyAnimator) {
        guard let view = imageView.superview else {fatalError("first add to superView!")}
        
        animator.addAnimations { //end animation
            imageView.alpha = 0
        }
        
        //if image is left from center
        if imageView.center.x < view.frame.width/2 {
            #warning("add rotation")
        //if image is right from center
        } else if imageView.center.x > view.frame.width/2 {
            #warning("add rotation")
        } else {
            print("Where the fuck is the image?? go to line 121")
        }
        
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
        guard let superView = imageView.superview else {fatalError("no superView")}
        
        //let location on screen and speed
        let location = sender.location(in: superView)
        let speed = sender.velocity(in: superView)
        
        imageView.center.x = location.x
        
        switch sender.state {
            
        case .began,.changed:
            
            let midPoint =  superView.frame.width/2
            
            let distanceFromMid = sender.location(in: superView).x - midPoint
            
            let percestFromMid = abs ( distanceFromMid / midPoint )
            
            print(percestFromMid)
            
            guard let animator = delegate?.animator else {fatalError("couldn't find animator")}
            
            animator.fractionComplete = percestFromMid
            
            if speed.x < -1500 {
                next(imageView as! UIImageView)
            } else if speed.x > 1500 {
                #warning("swipe right")
            }
            
            //if pic is at edge, swipe
        case .ended,.failed:
            if imageView.center.x < superView.frame.width*0.2 {
                #warning("swipe left")
                next(imageView as! UIImageView)
            } else if imageView.center.x > superView.frame.width*0.8 {
                #warning("swipe right")
            }
                        
        default: break
            
        }
    }
    
    
    /**
     - animates out the input UIImageView
     - sets new index
     - creates a new instance of the current
     */
    private func next (_ image:UIImageView) {
        guard let view = image.superview else {fatalError("no superView?")}
        animateOut(to: .left, image: image) //send left
        currentImageView!.removeFromSuperview() //delete
        setNewIndex(next: true) //sets index + 1
        createImage(view) //create new image from new index and sets global var to it.
        guard let currentImage = currentImageView else {fatalError("currentImageView is nil!")} //unwrap global var
        sendToScreen(what: currentImage, from: .right) //send it to screen
    }
    
    
    /**
     Sends UIImage into the screen so the use can see it.
     - this func assume the image is outside of the screen from the right.
     */
    private func sendToScreen (what imageView: UIImageView, from direction:Direction) {
        guard let view = imageView.superview else {fatalError()}
        
        if direction == .right {
            UIView.animate(withDuration: 0.2) {
                imageView.center.x = view.center.x
            }
        } else if direction == .left {
            
            //send image to left
            let halfImageSize = imageView.frame.width/2
            
            imageView.center.x = 0 - halfImageSize //sets right outside of the screed
            UIView.animate(withDuration: 0.2) {

                //animate to screen
                imageView.center.x = view.center.x
            }
        }
        
    }
    
    
    /**
     animates out currentPicture if exist and then removes it from superView.
     - does NOT call next image. should call it after this func.
     */
    private func animateOut(to direction: Direction, image:UIImageView) {
        let halfImage = image.frame.width/2
        guard let view = image.superview else {fatalError("WTF")}
        
        if direction == .right {
            UIView.animate(withDuration: 0.3) {
                image.frame.origin.x = view.frame.width
            }
        } else if direction == .left {
            UIView.animate(withDuration: 0.3) {
                image.center.x = 0 - halfImage
            }
        } else {
            fatalError("WTF")
        }
        
    }
            
    private func setNewIndex (next:Bool = false,previous:Bool = false) {
        if next {
            print("index was \(currentIndex)")
            currentIndex += 1
            print("and now its \(currentIndex)")
        } else if previous{
            print("index was \(currentIndex)")
            currentIndex -= 1
            print("and now its \(currentIndex)")
        } else {
            fatalError("this is not supposed to happed!")
        }
    }
  

    init(delegate: AlbumViewController? = nil, currentImageView: UIImageView? = nil, imagesArray: [UIImage] = [UIImage](), currentIndex: Int = 0) {
        self.delegate = delegate
        self.currentImageView = currentImageView
        self.imagesArray = imagesArray
        self.currentIndex = currentIndex
    }
    
}

