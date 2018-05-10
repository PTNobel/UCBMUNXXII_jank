//
//  PostFeedViewController.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/16/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//

import Foundation

import UIKit
import Firebase

class postContentCell:  UITableViewCell {
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var numberOfVotes: UILabel!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postTime: UILabel!
    
    
    weak var delegate: postCellDelegate?
    
    @IBAction func upvotePressed(_ sender: UIButton) {
        print("AM HERE")
        delegate?.upvotePressed(self)
    }
    
    @IBAction func downvotePressed(_ sender: UIButton) {
        print("AMTHERE")
        delegate?.downvotePressed(self)
    }

}

protocol postCellDelegate : class {
    func upvotePressed(_ sender: postContentCell)
    func downvotePressed(_ sender: postContentCell)
}

class PostFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, postCellDelegate {
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var feedTableView: UITableView!
    var items:[Post]?
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()

        super.viewDidLoad()
        segmentControl.setTitle("Popular", forSegmentAt: 0)
        segmentControl.setTitle("Recent", forSegmentAt: 1);
        // 1
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
//        self.feedTableView.separatorColor = hexStringToUIColor(hex: "#0C2C4A")
        let ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            // 2
            var newItems: [Post] = []

            // 3
            for item in snapshot.children {
                // 4
                let post = Post(snapshot: item as! DataSnapshot)
                newItems.append(post)
            }

            // 5
            self.items = newItems

            if self.segmentControl.selectedSegmentIndex == 1 {
                self.items = self.items?.sorted(by: { $0.postKey > $1.postKey })
            } else{
                self.items = self.items?.sorted(by: { $0.postVotes > $1.postVotes })
            }
            self.feedTableView.reloadData()
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func upvotePressed(_ sender: postContentCell) {
        guard let tappedIndexPath = feedTableView.indexPath(for: sender) else { return }
        print("Heart", sender, tappedIndexPath)
        
        
        var numVotes = self.items?[tappedIndexPath.row].postVotes ?? 0
        numVotes = numVotes + 1
        let key = self.items?[tappedIndexPath.row].postKey ?? " "
        // "Love" this item
        let ref = Database.database().reference()
        
        
        
        var voters = self.items?[tappedIndexPath.row].upvoters ?? []
        voters.append(Auth.auth().currentUser?.email ?? "")
        
        var downvoters = self.items?[tappedIndexPath.row].downvoters ?? []
        
        if (downvoters.contains(Auth.auth().currentUser?.email ?? "")) {
            let ind = self.items?[tappedIndexPath.row].downvoters.index(of: Auth.auth().currentUser?.email ?? "")
            downvoters.remove(at: ind!)
            numVotes = numVotes + 1
        }
        
        ref.child(key).updateChildValues(["votes":numVotes])
        ref.child(key).updateChildValues(["downvoters":downvoters])
        ref.child(key).updateChildValues(["upvoters":voters])
        
        
        
    }
    
    // The cell calls this method when the user taps the trash icon
    func downvotePressed(_ sender: postContentCell) {
        guard let tappedIndexPath = feedTableView.indexPath(for: sender) else { return }
        print("Trash", sender, tappedIndexPath)
        
        var numVotes = self.items?[tappedIndexPath.row].postVotes ?? 0
        numVotes = numVotes - 1
        let key = self.items?[tappedIndexPath.row].postKey ?? " "
        // "Love" this item
        let ref = Database.database().reference()
        
        
        var voters = self.items?[tappedIndexPath.row].downvoters ?? []
        voters.append(Auth.auth().currentUser?.email ?? "")
        
        var upvoters = self.items?[tappedIndexPath.row].upvoters ?? []

        if (upvoters.contains(Auth.auth().currentUser?.email ?? "")) {
            let ind = self.items?[tappedIndexPath.row].upvoters.index(of: Auth.auth().currentUser?.email ?? "")
            upvoters.remove(at: ind!)
            numVotes = numVotes - 1
        }
        
        ref.child(key).updateChildValues(["votes":numVotes])
        ref.child(key).updateChildValues(["downvoters":voters])
        ref.child(key).updateChildValues(["upvoters":upvoters])
        
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(180.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "postContentCell"
        let cell: postContentCell = feedTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! postContentCell

        cell.delegate = self
//        cell.layer.borderColor = hexStringToUIColor(hex: "#0C2C4A").cgColor
//        cell.layer.borderWidth = CGFloat(1.5)
        cell.username.text =  self.items?[indexPath.row].username ?? " "
        cell.postContent.text = self.items?[indexPath.row].postText ?? " "
        
        let stringTS = self.items?[indexPath.row].postKey ?? "0"
        let doubleTS = Double(stringTS)! / 1000
        let date = NSDate(timeIntervalSinceReferenceDate: doubleTS)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy HH:mm"
        let myStringafd = formatter.string(from: date as Date)
        cell.postTime.text = myStringafd
        
        cell.numberOfVotes.text = String(describing: self.items?[indexPath.row].postVotes ?? 0)
        cell.downvoteButton.isEnabled = true
        cell.upvoteButton.isEnabled = true
        let email = Auth.auth().currentUser?.email ?? "-"
        if (self.items?[indexPath.row].downvoters.contains(email))! {
            cell.downvoteButton.isEnabled = false
            cell.upvoteButton.isEnabled = true
            cell.downvoteButton.alpha = CGFloat(0.5)
            cell.upvoteButton.alpha = CGFloat(1.0)
        }
        if (self.items?[indexPath.row].upvoters.contains(email))! {
            cell.upvoteButton.isEnabled = false
            cell.downvoteButton.isEnabled = true
            cell.upvoteButton.alpha = CGFloat(0.5)
            cell.downvoteButton.alpha = CGFloat(1.0)
            
        }
        
        return cell
        
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
    
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.items = self.items?.sorted(by: { $0.postVotes > $1.postVotes })
            feedTableView.reloadData()
        case 1:
            self.items = self.items?.sorted(by: { $0.postKey > $1.postKey })
            feedTableView.reloadData()
        default:
            print("nothing")
        }
    }
    
}
