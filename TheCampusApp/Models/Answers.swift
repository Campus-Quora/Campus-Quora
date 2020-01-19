//
//  AnswersModel.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 11/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

class Answers: Codable{
    var userID: String?
    var userName: String?
    var userProfilePicURLString: String?
    var answerURLString: String?
    var dateAnswered: Date?
    var answerNSAString: NSAttributedString?
    
    enum CodingKeys: String, CodingKey{
        case userID
        case userName
        case userProfilePicURLString
        case answerURLString
        case dateAnswered
    }
    
    init(){}
    
    init(userID: String?, userName: String?, userProfilePicURLString: String?, answerURLString: String?) {
        self.userID = userID
        self.userName = userName
        self.userProfilePicURLString = userProfilePicURLString
        self.answerURLString = answerURLString
    }
    
    init(answerURLString: String?) {
        self.userID = UserData.shared.uid
        self.userName = UserData.shared.name
        self.userProfilePicURLString = UserData.shared.profilePicURL
        self.dateAnswered = Date()
        self.answerURLString = answerURLString
    }
}

