//
//  UserData.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase

class UserData: NSObject{
    // Properties
    var uid: String?
    var name: String?
    var email: String?
    var username: String?
    var profilePicURL: String?
    
    // Shared Instance
    static var shared = UserData()
    
    // Constructors
    override init(){}
    
    init(_ user: User){
        super.init()
        self.setData(user)
    }
    
    // Methods
    func setData(_ user: User){
        self.uid = user.uid
        self.email = user.email
        self.name = user.displayName
    }
}

