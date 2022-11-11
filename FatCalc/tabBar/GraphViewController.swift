//
//  bodyFatViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit

class GraphViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        //get current name from shared func
        let currentControllerName = Funcs.shared.fetchNameFromCurrent(self)
        
        if Funcs.shared.isLoged == false {
            print("guest!")
        }
        
        print("current controller is \(currentControllerName)")

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
