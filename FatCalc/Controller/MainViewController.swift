
/*
 add buttons V
 add controllers V
 add segues V
 add calculation funcs V
 */

import UIKit

class MainViewController: UIViewController  {
  
    @IBOutlet weak var caliperButton: UIButton!
    @IBOutlet weak var tapeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        CoreDataModel.shared.makeButtonRound(tapeButton)
        CoreDataModel.shared.makeButtonRound(caliperButton)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //get current name from shared func
        let currentControllerName = CoreDataModel.shared.fetchNameFromCurrent(self)

        
        
        print("current controller is \(currentControllerName)")
        
    }
    
    
    @IBAction func calcWithCaliper(_ sender: UIButton) {
     
        performSegue(withIdentifier: "toCaliper", sender: self)
        
    }
    
    @IBAction func calcWithTape(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toTape", sender: self)
        
    }
    private func comingSoon () {
        self.present(CoreDataModel.shared.comingSoonAlertController(), animated: true)
    }
    
}
