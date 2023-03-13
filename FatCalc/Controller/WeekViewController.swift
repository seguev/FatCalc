//
//  WeekViewController.swift
//  FatCalc
//
//  Created by segev perets on 28/02/2023.
//

import UIKit
import AVFoundation

let weightUpdateNotification = Notification.Name("weightUpdate")
let fatUpdateNotification = Notification.Name("fatUpdate")

class WeekViewController: UIViewController , WeeklyWeightModelDelegate {
    @IBOutlet weak var fatCheckMark: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var weightCheckMark: UIButton!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var fatButton: UIButton!
    var infoLabel : UILabel?
    
    var player : AVAudioPlayer!
    
    let model = WeeklyWeightModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateTitleLabel()
        
        model.delegate = self
        
        observersSetup()
        
        model.checkIfEnoughForGraphUpdate()
        
        updateTodaysWeight()
        
        updateTodaysFat()
        
        setTimerForAnimation()
 
        
        
    }
    
    // MARK: - initial setup
    
    /**
     Shows the user that the button can be pressed.
     */
    private func setTimerForAnimation () {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [unowned self] timer in
            self.model.clickAnimation(self.weightButton)
            self.model.clickAnimation(self.fatButton)
            if weightButton.isHidden {timer.invalidate()}
        }
    }
    
    private func observersSetup () {
        NotificationCenter.default.addObserver(self, selector: #selector(saveNewWeight(_:)), name: weightUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fatUpdate(_:)), name: fatUpdateNotification, object: nil)
    }

    func updateTitleLabel () {
        let today = StorageModel.shared.currentDateComponents().today.rawValue
        todayLabel.text = today
     }

    // MARK: - today's weight setup

    
    /**
     Called from checkIfTodayIsDone()
     */
    private func updateProgressBar () {
        let entries  = Float(StorageModel.shared.weeklyData.weights.count)
        
        UIView.animate(withDuration: 1) {
            self.progressBar.progress = entries/4
        }
        
    }
    

    
    // MARK: - fat percentage setup
    
    private func updateTodaysWeight () {
        let today = StorageModel.shared.currentDateComponents().today.rawValue
        let todayIsDone = StorageModel.shared.weeklyData.weights.keys.contains(today)
        
        if todayIsDone {
            weightCheckMark.isHidden = false
            weightButton.isHidden = true

        } else {
            displayTodayButton()
        }
        updateProgressBar()
    }
    
    private func displayTodayButton () {
        weightButton.isHidden = false
        weightButton.layer.shadowColor = UIColor.black.cgColor
        weightButton.layer.shadowOffset = .init(width: 2, height: 2)
        weightButton.layer.shadowOpacity = 0.8
    }
    
    private func updateTodaysFat () {
        let gotUsersFatPer = StorageModel.shared.weeklyData.fatPercentage != nil
        
        if gotUsersFatPer {
            fatCheckMark.isHidden = false
            fatButton.isHidden = true
        } else {
            fatButton.layer.shadowColor = UIColor.black.cgColor
            fatButton.layer.shadowOffset = .init(width: 2, height: 2)
            fatButton.layer.shadowOpacity = 0.8
            
        }
    }
    

    
// MARK: - UI interactions

    @IBAction func fatButtonPressed(_ sender: UIButton) {
        let haptics = UIImpactFeedbackGenerator(style: .medium)
        haptics.prepare()
        haptics.impactOccurred(intensity: 0.8)
        model.clickAnimation(fatButton) {
            self.performSegue(withIdentifier: "toFat", sender: self)
        }
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton) {
        let haptics = UIImpactFeedbackGenerator(style: .medium)
        haptics.prepare()
        haptics.impactOccurred(intensity: 0.8)
        model.clickAnimation(weightButton) {
            self.performSegue(withIdentifier: "toWeight", sender: self)
        }
        
    }
    



    
    @IBAction func weightCheckmarkPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toWeight", sender: self)
    }
    
    @IBAction func fatCheckmarkPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toFat", sender: self)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toWeight" {
            let destinationVC = segue.destination as! WeightViewController
            destinationVC.title = model.today.rawValue
        } else if segue.identifier == "toFat" {
            //prepare fat segue if needed..
        }
    }
    
    // MARK: - notifications
    
    /**
     Being called when user sets weight .
     */
    @objc private func saveNewWeight (_ notification:Notification) {
        guard let newWeight = notification.object as? Float else {fatalError()}
        
        StorageModel.shared.save(weightEntry: (day: model.today.rawValue, weight: newWeight))
        model.checkIfEnoughForGraphUpdate()
        
        updateTodaysWeight()
        playCheckmarkSound()
    }

    @objc private func fatUpdate(_ notification:Notification) {
        let fatPercent = notification.object as! Float
        
        StorageModel.shared.save(fat: fatPercent)
        model.checkIfEnoughForGraphUpdate()

        updateTodaysFat()
        playCheckmarkSound()
    }
    
// MARK: - sound
    private func playCheckmarkSound () {
        let url = Bundle.main.url(forResource: "checkSound", withExtension: "wav")!
            player = try! AVAudioPlayer(contentsOf: url)
        player.volume = 0.05
            player.play()
    }

    // MARK: - info button
    @IBAction func infoPressed(_ sender: UIBarButtonItem) {
        infoLabel?.removeFromSuperview()
        let i = Info()
        infoLabel = i.showInfoLabel(view, text: i.weeklyWeightInfo)
    }
    
}

