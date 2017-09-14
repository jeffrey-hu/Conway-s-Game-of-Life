//
//  EngineProtocol.swift
//  Assignment4
//
//  Created by Jeffrey Hu on 7/12/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import Foundation

protocol EngineProtocol {
    var delegate: EngineDelegate? {get set}
    var grid: GridProtocol {get}
    var refreshTimer: Timer? {get set}
    var rows : Int {get set}
    var cols : Int {get set}
    init (_ rows : Int , _ cols : Int)
    func step() -> GridProtocol
    
    
}

extension EngineProtocol {
    var refreshRate: Double {
        get {
            return 0
        } set {
            refreshRate = newValue
        }
    }
}
