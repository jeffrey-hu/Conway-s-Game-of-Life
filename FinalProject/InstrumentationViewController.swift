//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Jeffrey Hu on 7/11/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {
    
    @IBOutlet weak var TimedRefreshSwitch : UISwitch!
    @IBOutlet weak var TimedRefreshLabel : UILabel!
    @IBOutlet weak var RefreshFrequencyLabel : UILabel!
    @IBOutlet weak var ColLabel : UILabel!
    @IBOutlet weak var RowLabel : UILabel!
    @IBOutlet weak var RowText: UITextField!
    @IBOutlet weak var ColText : UITextField!
    @IBOutlet weak var colStepper : UIStepper!
    @IBOutlet weak var rowStepper : UIStepper!
    var rows = 10
    var cols = 10
    
    @IBAction func colStepperChanged(sender: UIStepper) {
        if (cols + Int(sender.value) < 0) {
            colStepper.value = 0
            return
        }
        cols = cols + Int(sender.value)
        ColLabel.text = "cols: \(Int(cols))"
        StandardEngine.shared.rows = cols
        StandardEngine.shared.grid = Grid(cols, StandardEngine.shared.cols)
        colStepper.value = 0
    }
    
    @IBAction func rowStepperChanged(sender: UIStepper) {
        if (rows + Int(sender.value) < 0) {
            rowStepper.value = 0
            return
        }
        rows = rows + Int(sender.value)
        RowLabel.text = "rows: \(Int(rows))"
        StandardEngine.shared.cols = rows
        StandardEngine.shared.grid = Grid(StandardEngine.shared.rows, rows)
        rowStepper.value = 0
    }
    
    @IBAction func switchToggled(sender: UISwitch){
        let onOrOff = sender.isOn ? "On" : "Off"
        TimedRefreshLabel.text = "Timed Refresh: \(onOrOff)"
        StandardEngine.shared.timedRefresh = sender.isOn ? true : false
        if StandardEngine.shared.timedRefresh == false {
            StandardEngine.shared.stopTimer()
        }
    }
    
    @IBAction func sliderMoved(sender: UISlider){
        //rounds the input to the tenths place
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        StandardEngine.shared.refreshRate = Double(sender.value)
        RefreshFrequencyLabel.text = "Refresh Frequency: " + formatter.string(from: NSNumber(value: sender.value))!
    }
    
    func timerStopped (engine: EngineProtocol) {
        TimedRefreshSwitch.setOn(false , animated: false)
        TimedRefreshLabel.text = "Timed Refresh: Off"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        colStepper.value = 0
        rowStepper.value = 0
        ColLabel.text = "cols: \(Int(cols))"
        RowLabel.text = "rows: \(Int(rows))"
        StandardEngine.shared.IVCdelegate = self
    }
    
    @IBAction func add(_ sender: Any) {
        let viewControllers = self.childViewControllers
        if let vc = viewControllers[0] as? GridTableViewController {
            vc.add()
        }
    }
}

//handles the textfield
extension InstrumentationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ColText {
            if let textString = textField.text,
                let validInt = Int(textString){
                if (Int(validInt) < 0) {
                    colStepper.value = 0
                    print("Please enter a non-negative number")
                    textField.resignFirstResponder()
                    return true
                }
                cols = validInt
                colStepper.value = 0
                ColLabel.text = "cols: \(validInt)"
                StandardEngine.shared.rows = validInt
                StandardEngine.shared.grid = Grid(validInt, StandardEngine.shared.cols)
            } else {
                textField.text = " "
            }
        }
        
        if textField == RowText {
            if let textString = textField.text,
                let validInt = Int(textString){
                if (Int(validInt) < 0) {
                    rowStepper.value = 0
                    print("Please enter a non-negative number")
                    textField.resignFirstResponder()
                    return true
                }
                rowStepper.value = 0
                rows = validInt
                RowLabel.text = "rows: \(validInt)"
                StandardEngine.shared.cols = validInt
                StandardEngine.shared.grid = Grid(StandardEngine.shared.rows, validInt)
            } else {
                textField.text = ""
            }
        }
        textField.resignFirstResponder()
        return true
    }
}
