//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Jeffrey Hu on 7/11/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var aliveLabel : UILabel!
    @IBOutlet weak var diedLabel : UILabel!
    @IBOutlet weak var emptyLabel : UILabel!
    @IBOutlet weak var bornLabel : UILabel!
    @IBOutlet weak var resetButton : UIButton!
    
    var alivecounter = 0
    var diedcounter = 0
    var emptycounter = 100
    var borncounter = 0
    
    @IBAction func resetButtonPressed(sender: UIButton){
        resetCountersAndLabels()
    }
    
    //whenever StandardEngine rows or cols gets changed
    func gridSizeChanged() {
        resetCountersAndLabels()
    }
    
    func resetCountersAndLabels() {
        alivecounter = 0
        diedcounter = 0
        emptycounter = StandardEngine.shared.cols * StandardEngine.shared.rows
        borncounter = 0
        aliveLabel.text = "\(alivecounter)"
        diedLabel.text = "\(diedcounter)"
        emptyLabel.text = "\(emptycounter)"
        bornLabel.text = "\(borncounter)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupListener()
        StandardEngine.shared.StatisticsVCdelegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        aliveLabel.text = "\(alivecounter)"
        diedLabel.text = "\(diedcounter)"
        emptyLabel.text = "\(emptycounter)"
        bornLabel.text = "\(borncounter)"
    }
    
}

//handles notifications-whenever simulation gridview steps
extension StatisticsViewController {
    func setupListener() {
        let notificationSelector = #selector(notified(notification:))
        NotificationCenter.default.addObserver(self,
                                               selector: notificationSelector,
                                               name: hello.notificationName,
                                               object: nil)
    }
    
    func notified(notification: Notification) {
        guard let thegrid = notification.object as? Grid else{
            return
        }
        for row in 0..<thegrid.size.cols {
            for cell in 0..<thegrid.size.rows {
                alivecounter += thegrid[row, cell] == .alive ? 1 : 0
                diedcounter += thegrid[row, cell] == .died ? 1 : 0
                emptycounter += thegrid[row, cell] == .empty ? 1 : 0
                borncounter += thegrid[row, cell] == .born ? 1 : 0
            }
        }
    }
}
