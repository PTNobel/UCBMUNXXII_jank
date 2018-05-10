//
//  StoreViewController.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/9/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//

import Foundation
import UIKit

class storeCell: UITableViewCell {
    @IBOutlet weak var imageStore: UIImageView!
    
    @IBOutlet weak var descriptionStore: UILabel!
    @IBOutlet weak var itemStore: UILabel!
}

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var storeTableView: UITableView!
    
    let storeJsonURL = "https://ucbmun.herokuapp.com/store.json"
    var storeData : [String: [[String:String]]]? = nil
    
    @IBOutlet weak var muntitlelabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.storeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.storeTableView.delegate = self
        self.storeTableView.dataSource = self
//        muntitlelabel.textColor = hexStringToUIColor(hex: "#0C2C4A")
        if storeData == nil {
            storeData = getJSON(urlToRequest: storeJsonURL) as? [String: [[String:String]]]
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected a row")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:storeCell = self.storeTableView.dequeueReusableCell(withIdentifier: "storeCell") as! storeCell
        let title = storeData?["store"]?[indexPath.row]["title"] ?? "-"
        let price = storeData?["store"]?[indexPath.row]["price"] ?? "-"
        let image = storeData?["store"]?[indexPath.row]["image"] ?? "candy"
        cell.itemStore.text = title + "\n" + price
        cell.descriptionStore.text = storeData?["store"]?[indexPath.row]["message"] ?? ":"
        cell.itemStore.textColor = hexStringToUIColor(hex: "#0C2C4A")
        cell.descriptionStore.textColor = hexStringToUIColor(hex: "#0C2C4A")
        cell.imageStore.image = UIImage(named: image)
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = hexStringToUIColor(hex: "#0C2C4A")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeData?["store"]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150.0)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "3rd Floor"
    }
    
    func getJSON(urlToRequest: String) -> Any?{
        guard let rawData = NSData(contentsOf: URL(string: urlToRequest)!) else {
            var resource = "store"
            if let path = Bundle.main.path(forResource: resource, ofType: "json")
            {
                if let jsonData = NSData(contentsOfFile: path)
                {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: []) as? [String: Any] {
                            return json
                        } else {
                            // couldn't create an object from the JSON
                            return nil
                        }
                    } catch {
                        // error trying to convert the data to JSON using JSONSerialization.jsonObject
                        return nil
                    }
                    
                }
            }
            return nil
        }
        do {
            if let json = try JSONSerialization.jsonObject(with: rawData as Data, options: []) as? [String: Any] {
                return json
            } else {
                // couldn't create an object from the JSON
                return nil
            }
        } catch {
            // error trying to convert the data to JSON using JSONSerialization.jsonObject
            return nil
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
