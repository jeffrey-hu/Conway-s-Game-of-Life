//
//  StandardEngine.swift
//  Assignment4
//
//  Created by Jeffrey Hu on 7/13/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import Foundation

class StandardEngine : EngineProtocol {
    //variables of class
    var IVCdelegate: InstrumentationViewController?
    var StatisticsVCdelegate: StatisticsViewController?
    var delegate: EngineDelegate?
    var refreshTimer: Timer?
    var refreshRate: Double = 0
    var timedRefresh: Bool = false
    var grid: GridProtocol {
        didSet {
            if let delegate = delegate {
                delegate.engineDidUpdate(engine: self)
            }
        }
    }
    
    var rows = 10 {
        didSet {
            if let SVCdelegate = StatisticsVCdelegate {
                SVCdelegate.gridSizeChanged()
            }
        }
    }
    var cols = 10 {
        didSet {
            if let SVCdelegate = StatisticsVCdelegate {
                SVCdelegate.gridSizeChanged()
            }
        }
    }
    
    //singleton
    static var shared : StandardEngine = {
        let tempShared = StandardEngine(10, 10)
        return tempShared
    }()
    
    internal required init (_ rows : Int , _ cols : Int) {
        self.rows = rows
        self.cols = cols
        self.grid = Grid(rows, cols)
        
    }
    
    func notify (){
        NotificationCenter.default.post(name: hello.notificationName,
                                        object: grid,
                                        userInfo: nil)
    }
    
    func step() -> GridProtocol {
        notify()
        return grid.next()
    }
}

//handles timer
extension StandardEngine {
    func startTimer(){
        if let _ = refreshTimer {
            return
        } else {
            refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshRate, repeats: true) {
                timer in
                self.grid = self.step()
                self.refreshTimer = timer
            }
        }
    }
    
    func stopTimer() {
        refreshTimer?.invalidate()
        refreshTimer = nil
        timedRefresh = false
        if let IVCdelegate = IVCdelegate {
            IVCdelegate.timerStopped(engine: self)
        }
    }
}

//stores names for notifications
struct hello {
    static let notificationName = NSNotification.Name("gridNotification")
    static let gridViewCoords = NSNotification.Name("gridViewCoords")
    
}
