
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
        makeButtonRound(tapeButton)
        makeButtonRound(caliperButton)

    }
    
 
    
    @IBAction func calcWithCaliper(_ sender: UIButton) {
     
        performSegue(withIdentifier: "toCaliper", sender: self)
        
    }
    
    @IBAction func calcWithTape(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toTape", sender: self)
        
    }

    
}
