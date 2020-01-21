//
//  UserData.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase

var allowedTags = [String]()

class UserData: NSObject, Codable{
    // Properties
    var uid: String?
    var name: String?
    var email: String?
    var username: String?
    var profilePicURL: String?
    var followerCount: Int = 0
    var followingCount: Int = 0
    var likesCount: Int = 0
    var questionsCount: Int = 0
    var answersCount: Int = 0
    
    var department: String?
    var programme: String?
    var year: String?
    var tags: [String]?
    
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
    }
    
    func setStats(_ stats: Any){
        guard let stats = stats as? [String: Int] else{
            print("Stats Typecasting Error")
            return
        }
        
        self.followerCount = stats["followerCount"]!
        self.followingCount = stats["followingCount"]!
        self.likesCount = stats["likesCount"]!
        self.questionsCount = stats["questionsCount"]!
        self.answersCount = stats["answersCount"]!
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case profilePicURL
        case followerCount
        case followingCount
        case likesCount
        case questionsCount
        case answersCount
        case department
        case programme
        case year
        case tags
    }
    
//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decode(String.self, forKey: .name)
//        profilePicURL = try values.decode(String.self, forKey: .profilePicURL)
//        followerCount = try values.decode(Int.self, forKey: .followerCount)
//        followingCount = try values.decode(Int.self, forKey: .followingCount)
//        likesCount = try values.decode(Int.self, forKey: .likesCount)
//        questionsCount = try values.decode(Int.self, forKey: .questionsCount)
//        answersCount = try values.decode(Int.self, forKey: .answersCount)
//        department = try values.decode(String.self, forKey: .department)
//        programme = try values.decode(String.self, forKey: .programme)
//        year = try values.decode(String.self, forKey: .year)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//        try container.encode(profilePicURL, forKey: .profilePicURL)
//        try container.encode(followerCount, forKey: .followerCount)
//        try container.encode(followingCount, forKey: .followingCount)
//        try container.encode(likesCount, forKey: .likesCount)
//        try container.encode(questionsCount, forKey: .questionsCount)
//        try container.encode(answersCount, forKey: .answersCount)
//        try container.encode(department, forKey: .department)
//        try container.encode(programme, forKey: .programme)
//        try container.encode(year, forKey: .year)
//    }
}
