//
//  bodyFatViewController.swift
//  FatCalc
//
//  Created by segev perets on 10/11/2022.
//

import UIKit
import Charts
/*
 1. read how to change xAxis values V
 2. figure out how to connect weight to fat% V
 3. delete left axis, you have values at each point anyway V
 4. find a way to connect graph touch to Entry info V
 5. update chart when data is being saved V
 6. add mendatory weight insertion when fat is calculated V
 7. present popup when pressed with entry's information
 8. add picture page
 9. swiping option, maybe not scroll view?
 10. add coreModel that shows privious position 
 
 */



class GraphViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoPopUp: UIView!
    
    var sets : [LineChartDataSet] = []
    var globalArray : [Entry] = []
    
    //init lineChartView
    var lineChartView = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Funcs.shared.addGradient(view: self.view)
        lineChartView.delegate = self
        chartSetup()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //get current name from shared func
        let currentControllerName = Funcs.shared.fetchNameFromCurrent(self)
        //title = currentControllerName
        print("current controller is \(currentControllerName)")
        
        
        fetchAllEntries()

        
    }

    private func chartSetup () {
        lineChartView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height*0.8)
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.leftAxis.labelPosition = .outsideChart
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.dragEnabled = false
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 12)
        lineChartView.center = view.center
        lineChartView.leftAxis.axisLineColor = .black
        lineChartView.rightAxis.axisLineColor = .black
        lineChartView.leftAxis.drawLabelsEnabled = false
        
        view.addSubview(lineChartView) //add chart to view
        
        
        
    }
    func reloadData () {
        
    }
    
    func fetchAllEntries() {
        sets = []
        globalArray = []

        var weightEntriesArray : [ChartDataEntry] = []
        var fatEntriesArray : [ChartDataEntry] = []

        //create safe loaded data if exist
        if let loadedData = Funcs.shared.loadFromCoreData() {

        //add data from coreData to global array for us to fetch later if needed
        globalArray.append(contentsOf: loadedData )
            
            //set starting index
            var entryIndex : Double = 0.0
            
            //for each entry, seperate fat and weight for ChartDataSets
            for entry in globalArray {
                let fat = Double(entry.fatPercentage)
                let weight = Double(entry.weight)
                entryIndex += 1
                
                //set weightEntry
                let weightChartEntry = ChartDataEntry(x: entryIndex, y: weight)
                weightEntriesArray.append(weightChartEntry) //add to local array
                
                //set fatEntry
                let fatChartEntry = ChartDataEntry(x: entryIndex, y: fat)
                fatEntriesArray.append(fatChartEntry) //add to local array
                //export to local array
            }
            //fetch from local array after beings set
            let weightSet = LineChartDataSet(entries: weightEntriesArray, label: "weight")
            let fatSet = LineChartDataSet(entries: fatEntriesArray, label: "fat%")
            
            //go to next func and setup each line
            setData(weightSet, set2: fatSet)
            
        } else {
            print("Could not load from core data")
        }
    }
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let index = Int(entry.x)
        let selectedEntry = globalArray[index - 1]
        print("""
            weight: \(selectedEntry.weight)
            fat: \(selectedEntry.fatPercentage)
            date: \(selectedEntry.date ?? "no date")
            """)
    }
   
    //2. set data to chart
    private func setData (_ set1:LineChartDataSet,set2:LineChartDataSet) {
        //add chart data to a new set everytime func is called
        
        
        //set the set's attributes
        set1.mode = .linear //line style
        set1.circleHoleRadius = 0.02 //circle radius
        set1.drawFilledEnabled = true //add fill
        set1.fillColor = .green //fill color
        set1.fillAlpha = 0.4 //fill alpha
        
        sets.append(set1) //add to global setsArray, so we can pass several sets to data
        
        //set the set's attributes
        set2.mode = .linear //line style
        set2.circleHoleRadius = 0.02 //circle radius
        set2.drawFilledEnabled = true //add fill
        set2.fillColor = .cyan //fill color
        set2.fillAlpha = 0.4 //fill alpha
        
        sets.append(set2) //add to global setsArray, so we can pass several sets to data
        
        
        //make data from global setsArray
        let newData = LineChartData(dataSets: sets)
        
        //attach data to chart
        lineChartView.data = newData
    
    }
    
    
    
}

