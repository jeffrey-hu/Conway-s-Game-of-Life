//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Jeffrey Hu on 7/11/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate {
    
    @IBOutlet weak var stepbutton : UIButton!
    @IBOutlet weak var gridview : GridView!
    
    @IBAction func clearButtonPressed(sender: UIButton) {
        for row in 0..<gridview.grid.size.rows {
            for cell in 0..<gridview.grid.size.cols {
                StandardEngine.shared.grid[row, cell] = .empty
            }
        }
        StandardEngine.shared.stopTimer()
        gridview.setNeedsDisplay()
    }
    
    @IBAction func stepbuttonpressed(sender: UIButton) {
        StandardEngine.shared.grid = StandardEngine.shared.step()
        if StandardEngine.shared.timedRefresh {
            StandardEngine.shared.startTimer()
        }
    }
    
    //whenever the StandardEngine grid is changed, update gridview
    func engineDidUpdate(engine: EngineProtocol) {
        gridview.grid = engine.grid
        gridview.cols = engine.cols
        gridview.rows = engine.rows
        gridview.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StandardEngine.shared.delegate = self
        setupListener()
        addPanHandler()
    }
    
    //updates gridview with what is currently standard engine grid
    override func viewWillAppear(_ animated: Bool) {
        gridview.grid = StandardEngine.shared.grid
        gridview.cols = StandardEngine.shared.cols
        gridview.rows = StandardEngine.shared.rows
        gridview.setNeedsDisplay()
    }
    
}



//handles notification that takes data from GridEditorView when it gets saved, and copies it to the simulation gridview
extension SimulationViewController {
    func setupListener() {
        let notificationSelector = #selector(notified(notification:))
        NotificationCenter.default.addObserver(self,
                                               selector: notificationSelector,
                                               name: hello.gridViewCoords,
                                               object: nil)
    }
    
    func notified(notification: Notification) {
        guard let thegrid = notification.object as? Grid else{
            return
        }
        StandardEngine.shared.grid = thegrid
    }
}

//handles gestures
extension SimulationViewController {
    func addPanHandler() {
        print("added panhandler")
        let handler = #selector(gridview.touching(panRecognizer:))
        let panRecognizer = UIPanGestureRecognizer(target: self.gridview, action: handler)
        panRecognizer.maximumNumberOfTouches = 1
        gridview.addGestureRecognizer(panRecognizer)
    }
}

