
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
        Funcs.shared.makeButtonRound(tapeButton)
        Funcs.shared.makeButtonRound(caliperButton)

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
