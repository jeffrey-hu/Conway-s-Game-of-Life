//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Jeffrey Hu on 7/21/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

//communicates between the editorview and the tableview
protocol Tabledelegate {
    var thedata : [Dictionary<String, Any?>]? {get set}
    func getSpecificData (index: Int) -> [[Int]]?
    func getSpecificNames (index: Int) -> String?
    var specificdata : [[Int]]? {get set}
    var specificnames: String? {get set}
}


class GridEditorViewController: UIViewController {
    var delegate: GridTableViewController?
    var coordinates : [[Int]]?
    var gridTitle : String?
    var index : Int?
    @IBOutlet weak var gridview : GridView!
    @IBOutlet weak var gridLabel : UILabel!
    @IBOutlet weak var gridTextField : UITextField!
    
    //if the user presses the save button, notify listeners of the grid, and update Standard Engine grid
    @IBAction func save () {
        StandardEngine.shared.grid = gridview.grid
        StandardEngine.shared.cols = gridview.cols
        StandardEngine.shared.rows = gridview.rows
        if let gridTitle = gridTitle{
            delegate?.specificnames = gridTitle
        }
        updateCoordinates()
        notify()
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    func notify (){
        NotificationCenter.default.post(name: hello.gridViewCoords,
                                        object: CoordStruct(index: index, coordinates: coordinates),
                                        userInfo: nil)
    }
    
    func updateCoordinates() {
        if coordinates == nil {
            coordinates = [[0,0]]
            coordinates?.remove(at: 0)
        }
        let _ = (0..<StandardEngine.shared.rows).map{zip( [Int](repeating: $0, count: StandardEngine.shared.rows) , 0 ..< StandardEngine.shared.cols )}
            .flatMap{$0}
            .map{
                if gridview.grid[$0.0, $0.1] == .alive {
                    coordinates?.append([$0.0, $0.1])
                }
        }    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        gridTextField.text = delegate?.specificnames
        initializeCells()
        self.title = delegate?.specificnames
        // Do any additional setup after loading the view.
    }

    func initializeCells () {
        if let thedata = delegate?.specificdata {
            self.coordinates = thedata
            let x = setGridSize(coordinates: thedata)
            gridview.rows = x[0]
            gridview.cols = x[1]
            gridview.grid = Grid(x[0], x[1])
        }
        if let coordinates = coordinates {
            let _ = coordinates.map{gridview.grid[$0[0], $0[1]] = .alive}
        }
        gridview.setNeedsDisplay()
    }
    
    func setGridSize(coordinates: [[Int]]) -> [Int] {
        var maxRow = 0
        var maxCol = 0
        let _ = coordinates.map {
            maxRow = $0[0] > maxRow ? $0[0] : maxRow
            maxCol = $0[1] > maxCol ? $0[1] : maxCol
        }
//        for coordinate in coordinates {
//            maxRow = coordinate[0] > maxRow ? coordinate[0] : maxRow
//            maxCol = coordinate[1] > maxCol ? coordinate[1] : maxCol
//        }
        return[maxRow * 2, maxCol * 2]
    }

}

//handles the textfield
extension GridEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textString = textField.text{
            gridTitle = textString
            gridTextField.text = textString
        }
        textField.resignFirstResponder()
        return true
    }
}

//a struct that has index+coordinates which the notification ships out different instances of
struct CoordStruct {
    var index : Int?
    var coordinates : [[Int]]?
}



