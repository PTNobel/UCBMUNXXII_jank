//
//  NewPostViewController.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/16/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var addPicture: UIButton!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var previewPicture: UIImageView!
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()

//        var user = User(uid: "FakeId", email: "hungry@person.food")
        super.viewDidLoad()
        self.postText!.layer.borderColor = hexStringToUIColor(hex: "#0C2C4A").cgColor
        self.postText!.layer.borderWidth = CGFloat(2.0)
//        let alert = UIAlertController(title: "Grocery Item",
//                                      message: "Add an Item",
//                                      preferredStyle: .alert)
//        let ref = Database.database().reference()
//
//        let saveAction = UIAlertAction(title: "Save",
//                                       style: .default) { _ in
//                                        // 1
//                                        guard let textField = alert.textFields?.first,
//                                            let text = textField.text else { return }
//
//                                        let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000) //Will give you a unique id every second or even millisecond if you want..
//
//                                        // 2
//                                        let groceryItem = Post(key: String(timeStamp), text: "NEW POST", author: user.email, votes: 0)
//                                        // 3
//                                        let groceryItemRef = ref.child(String(timeStamp))
//
//                                        // 4
//                                        groceryItemRef.setValue(groceryItem.toAnyObject())
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .default)
//
//        alert.addTextField()
//
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func postNewJoke(_ sender: Any) {
        let ref = Database.database().reference()
        let text = postText.text ?? "no text"
        let timeStamp = Int(NSDate.timeIntervalSinceReferenceDate*1000) //Will give you a unique id every second or even millisecond if you want..
        var username = Auth.auth().currentUser?.email ?? "vishal@ucbmun.xxii"
        let endIndex = username.index(username.endIndex, offsetBy: -12)
        username = String(username[..<endIndex])
        // 2
        let newpost = Post(key: String(timeStamp), text: text, author: username, votes: 0)
        // 3
        let postitemref = ref.child(String(timeStamp))
        
        // 4
        postitemref.setValue(newpost.toAnyObject())
        performSegue(withIdentifier: "cancelPost", sender: nil)

    }
    
    @IBAction func saveJoke(sender: AnyObject) {
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        
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
