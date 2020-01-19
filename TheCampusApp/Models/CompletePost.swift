//
//  CompletePostModel.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 11/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase

class CompletePost: Codable{
    var postID: String?
    var question: String?
    var answers: [Answers]?
    var lastDoc: DocumentSnapshot?
    var descriptionURLString: String?
    var askerName: String?
    var askerProfilePicURLString: String?
    var askerID: String?
    var topAnswer: String?
    var topAnswerUserName: String?
    var topAnswerUserProfilePicURLString: String?
    var topAnswerUserID: String?
    var dateAnswered: Date?
    var dateAsked: Date?
    var description: NSAttributedString?
    var apprType: AppreciationType?
    
    enum CodingKeys: String, CodingKey{
        case question
        case descriptionURLString
        case askerName
        case askerProfilePicURLString
        case askerID
        case topAnswer
        case topAnswerUserName
        case topAnswerUserProfilePicURLString
        case topAnswerUserID
        case dateAnswered
        case dateAsked
        case answers
    }
    
    init(){
        self.askerName = UserData.shared.name
        self.askerID = UserData.shared.uid
        self.askerProfilePicURLString = UserData.shared.profilePicURL
    }
    
    init(question: String, description: String) {
        self.question = question
        self.descriptionURLString = description
        self.askerName = UserData.shared.name
        self.askerID = UserData.shared.uid
        self.askerProfilePicURLString = UserData.shared.profilePicURL
        self.dateAsked = Date()
    }
    
//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        question = try values.decode(String.self, forKey: .question)
//        descriptionURLString = try values.decode(String.self, forKey: .descriptionURLString)
//        askerName = try values.decode(String.self, forKey: .askerName)
//        askerProfilePicURLString = try values.decode(String.self, forKey: .askerProfilePicURLString)
//        askerID = try values.decode(String.self, forKey: .askerID)
//        topAnswer = try values.decode(String.self, forKey: .topAnswer)
//        topAnswerUserName = try values.decode(String.self, forKey: .topAnswerUserName)
//        topAnswerUserProfilePicURLString = try values.decode(String.self, forKey: .topAnswerUserProfilePicURLString)
//        topAnswerUserID = try values.decode(String.self, forKey: .topAnswerUserID)
//        dateAnswered = try values.decode(Date.self, forKey: .dateAnswered)
//        dateAsked = try values.decode(Date.self, forKey: .dateAsked)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(question, forKey: .question)
//        try container.encode(descriptionURLString, forKey: .descriptionURLString)
//        try container.encode(askerName, forKey: .askerName)
//        try container.encode(askerProfilePicURLString, forKey: .askerProfilePicURLString)
//        try container.encode(askerID, forKey: .askerID)
//        try container.encode(topAnswer, forKey: .topAnswer)
//        try container.encode(topAnswerUserName, forKey: .topAnswerUserName)
//        try container.encode(topAnswerUserProfilePicURLString, forKey: .topAnswerUserProfilePicURLString)
//        try container.encode(topAnswerUserID, forKey: .topAnswerUserID)
//        try container.encode(dateAnswered, forKey: .dateAnswered)
//        try container.encode(dateAsked, forKey: .dateAsked)
//    }
}

