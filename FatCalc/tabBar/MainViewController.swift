//
//  mainViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class MainViewController: UIViewController  {
    #warning("add calculation with tame and with caliper to Func.Shared")
    #warning("add caliper calculationController")
    #warning("add tape measure calculationController")
    #warning("set resultController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view)

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //get current name from shared func
        let currentControllerName = Funcs.shared.fetchNameFromCurrent(self)
        
        if Funcs.shared.isLoged == false {
            print("guest!")
        }
        
        print("current controller is \(currentControllerName)")
        
    }
    
    
    @IBAction func calcWithCaliper(_ sender: UIButton) {
     
        performSegue(withIdentifier: "toCaliper", sender: self)
        
    }
    
    @IBAction func calcWithTape(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toTape", sender: self)
        
    }
    private func comingSoon () {
        self.present(Funcs.shared.comingSoonAlertController(), animated: true)
    }
    
}
