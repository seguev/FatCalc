//
//  ViewController.swift
//  FatCalc
//
//  Created by segev perets on 07/11/2022.
//

import UIKit

class ViewController: UIViewController {
    #warning("Add weight log functionality")
    #warning("Add tape body fat calculator ")
    #warning("Add caliper body fat calculator")
    #warning("Add graph view with weight and body fat")
    #warning("Add photos library with coreData(?) or realm")
    #warning("add user auth at the very end! only when everything works")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let firstColor = #colorLiteral(red: 0.01960784314, green: 0.8509803922, blue: 1, alpha: 1)
        let secondColor = #colorLiteral(red: 0.05490196078, green: 0.4549019608, blue: 0.9882352941, alpha: 1)
        addGradient(firstColor: firstColor, secondColor: secondColor)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func guestButtonPressed(_ sender: UIButton) {
        //no need to setup segue. this one has no standard
        performSegue(withIdentifier: "guestLog", sender: self)
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        //logIn with fireBase
        let alertController = Funcs.shared.comingSoonAlertController()
        self.present(alertController, animated: true)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        //signUp with fireBase
        let alertController = Funcs.shared.comingSoonAlertController()
        self.present(alertController, animated: true)
        
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let main = 0
            //let bodyFat = 1
            //let photos = 2
            //let weight = 3

            
            //set tab bar cons from destination and cast as UITabBarController
            let tabBar = segue.destination as! UITabBarController
            
            //print controllers arrays with Tags to debug
            print ("the controllers are: \(tabBar.viewControllers!)")
            
            if segue.identifier == "guestLog" {
                print("guest loged in")
                
                //if guest, set shared "isLoged" variable to false.
                Funcs.shared.isLoged = false
                
                //set mainVC as the 0 n from the controllers array and cast
                let mainVC = tabBar.viewControllers?[main] as! MainViewController
                
                //set its loged property to false (cause guest)
                //mainVC.isLoged = false
            }

        }
    
    
    
    
    
    
    

}

extension ViewController {
    func addGradient (firstColor:UIColor, secondColor:UIColor) {
        let layer = CAGradientLayer()
        let colors = [firstColor.cgColor, secondColor.cgColor]
        layer.colors = colors
        layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
    }
}

 
