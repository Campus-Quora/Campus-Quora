//
//  APIService.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 12/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}

extension DocumentSnapshot{
    func decoded<T: Decodable>() throws -> T{
        let jsonData = try JSONSerialization.data(withJSONObject: data()!, options: [])
        let object = try JSONDecoder().decode(T.self, from: jsonData)
        return object
    }
}

extension QuerySnapshot{
    func decoded<T: Decodable>() throws -> [T]{
        let objects: [T] = try documents.map { (document) -> T in
            try document.decoded()
        }
        return objects
    }
}

class APIService{
    static var storageRef = Storage.storage().reference()
    static var databaseRef = Firestore.firestore()
    static var userInfoCollection = databaseRef.collection("userInfo")
    static var postsCollection = databaseRef.collection("posts")
    static var questionsCollection = storageRef.child("questions")
    static var answersCollection = storageRef.child("answers")
    static var apprCollection = databaseRef.collection("Likes")
    
    static func getUserInfo(){
        let uid = (Auth.auth().currentUser?.uid)!
        userInfoCollection.document(uid).getDocument { (document, error) in
            if((error) != nil){
                print("#1 Error Retrieving UserInfo")
                return
            }
            guard let document = document else{
                print("#2 Nil UserInfo")
                return
            }
            do{
                UserData.shared = try document.decoded()
                UserData.shared.uid = uid
                let name = Notification.Name(updateUserDataKey)
                NotificationCenter.default.post(name: name, object: nil)
                print("Fetched User Data")
            }
            catch{
                print("#3 Error Decoding Data")
                return
            }
        }
    }
    
    static func updateUserInfo(callback: @escaping (Bool)->Void){
        let uid = UserData.shared.uid!
        let userData = try! UserData.shared.asDictionary()
        userInfoCollection.document(uid).setData(userData){ error in
            if let error = error{
                print("Update Data ERROR #3 : \n\n", error)
                return;
            }
            callback(error != nil)
        }
    }
    
    static func reauthenticate(with password: String?, callback: @escaping (Error?)->Void){
        let user = Auth.auth().currentUser
        guard let password = password else{return}
        guard let email = user?.email else{return}
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user?.reauthenticate(with: credential, completion: { (result, error) in
            callback(error)
        })
    }
    
