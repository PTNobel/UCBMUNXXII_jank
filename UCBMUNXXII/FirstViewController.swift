//
//  FirstViewController.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/8/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//

import UIKit


class eventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
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

class funTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var optionControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var displayData = ["one","two","three"]
    
    let scheduleJsonURL = "https://ucbmun.herokuapp.com/schedule.json"
    let committeeJsonURL = "https://ucbmun.herokuapp.com/committee.json"
    let eventsJsonURL = "https://ucbmun.herokuapp.com/events.json"
    var currentState = 0 //0=schedule, 1=committee, 2=events
    var scheduleData: [String: [[String:String]]]? = nil
    var committeData: [String: [[String:String]]]? = nil
    var funData: [String: [[String:String]]]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "committeeCell")
        optionControl.setTitle("Schedule", forSegmentAt: 0)
        optionControl.setTitle("Committees", forSegmentAt: 1);
        optionControl.setTitle("Events", forSegmentAt: 2);
        
        self.view.backgroundColor = hexStringToUIColor(hex: "#ffffff")
        self.tableView.backgroundColor = UIColor.clear
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        scheduleData = getJSON(urlToRequest: scheduleJsonURL) as? [String: [[String:String]]]
        
        committeData = getJSON(urlToRequest: committeeJsonURL) as? [String: [[String:String]]]
        
        funData = getJSON(urlToRequest: eventsJsonURL) as? [String: [[String:String]]]
        tableView.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentState == 2 {
            return CGFloat(150.0)
        }
        return CGFloat(55.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected a row")
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = hexStringToUIColor(hex: "#0C2C4A")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(currentState == 0){
            let cell: eventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath as IndexPath) as! eventTableViewCell
            cell.eventNameLabel.textColor = hexStringToUIColor(hex: "#0C2C4A")
            cell.timeLabel.textColor = hexStringToUIColor(hex: "#0C2C4A")
            
            switch indexPath.section{
            case 0:
                let eventName = scheduleData?["thursday"]?[indexPath.row]["name"] ?? " "
                var eventTime = scheduleData?["thursday"]?[indexPath.row]["time"] ?? " "
                eventTime = eventTime.replacingOccurrences(of: " - ", with: "\n")
                cell.eventNameLabel.text = eventName
                cell.timeLabel.text = eventTime
            case 1:
                let eventName = scheduleData?["friday"]?[indexPath.row]["name"] ?? " "
                var eventTime = scheduleData?["friday"]?[indexPath.row]["time"] ?? " "
                eventTime = eventTime.replacingOccurrences(of: " - ", with: "\n")
                cell.eventNameLabel.text = eventName
                cell.timeLabel.text = eventTime
            case 2:
                let eventName = scheduleData?["saturday"]?[indexPath.row]["name"] ?? " "
                var eventTime = scheduleData?["saturday"]?[indexPath.row]["time"] ?? " "
                eventTime = eventTime.replacingOccurrences(of: " - ", with: "\n")
                cell.eventNameLabel.text = eventName
                cell.timeLabel.text = eventTime
            case 3:
                let eventName = scheduleData?["sunday"]?[indexPath.row]["name"] ?? " "
                var eventTime = scheduleData?["sunday"]?[indexPath.row]["time"] ?? " "
                eventTime = eventTime.replacingOccurrences(of: " - ", with: "\n")
                cell.eventNameLabel.text = eventName
                cell.timeLabel.text = eventTime
            default:
                cell.eventNameLabel.text = "error"
            }
            return cell
        }
        else if (currentState == 1){
            let reuseIdentifier = "committeeCell"
            var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as UITableViewCell?
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
            cell?.textLabel?.textColor = hexStringToUIColor(hex: "#0C2C4A")
            cell?.detailTextLabel?.textColor = hexStringToUIColor(hex: "#0C2C4A")
            switch indexPath.section{
            case 0:
                let committeeName = committeData?["GA"]?[indexPath.row]["name"] ?? " "
                let committeeLocation = committeData?["GA"]?[indexPath.row]["location"] ?? " "
                cell?.textLabel?.text = committeeName
                cell?.detailTextLabel?.text = committeeLocation
            case 1:
                let committeeName = committeData?["Crisis"]?[indexPath.row]["name"] ?? " "
                let committeeLocation = committeData?["Crisis"]?[indexPath.row]["location"] ?? " "
                cell?.textLabel?.text = committeeName
                cell?.detailTextLabel?.text = committeeLocation
            case 2:
                let committeeName = committeData?["JCC"]?[indexPath.row]["name"] ?? " "
                let committeeLocation = committeData?["JCC"]?[indexPath.row]["location"] ?? " "
                cell?.textLabel?.text = committeeName
                cell?.detailTextLabel?.text = committeeLocation
            default:
                cell?.textLabel?.text = "ERROR"
            }
            return cell!
        }
        else {
            let cell: funTableViewCell = tableView.dequeueReusableCell(withIdentifier: "funCell", for: indexPath as IndexPath) as! funTableViewCell
            cell.titleLabel.textColor = hexStringToUIColor(hex: "#0C2C4A")
            cell.timeLabel.textColor = hexStringToUIColor(hex: "#0C2C4A")
            cell.locationLabel.textColor = hexStringToUIColor(hex: "#0C2C4A")
            cell.messageLabel.textColor = hexStringToUIColor(hex: "#0C2C4A")
            
            switch indexPath.section{
            case 0:
                let eventName = funData?["events"]?[indexPath.row]["title"] ?? " "
                var eventTime = funData?["events"]?[indexPath.row]["time"] ?? " "
                var eventMessage = funData?["events"]?[indexPath.row]["message"] ?? " "
                var eventLocation = funData?["events"]?[indexPath.row]["location"] ?? " "
                cell.titleLabel.text = eventName
                cell.timeLabel.text = eventTime
                cell.messageLabel.text = eventMessage
                cell.locationLabel.text = eventLocation
            default:
                cell.titleLabel.text = "error"
            }
            return cell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(currentState == 0){
            switch section{
            case 0:
                return scheduleData?["thursday"]?.count ?? 0
            case 1:
                return scheduleData?["friday"]?.count ?? 0
            case 2:
                return scheduleData?["saturday"]?.count ?? 0
            case 3:
                return scheduleData?["sunday"]?.count ?? 0
            default:
                return 0
            }
        }
        if(currentState == 1){
            switch section{
            case 0:
                return committeData?["GA"]?.count ?? 0
            case 1:
                return committeData?["Crisis"]?.count ?? 0
            case 2:
                return committeData?["JCC"]?.count ?? 0
            default:
                return 0
            }
        }
        if (currentState == 2) {
            return 4
        }
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        switch currentState{
        case 0:
            return 4
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(currentState == 0){
            switch section{
            case 0:
                return "Thursday"
            case 1:
                return "Friday"
            case 2:
                return "Saturday"
            case 3:
                return "Sunday"
            default:
                return "error"
            }
        }
        if(currentState == 1){
            switch section{
            case 0:
                return "GA"
            case 1:
                return "Crisis"
            case 2:
                return "JCC"
            default:
                return "error"
            }
        }
        if (currentState == 2){
            return "Events"
        }
        return "section"
    }
    func getJSON(urlToRequest: String) -> Any?{
        guard let rawData = NSData(contentsOf: URL(string: urlToRequest)!) else {
            var resource = ""
            if urlToRequest == eventsJsonURL {
                resource = "events"
            }
            if urlToRequest == scheduleJsonURL {
                resource = "schedule"
            }
            if urlToRequest == committeeJsonURL {
                resource = "committee"
            }
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
    

    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        switch optionControl.selectedSegmentIndex {
        case 0:
            if scheduleData == nil {
                scheduleData = getJSON(urlToRequest: scheduleJsonURL) as? [String: [[String:String]]]
            }
            currentState = 0
            tableView.reloadData()
        case 1:
            if committeData == nil {
                committeData = getJSON(urlToRequest: committeeJsonURL) as? [String: [[String:String]]]
            }
            currentState = 1
            tableView.reloadData()
        case 2:
            if funData == nil {
                funData = getJSON(urlToRequest: eventsJsonURL) as? [String: [[String:String]]]
            }
            currentState = 2
            tableView.reloadData()
        default:
            displayData = ["a","b","c"]
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

