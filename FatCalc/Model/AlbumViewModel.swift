//
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

struct AlbumViewModel {
    
    var album : AlbumViewController?
    
    var currentImageView : UIImageView?
    
    var imagesArray : [UIImage] = []
    
    var currentIndex : Int = 0
    

    enum Direction {
        case right
        case left
    }
    

    
    /**
     sets "nosign" system image if imageArray is empty and removes it when its not .
     */
    mutating func setDefaultImage () {
            
        if imagesArray.isEmpty {
            let defaultImage = UIImage(systemName: "nosign")!
            imagesArray.append(defaultImage)
        } else {
            if imagesArray.contains(UIImage(systemName: "nosign")!){
                imagesArray.remove(at: 0)
            }
        }
    }
    
    /**
     some random cute dog images.
     */
    mutating func addDefaultPhotos () {

        for i in 1...7 {
            imagesArray.append(UIImage(named: "cat\(i)")!)
        }
        //        let firstDog = UIImage(named: "dog1")
        //        imageArray.append(firstDog!)
        
        
    }
    
    /**
     checks if index is in range and sets currentPicture global var accordingly
     - call this func to validate
     - and then use currentPicture var to continue
     */
    mutating func makeSureIndexIsValid (andAddTo view:UIView) {
        
        var isFirstloading = true
        
        if let validImageView = createImage(view: view) {

            currentImageView = validImageView
            if isFirstloading {
                currentIndex += 1
                animateIn(what: validImageView, from: .left)
                isFirstloading = false
                print("currentIndex is \(currentIndex)")
            }
        } else {
            currentIndex = 0
            makeSureIndexIsValid(andAddTo: view)
        }
    }
    
    /**
     creates an imageView from the next UIImage in array accurding to currrent index
     - return nil if index is out of range and the privous func should handle it
     - adds panGesture to the new imageView
     - takes image(i) from array
     */
    func createImage(view:UIView) -> UIImageView? {
        guard let album = album else {fatalError()}

        guard currentIndex < imagesArray.count else {
            print("\(#function) returning nil")
            return nil
        }
  
        
        let imageView = UIImageView(image: imagesArray[currentIndex])
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height*0.8)
        
        imageView.center = view.center
        
        let pickUpGesture = UIPanGestureRecognizer(target: self, action: #selector(album.drag(_:)))
        
        imageView.addGestureRecognizer(pickUpGesture)
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.isUserInteractionEnabled = true

        return imageView
    }
    
    /**
     gets the current picture into screen
     - sets new index according to swipe direction
     - creates image from index
     - animate ot inside screen
     */
    mutating func animateIn (what imageView: UIImageView, from direction:Direction) {
        guard let album = album else {fatalError()}
        
        if direction == .right { //left swipe! = next picture
            currentIndex += 1
            if let nextPic = createImage(view: album.view) {
                album.view.insertSubview(nextPic, at: 1)
                
                
                
            } else {
                
            }
            UIView.animate(withDuration: 0.3) {
                imageView.center = album.view.center
            }
        } else if direction == .left {
            currentIndex -= 1
            createImage(view: album.view)
            
            //set image to left off screen and then set to center
            imageView.center = CGPoint(x: 0-(album.view.frame.width/2), y: imageView.center.y)
            imageView.center = album.view.center
            
        }
    }
    
    
    /**
     animates out currentPicture if exist and then removes it from superView.
     - does NOT call next image. should call it after this func.
     */
    mutating func animateOut(to direction: Direction) {
        guard let currentImageView = currentImageView, let album = album else {fatalError()}

        if direction == .left {
            UIView.animate(withDuration: 0.3) {
                currentImageView.frame.origin.x = 0-currentImageView.frame.width
            } completion: { [weak self] _ in
                guard var strongSelf = self else {fatalError()}
                currentImageView.removeFromSuperview()
                strongSelf.currentIndex += 1
                strongSelf.animateIn(what: currentImageView, from: .right)
            }
        } else if direction == .right {
            UIView.animate(withDuration: 0.3) {
                currentImageView.frame.origin.x = album.view.frame.width+currentImageView.frame.width
            } completion: { [weak self] _ in
                guard var strongSelf = self else {fatalError()}
                currentImageView.removeFromSuperview()
                strongSelf.currentIndex -= 1
                strongSelf.animateIn(what: currentImageView, from: .left)
            }
            } else {
                fatalError("WTF")
            }
        }
        
    
    
        

    
    
    
    
    mutating func nextImage () {
        guard let album = album else {fatalError()}
        
        makeSureIndexIsValid(andAddTo: album.view)
        animateOut(to: .left)
        animateIn(what: currentImageView!, from: .right)
    }
    
    mutating func priviousImage () {
        guard let album = album else {fatalError()}
        makeSureIndexIsValid(andAddTo: album.view)
        animateOut(to: .right)
        animateIn(what: currentImageView!, from: .left)
    }
    
    
    
}

