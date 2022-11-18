//
//  mainViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class MainViewController: UIViewController  {
    #warning("add tape measure calculationController")
    #warning("set resultController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //get current name from shared func
        let currentControllerName = Funcs.shared.fetchNameFromCurrent(self)
        title = currentControllerName
        
        
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
