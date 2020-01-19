//
//  Date.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 11/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

extension Date{
    func userReadableDate()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: self)
    }
}
