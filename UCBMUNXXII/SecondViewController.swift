//
//  SecondViewController.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/8/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//

import UIKit


class AnnouncementCell: UICollectionViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
}

class SecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    let announcementsJsonURL = "https://ucbmun.herokuapp.com/announcements.json"
    var announcementsData: [String: [[String:String]]]? = nil
    

    
//    @IBOutlet weak var announcementsLabel: UILabel!
    @IBOutlet weak var ucbmunLabel: UILabel!
    @IBOutlet weak var contactInfo: UIButton!
    @IBOutlet weak var openMaps: UIButton!
    @IBOutlet weak var callUber: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var callUberLabel: UILabel!
    @IBOutlet weak var hotelLabel: UILabel!
    @IBOutlet weak var helpLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.dataSource = self
        collectionView.delegate = self
                
        self.view.backgroundColor = hexStringToUIColor(hex: "#ffffff")
        self.collectionView.backgroundColor = hexStringToUIColor(hex: "#ffffff")
        
        self.ucbmunLabel.textColor = hexStringToUIColor(hex: "#000000")
        self.callUberLabel.textColor = hexStringToUIColor(hex: "#000000")
        self.hotelLabel.textColor = hexStringToUIColor(hex: "#000000")
        self.helpLabel.textColor = hexStringToUIColor(hex: "#000000")
        self.websiteLabel.textColor = hexStringToUIColor(hex: "#000000")
//        self.announcementsLabel.textColor = hexStringToUIColor(hex: "#ffffff")
        
    
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        announcementsData = getJSON(urlToRequest: announcementsJsonURL) as? [String: [[String:String]]]
        collectionView.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected an item")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return announcementsData?["announcements"]?.count ?? 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AnnouncementCell = collectionView.dequeueReusableCell(withReuseIdentifier: "announcementCell", for: indexPath) as! AnnouncementCell
        cell.backgroundColor = hexStringToUIColor(hex: "#0C2C4A")
        let aTime = announcementsData?["announcements"]?[indexPath.row]["time"] ?? " "
        let aMessage = announcementsData?["announcements"]?[indexPath.row]["message"] ?? " "
        let aTitle = announcementsData?["announcements"]?[indexPath.row]["title"] ?? " "
        
        cell.messageLabel.text = aMessage
        cell.messageLabel.textColor = hexStringToUIColor(hex: "#ffffff")
        cell.titleLabel.text = aTitle
        cell.titleLabel.textColor = hexStringToUIColor(hex: "#ffffff")
        cell.timeLabel.text = aTime
        cell.timeLabel.textColor = hexStringToUIColor(hex: "#ffffff")
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    

    func getJSON(urlToRequest: String) -> Any?{
        guard let rawData = NSData(contentsOf: URL(string: urlToRequest)!) else {
            return ["announcements":[["time":"network error", "message": "network error", "title":"network error"]]]
        }
        do {
            if let json = try JSONSerialization.jsonObject(with: rawData as Data, options: []) as? [String: Any] {
                return json
            } else {
                // couldn't create an object from the JSON
                return ["announcements":[["time":"network error", "message": "network error", "title":"network error"]]]
            }
        } catch {
            // error trying to convert the data to JSON using JSONSerialization.jsonObject
            return ["announcements":[["time":"network error", "message": "network error", "title":"network error"]]]
        }
    }
    
    @IBAction func uberCall(_ sender: Any) {

        guard let url = URL(string: "https://m.uber.com/ul/?action=setPickup&client_id=GigC4PV4XM20G0UG94aP5UXkyDTV7Xc9&pickup=my_location&dropoff[formatted_address]=750%20Kearny%20St%2C%20San%20Francisco%2C%20CA%2094108%2C%20USA&dropoff[latitude]=37.795167&dropoff[longitude]=-122.404143") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func goToMaps(_ sender: Any) {
        let directionsURL = "http://maps.apple.com/?saddr=Current&daddr=37.7951599,-122.4063903"
        guard let url = URL(string: directionsURL) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func contactSG(_ sender: Any) {
        let alertController = UIAlertController(title: "Contact Secretariat", message: "secretarygeneral@ucbmun.org", preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction(title: "Close",
                                     style: .default,
                                     handler: nil) //You can use a block here to handle a press on this button
        
        alertController.addAction(actionOk)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func gotoWebsite(_ sender: Any) {
        guard let url = URL(string: "https://ucbmun.herokuapp.com/") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
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

