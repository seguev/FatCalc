
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
    
    var delegate : AlbumViewController? {
        didSet {
            print("Album delegate has been set!")
        }
    }
    
#warning("animator is not attacing itself to new views, sometimes")
#warning("if image is stated moving, it is being deleted when leaving screen")
#warning("tap gesture is bailing out mid session")
    let animator = UIViewPropertyAnimator(duration: 1, curve: .linear)

    var side : Side = .center {
        willSet{
            let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
            impactGenerator.prepare()
            if newValue != side   {
                if newValue == .right || newValue == .left{
                    print("new value : \(newValue)")
                    impactGenerator.impactOccurred()
                }
            }
        }
    }
    
    enum Side {
        case center; case right; case left
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
        
        animator.addAnimations {
            imageView.alpha = 0.1
        }
        animator.addCompletion { position in
            print("Completed!")
        }
        
        animator.pausesOnCompletion = true
        
        
        
        imageView.alpha = 1
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.isUserInteractionEnabled = true
        
        imageView.frame = CGRect(x: 0, y: 100, width: 300, height: 550)
        
        imageView.layer.cornerRadius = 20
        
        imageView.clipsToBounds = true
        
        imageView.frame.origin.x = view.frame.width
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        
        imageView.addGestureRecognizer(pan)

        view.addSubview(imageView)
        
        
        currentImageView = imageView
                
        
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
                
        let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactGenerator.prepare()
        
        let location = sender.location(in: superView)
        
        imageView.center.x = location.x
        
        let midPoint =  superView.frame.width/2
        
        let distanceFromMid = sender.location(in: superView).x - midPoint
        
        let percestFromMid = abs ( distanceFromMid / midPoint )
        
//        print(percestFromMid)
        print(animator.fractionComplete)
        animator.fractionComplete = percestFromMid
        
        if animator.state == .inactive || animator.state == .stopped {
            print("animator stopped!")
        } else if animator.state == .active {
//            print("still active")
        }
        
        switch sender.state {
            
        case .began,.changed:
    
            if imageView.center.x < superView.frame.width*0.3 {
                
                side = .left
                
            } else if imageView.center.x > superView.frame.width*0.7 {
                
                side = .right
                
            } else {
                
                side = .center
            }
            
            


        case .ended,.failed ,.cancelled:
            
            if imageView.center.x < superView.frame.width*0.3 {

                next(imageView as! UIImageView)
                
            } else if imageView.center.x > superView.frame.width*0.7 {
                
                print("Swiping right")
                
            } else {
                print("should do nothing")
            }
            print(sender)
            
        default:
            break
            
        }
    }
    
    
    
    
    
    
    
    /**
     - animates out the input UIImageView
     - sets new index
     - creates a new instance of the current
     */
    private func next (_ image:UIImageView) {
        
        guard let view = image.superview else {fatalError("no superView?")}
        
        animateOut(to: .left, image: image)
                
        setNewIndex(next: true) //sets index + 1
        
        createImage(view) //create new image from new index and sets global var to it.
        
        sendToScreen(what: currentImageView!, from: .right) //send it to screen
        
    }
    
    
    
    
    /**
     Sends UIImage into the screen so the use can see it.
     - this func assume the image is outside of the screen from the right.
     */
    func sendToScreen (what imageView: UIImageView, from direction:Direction) {
        guard let view = imageView.superview else {fatalError()}
        
        if direction == .right {
            UIView.animate(withDuration: 0.5) {
                imageView.center.x = view.center.x
            }
        } else if direction == .left {
            
            //send image to left
            let halfImageSize = imageView.frame.width/2
            
            imageView.center.x = 0 - halfImageSize //sets right outside of the screed
            UIView.animate(withDuration: 0.5) {

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
 
            UIView.animate(withDuration: 0.5) {
                image.frame.origin.x = view.frame.width
            } completion: { _ in
                image.removeFromSuperview()
            }

        } else if direction == .left {
            UIView.animate(withDuration: 0.5) {
                image.center.x = 0 - halfImage
            } completion: { _ in
                image.removeFromSuperview()
            }

        } else {
            fatalError("WTF")
        }
        
    }
            
    private func setNewIndex (next:Bool = false,previous:Bool = false) {
        if currentIndex < imagesArray.count - 1 { #warning("change this when adding right swipe")
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
        } else { //index is out of range
            currentIndex = 0 //reset
        }
    }
  

    init(delegate: AlbumViewController? = nil, currentImageView: UIImageView? = nil, imagesArray: [UIImage] = [UIImage](), currentIndex: Int = 0) {
        self.delegate = delegate
        self.currentImageView = currentImageView
        self.imagesArray = imagesArray
        self.currentIndex = currentIndex
    }
    
    deinit {
        print("deinit")
    }
    
}

