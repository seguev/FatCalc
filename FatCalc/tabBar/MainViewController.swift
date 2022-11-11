//
//  mainViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class MainViewController: UIViewController  {
    
    
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
        

    }
    
    @IBAction func calcWithTape(_ sender: UIButton) {
        
    }
    private func comingSoon () {
        self.present(Funcs.shared.comingSoonAlertController(), animated: true)
    }
    
}
