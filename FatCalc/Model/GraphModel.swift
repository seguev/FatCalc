//
//  GraphModel.swift
//  FatCalc
//
//  Created by segev perets on 28/11/2022.
// https://weeklycoding.com/mpandroidchart-documentation/

import Foundation
import Charts
import UIKit
import CoreData

struct GraphModel {
    
    var sets : [LineChartDataSet] = []
    var globalArray : [Entry] = []
    
    func fetchMaxWeight () -> Double {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let predicate = NSPredicate(format: "weight LIKE %@", "*")
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.predicate = predicate
        var weightDoubles : [Double] = []
        do {
            let weights = try context.fetch(request)
            for weight in weights {
                weightDoubles.append(Double(weight.weight))
            }
            guard let maxResult = weightDoubles.max() else {
                print(#function+"FAILED")
                return 0.0
            }
            return maxResult
        } catch {
            print(error)
        }
        print(#function+"FAILED")
        return 0.0
    }
    
    /**
     chart setup
     */
    func chartSetup (_ view:UIView, chart:LineChartView) {
        chart.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height*0.8)
        chart.rightAxis.enabled = false
        chart.xAxis.labelPosition = .bottom
        chart.leftAxis.labelPosition = .outsideChart
        chart.doubleTapToZoomEnabled = false
        chart.pinchZoomEnabled = false
        chart.dragEnabled = false
        chart.leftAxis.axisMaximum = fetchMaxWeight() * 1.3 //set graph flexible height
        chart.leftAxis.axisMinimum = 5
        chart.xAxis.labelFont = .systemFont(ofSize: 12)
        chart.center = view.center
        chart.leftAxis.enabled = false
        chart.xAxis.enabled = false
        chart.leftAxis.axisLineColor = .black
        chart.rightAxis.axisLineColor = .black
        chart.leftAxis.drawLabelsEnabled = false
        chart.drawMarkers = false
        chart.drawGridBackgroundEnabled = false
        chart.scaleYEnabled = false
        chart.scaleXEnabled = false
        view.addSubview(chart) //add chart to view
        
        
    }
    
    /**
     adds data to chartview
     - delete previous ChartData to prevent ovelap
     - load all available data from coreData
     - creates weight (line)set and fatPersentage (line)set
     - add set as a data set to chart
     - calls setData() that sets each line properties
     */
    mutating func fetchAllEntries(to chart:LineChartView) {
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
            setData(weightSet, set2: fatSet,chart: chart)
            
        } else {
            print("Could not load from core data")
        }
    }
    
    
    
    
    //2. being called from fechAllEntries()
    private mutating func setData (_ set1:LineChartDataSet,set2:LineChartDataSet ,chart:LineChartView) {
        //add chart data to a new set everytime func is called
        
        
        //set the set's attributes
        set1.mode = .linear //line style
        set1.circleHoleRadius = 0.02 //circle radius
        set1.drawFilledEnabled = true //add fill
        set1.fillColor = .systemGreen
        set1.colors = [NSUIColor.systemGreen]
        set1.fillAlpha = 0.4 //fill alpha


        sets.append(set1) //add to global setsArray, so we can pass several sets to data
        
        //set the set's attributes
        set2.mode = .linear //line style
        set2.circleHoleRadius = 0.02 //circle radius
        set2.drawFilledEnabled = true //add fill
        set2.fillColor = .systemBlue
        set2.colors = [NSUIColor.blue]
        set2.fillAlpha = 0.4 //fill alpha
        sets.append(set2) //add to global setsArray, so we can pass several sets to data
        
        
        //make data from global setsArray
        let newData = LineChartData(dataSets: sets)
        
        //attach data to chart
        chart.data = newData
        
    }
    
    
    
    func createInfoLabel (for seconds: Int, x:Double, y:Double, text:String, view:UIView) {
        let origin = CGPoint(x: x, y: y-20)
        let temporaryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 80))
        temporaryLabel.center = origin
        temporaryLabel.backgroundColor = .black
        temporaryLabel.textColor = .white
        temporaryLabel.alpha = 0.8
        temporaryLabel.numberOfLines = 0
        temporaryLabel.text = text
        temporaryLabel.textAlignment = .center
        temporaryLabel.layer.cornerRadius = 10
        temporaryLabel.clipsToBounds = true
        
        view.addSubview(temporaryLabel)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            temporaryLabel.removeFromSuperview()
        }
        
        //prevent label from going off screen
       let labelLeftCorner = temporaryLabel.frame.origin.x
        let labelWidth = temporaryLabel.frame.width
        let screenWidth = view.frame.width
        
        if labelLeftCorner < 0 { //if label is off screen
            print("off screen! (left)")      //make it's x origin 0 + 5 (fit screen + padding)
            let origin = CGPoint(x: 0+5, y: temporaryLabel.frame.minY)
            temporaryLabel.frame = CGRect(origin: origin, size: temporaryLabel.frame.size)
            
        } else if labelLeftCorner+labelWidth > screenWidth {
            print("off screen! (right)") //if label is off screen, send it left with 5px padding
            let origin = CGPoint(x: screenWidth-(labelWidth)-5, y: temporaryLabel.frame.minY)
            temporaryLabel.frame = CGRect(origin: origin, size: temporaryLabel.frame.size)
            
        } else {
            print("label fit's screen")
        }
        
        
    }
    
}
