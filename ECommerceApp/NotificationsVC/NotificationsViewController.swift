//
//  NotificationsViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 19/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noNotificationsLabel: UILabel!
    var allNotifications = [FBNotification]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadNotification()
    }
    
    func loadNotification() {
        fetchAgentNotification(agentId: FUser.currentId()) { (allNotif) in
            
            if let allNotif = allNotif {
                self.allNotifications = allNotif
            }
            
            if self.allNotifications.isEmpty {
                print("No notifications")
                self.noNotificationsLabel.isHidden = false
            } else {
                self.noNotificationsLabel.isHighlighted = true
            }
            
            self.tableView.reloadData()
        }
    }

    @IBAction func actionBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.configureCell(fbNotification: allNotifications[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        deleteNotification(fbNotification: allNotifications[indexPath.row])
        
        self.allNotifications.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
    
    // Remove tableView separators
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
}














