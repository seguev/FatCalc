//
//  bodyFatViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class GraphViewController: UIViewController {

    #warning("only after images and weights are saved into coreData")
    #warning("learn about graphs .")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //get current name from shared func
        let currentControllerName = Funcs.shared.fetchNameFromCurrent(self)
        
        if Funcs.shared.isLoged == false {
            print("guest!")
        }
        
        print("current controller is \(currentControllerName)")

    }

    

}
