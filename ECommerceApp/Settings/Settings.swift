//
//  Settings.swift
//  ECommerceApp
//
//  Created by nag on 14/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation

private let dateFormat = "yyyyMMddHHmmss"
func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
    
}
