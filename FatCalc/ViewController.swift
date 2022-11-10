//
//  ViewController.swift
//  FatCalc
//
//  Created by segev perets on 07/11/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }
    
    @IBAction func guestButtonPressed(_ sender: UIButton) {
        //no need to setup segue. this one has no standard
        performSegue(withIdentifier: "guestLog", sender: self)
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        self.present(showAlert(alertTitle: "Not Available yet!", alertMessage: ""), animated: true)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        self.present(showAlert(alertTitle: "Not Available yet!", alertMessage: ""), animated: true)
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
    
    
    
    
    
    
    private func addGradient (firstColor:UIColor, secondColor:UIColor, view:UIView) {
        let layer = CAGradientLayer()
        let colors = [firstColor.cgColor, secondColor.cgColor]
        layer.colors = colors
        //layer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
    }

}

 private func showAlert (alertTitle:String?, alertMessage:String?) -> UIViewController {
    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
     let action = UIAlertAction(title: "Dismiss", style: .cancel)
     alert.addAction(action)
    
     return alert
}
