
import UIKit

class ResultViewController: UIViewController {

    /*
     seld to root after saving V
     show a quick label that says "Entry saved", can write it by code
     add isPresentingLabel Boolian var to prevent twho labels at once
     */
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    
    var result : String = "" {
        didSet {
            print(result)
        }
    }

    var gender : CaliperCalcModel.Gender = .Male
    
    var model = WeeklyWeightModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isValid = checkIfValidResult(result)
        
        guard isValid else {
            resultLabel.text = "Error"
            handleWrongParameters()
            return
        }
        if gender == .Male {
            menHealthFat()
        } else if gender == .Female {
            womenHealthFat()
        } else {
            print("ERROR, gender = \(gender) ")
        }
        
        addGradient(view: view)

    }
    
    private func checkIfValidResult (_ resultString : String ) -> Bool {
        guard let r = Float(resultString) else {return false}
        
        let isValid = r > 2 && r < 60
        if !isValid {return false}
        
        else {
            resultLabel.text = resultString+"%"
         return true
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        guard let resultFloat = Float(result) else {fatalError("could not convert result into Float")}
        
        NotificationCenter.default.post(name: fatUpdateNotification, object: resultFloat)
  
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func againPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    private func menHealthFat () {
        
        if let resultFloat = Float(result) {
            categoryLabel.clipsToBounds = true
            var c : UIColor?
            
            switch resultFloat{
            case 2..<6:
                c = .systemGreen
                categoryLabel.text = "Essential Fat"
            case 6..<14:
                c = .systemBlue
                categoryLabel.text = "Typical Athletes"
            case 14..<18:
                c = .systemYellow
                categoryLabel.text = "Fitness"
            case 18..<26:
                c = .systemOrange
                categoryLabel.text = "Acceptable"
            case 26...:
                c = .systemRed
                categoryLabel.text = "Obese"
            default:
                c = .darkGray
                categoryLabel.text = ""
            }
            
            (categoryLabel.superview!).backgroundColor = c!
            (categoryLabel.superview!).layer.cornerRadius = 15
        }
       
    }
    
    func womenHealthFat () {
        if let resultFloat = Float(result) {
            switch resultFloat{
            case 10..<14:
                view.backgroundColor = .systemGreen
                categoryLabel.text = "Essential Fat"
            case 14..<21:
                view.backgroundColor = .systemBlue
                categoryLabel.text = "Typical Athletes"
            case 21..<25:
                view.backgroundColor = .systemYellow
                categoryLabel.text = "Fitness"
            case 25..<32:
                view.backgroundColor = .orange
                categoryLabel.text = "Acceptable"
            case 32...:
                view.backgroundColor = .systemRed
                categoryLabel.text = "Obese"
            default:
                handleWrongParameters()
            }
        }
       
    }
    
    private func handleWrongParameters () {
        categoryLabel.isHidden = true
        let errorAlert = UIAlertController(title: "wrong parameters", message: "Your result doesn't make sense! please enter your measurements again.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Try again", style: .destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(errorAlert, animated: true)
    }
    
    /*
     Essential Fat
    10–13% women
    2–5% men
    Typical Athletes
    14–20% women
    6–13% men
    Fitness (In Shape)
    21–24% women
    14–17% men
    Acceptable
    25–31% women
    18–25% men
    Obese
    32%+ women
    25%+ men
     */

}
