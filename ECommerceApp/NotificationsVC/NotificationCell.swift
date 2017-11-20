//
//  NotificationCell.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 19/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var telnumberLabel: UILabel!
    @IBOutlet weak var propertyCodeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    func configureCell(fbNotification: FBNotification) {
        
        var phone = fbNotification.phoneNumber
        
        if fbNotification.additionalPhoneNumber != "" {
            phone += ", " + fbNotification.additionalPhoneNumber
        }
        
        fullnameLabel.text = fbNotification.buyerFullName
        telnumberLabel.text = phone
        propertyCodeLabel.text = fbNotification.propertyReference
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        
        dateLabel.text = dateFormatter.string(from: fbNotification.createdAt)
    }
    
    

}