    static func postQuestion(question: String, description: Data, callback: @escaping (String)->Void){
        let baseString = String.uniqueFilename()
        let descriptionFileName = "Ques_\(baseString)"
        let postID = "Post_\(baseString)"
        
        let fileRef = questionsCollection.child(descriptionFileName)
        let postData = CompletePost(question: question, description: descriptionFileName)
        let postsDictionary = try! postData.asDictionary()
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fileRef.putData(description, metadata: nil){
            (metadata, error) in
            if((error) != nil){
                print("Error Saving File")
                return
            }
            print("Size of File stored", metadata!.size)
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        postsCollection.document(postID).setData(postsDictionary){ (error) in
            if((error) != nil){
                print("Error Adding Question")
                return
            }
            print("Added Question")
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        userInfoCollection.document(UserData.shared.uid!).updateData([ "questionsCount": Firebase.FieldValue.increment(Int64(1))]){(error) in
            if((error) != nil){
                print("Error Incement Question Counter")
                return
            }
            print("Incemented Question Counter")
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main){
            callback(postID)
            UserData.shared.questionsCount += 1
            let name = Notification.Name(updateUserDataKey)
            NotificationCenter.default.post(name: name, object: nil)
            print("Finished Asking Question")
        }
    }
    
    static func postAnswer(questionID: String?, answerData: Data, callback: @escaping (Answers)->Void) {
        guard let questionID = questionID else{
            print("Empty Question ID")
            return
        }
        
        let answerID = String.uniqueFilename(withPrefix: "Ans_")
        let fileRef = answersCollection.child(answerID)
        let answer = Answers(answerURLString: answerID)
        let answerDictionary = try! answer.asDictionary()
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fileRef.putData(answerData, metadata: nil){
            (metadata, error) in
            if((error) != nil){
                print("Error Saving File")
                return
            }
            print("Size of File stored", metadata!.size)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        let answerPath = CompletePost.CodingKeys.answers.rawValue
        postsCollection.document(questionID).collection(answerPath).addDocument(data: answerDictionary){ (error) in
            if((error) != nil){
                print("Error Adding Answer")
                return
            }
            print("Added Answer")
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        print(UserData.CodingKeys.answersCount.description)
        userInfoCollection.document(UserData.shared.uid!).updateData([ "answersCount": Firebase.FieldValue.increment(Int64(1))]){(error) in
            if((error) != nil){
                print("Error Incement Answer Counter")
                return
            }
            print("Incemented Answer Counter")
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main){
            callback(answer)
            UserData.shared.answersCount += 1
            let name = Notification.Name(updateUserDataKey)
            NotificationCenter.default.post(name: name, object: nil)
            print("Finished Answering Question")
        }
    }
    
    static func fetchUserFeed(initialSize: Int, callback: @escaping (Bool, [CompletePost], DocumentSnapshot?)->Void){
        postsCollection.limit(to: initialSize).getDocuments { (snapshot, error) in
            if(error != nil){
                print("#1 Error Fetching User Feed")
                callback(false, [], nil)
                return
            }
            
            guard let snapshot = snapshot else{
                print("#2 Snapshot is nil")
                callback(false, [], nil)
                return
            }
            
            let feed: [CompletePost] = try! snapshot.decoded()
            for i in 0 ..< feed.count{
                feed[i].postID = snapshot.documents[i].documentID
            }
            callback(true, feed, snapshot.documents.last)
        }
    }
    
    static func paginateUserFeed(after last: DocumentSnapshot?, batchSize: Int, callback: @escaping (Bool, [CompletePost], DocumentSnapshot?)->Void){
        if let last = last{
            let query = postsCollection.start(afterDocument: last).limit(to: batchSize)
            query.getDocuments { (snapshot, error) in
                if(error != nil){
                    print("#1 Error Fetching User Feed")
                    callback(false, [], nil)
                    return
                }
                
                guard let snapshot = snapshot else{
                    print("#2 Snapshot is nil")
                    callback(false, [], nil)
                    return
                }
                
                let feed: [CompletePost] = try! snapshot.decoded()
                for i in 0 ..< feed.count{
                    feed[i].postID = snapshot.documents[i].documentID
                }
                callback(true, feed, snapshot.documents.last)
            }
        }
        else{
            fetchUserFeed(initialSize: batchSize, callback: callback)
        }
    }
    
    static func loadDescription(from url: String, callback: @escaping (String, Data)->Void){
        questionsCollection.child(url).getData(maxSize: 3 * 1024 * 1024) { (data, error) in
            if(error != nil){
                print("#1 Description Download error")
                return
            }
            guard let data = data else{return}
            callback(url, data)
        }
    }
    
    static func loadAnswer(from url: String, callback: @escaping (Bool, String, Data)->Void){
        answersCollection.child(url).getData(maxSize: 3 * 1024 * 1024) { (data, error) in
            if(error != nil){
                print("#1 Answer Download error")
                callback(false, url, Data())
                return
            }
            guard let data = data else{return}
            callback(true, url, data)
        }
    }
    
    static func loadAnswersMetadata(for postID: String, initialSize: Int, callback: @escaping (Bool, String, [Answers], DocumentSnapshot?)->Void){
        let answerField = CompletePost.CodingKeys.answers.rawValue
        let dateAnsweredField = CompletePost.CodingKeys.dateAnswered.rawValue
        let query = postsCollection.document(postID).collection(answerField).order(by: dateAnsweredField, descending: true).limit(to: initialSize)
        query.getDocuments { (snapshot, error) in
            if(error != nil){
                print("Error Fetching Answers Metadata")
                callback(false, postID, [], nil)
                return
            }

            guard let snapshot = snapshot else{
                print("#2 Snapshot is nil")
                callback(false, postID, [], nil)
                return
            }
            let answers:[Answers] = try! snapshot.decoded()
            callback(true,postID, answers, snapshot.documents.last)
        }
    }
    
    static func paginateAnswersMetadata(for postID: String, after last: DocumentSnapshot?, batchSize: Int, callback: @escaping (Bool, String, [Answers], DocumentSnapshot?)->Void){
        if let last = last{
            let answerField = CompletePost.CodingKeys.answers.rawValue
            let dateAnsweredField = CompletePost.CodingKeys.dateAnswered.rawValue
            let query = postsCollection.document(postID).collection(answerField).order(by: dateAnsweredField, descending: true).start(afterDocument: last).limit(to: batchSize)
            query.getDocuments { (snapshot, error) in
                if(error != nil){
                    print("Error Fetching Answers Metadata")
                    callback(false, postID, [], nil)
                    return
                }

                guard let snapshot = snapshot else{
                    print("#2 Snapshot is nil")
                    callback(false, postID, [], nil)
                    return
                }
                let answers:[Answers] = try! snapshot.decoded()
                callback(true,postID, answers, snapshot.documents.last)
            }
        }
        else{
            loadAnswersMetadata(for: postID, initialSize: batchSize, callback: callback)
        }
    }
    
    static func updatePassword(_ newPassword: String?, callback: @escaping (Error?)->Void){
        guard let newPassword = newPassword else{return}
        Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
            callback(error)
        }
    }
    
    static func updateEmail(_ newEmail: String?, callback: @escaping (Bool)->Void){
        guard let newEmail = newEmail else{return}
        Auth.auth().currentUser?.updateEmail(to: newEmail) { (error) in
            callback(error == nil)
        }
    }
    
    static func updatePostApprType(for postID: String?, apprType: AppreciationType){
        guard let postID = postID,
              let uid = UserData.shared.uid
        else{return}
        
        let data = [
            "state" : apprType.rawValue,
            "profilePicURL": UserData.shared.profilePicURL ?? ""
        ] as [String : Any]
        
        let collection = postsCollection.document(postID).collection("Like").document(uid)
        switch(apprType){
            case .none:     collection.delete()
            default:        collection.setData(data)
        }
    }
    
    static func getApprType(for postID: String?, callback: @escaping (AppreciationType)->Void){
        guard let postID = postID,
              let uid = UserData.shared.uid
        else{return}
        
        let collection = postsCollection.document(postID).collection("Like").document(uid)
        collection.getDocument { (document, error) in
            let state = document?.data()?["state"] as? Int
            let apprType = AppreciationType(rawValue: state ?? 0) ?? .none
            callback(apprType)
        }
    }
}
