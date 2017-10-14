//
//  GridTableViewController.swift
//  FinalProject
//
//  Created by Jeffrey Hu on 7/20/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class GridTableViewController: UITableViewController, Tabledelegate {
    
    var thedata : [Dictionary<String, Any?>]?
    //coordinates that the editorview is about to handle
    var specificdata : [[Int]]?
    //the name of the data that the editorview is about to handle
    var specificnames: String? {
        didSet {
            if let specificnames = specificnames {
                if let currentindex = currentindex{
                    thedata?[currentindex].removeValue(forKey: "title")
                    thedata?[currentindex]["title"] = specificnames
                    tableView.reloadData()
                }
            }
        }
    }
    //index of the data/name within the tableview that the editorview is about to handle
    var currentindex: Int?
    
    func getSpecificData (index: Int) -> [[Int]]? {
        if let data = thedata?[index]["contents"] as? [[Int]]{
            return data
        } else {return nil}
    }
    
    func getSpecificNames (index: Int) -> String? {
        if let name = thedata?[index]["title"] as? String{
            return name
        } else {return nil}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupListener()
        if let gridURL = URL(string: "https:dl.dropboxusercontent.com/u/7544475/S65g.json") {
            let dataTask = URLSession.shared.dataTask(with: gridURL)
            {   (data, response, error) in
                
                if let error = error {
                    print("ERROR ERROR ERROR \(error)")
                } else {
                    if let data = data {
                        self.thedata = self.convertData(from: data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } else {
                        print("The call didn't work")
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func add() {
        thedata?.append(["title" : "new item", "contents" : nil])
        tableView.reloadData()
        if let thedata = thedata {
            let indexPath = IndexPath(item: thedata.count - 1, section: 0)
            tableView.selectRow(at:indexPath, animated: false, scrollPosition: .middle)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? GridEditorViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.delegate = self
                currentindex = indexPath.row
                destination.index = currentindex
                specificdata = getSpecificData(index: indexPath.row)
                specificnames = getSpecificNames(index: indexPath.row)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            thedata?.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

//handles the tableView
extension GridTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let thedata = thedata {
            return thedata.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gridcell", for: indexPath)
        if let thedata = thedata {
            cell.textLabel?.text = thedata[indexPath.row]["title"] as? String
            return cell
        } else {
            return UITableViewCell.init()
        }
    }
    
}

//handles JSON
extension GridTableViewController {
    func convertData(from data: Data) -> [Dictionary<String, Any>]? {
        let jsonObject: Any
        do {
            jsonObject = try JSONSerialization.jsonObject(with: data,
                                                          options: .allowFragments)
        } catch {
            print("JSON Parsing failure: \(error)")
            return nil
        }
        // NOTE: The signatures of the two functions are *almost* identical.
        if let returnObject = jsonObject as? Array<Dictionary<String, Any>> {
            return returnObject
        } else {
            return nil
        }
    }
}

//handles notifications-whenever user saves in editorview, copy data back to the table
extension GridTableViewController {
    func setupListener() {
        let notificationSelector = #selector(notified(notification:))
        NotificationCenter.default.addObserver(self,
                                               selector: notificationSelector,
                                               name: hello.gridViewCoords,
                                               object: nil)
    }
    
    func notified(notification: Notification) {
        guard let coordstruct = notification.object as? CoordStruct else {
            return
        }
        if let coordinates = coordstruct.coordinates,
            let index = coordstruct.index {
            thedata?[index]["contents"] = coordinates
            tableView.reloadData()
        }
        
        
            
    }
}


