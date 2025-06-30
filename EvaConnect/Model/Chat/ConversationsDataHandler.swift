////
////  ConversationsDataHandler.swift
////  ySkolar
////
////  Created by Muhammad Sajad on 01/03/2019.
////  Copyright © 2019 AAA. All rights reserved.
////
//
////import FirebaseDatabase
//import UIKit
//
//struct ChatMember {
//    let id: String
//    let name: String
//    init(id: String, name: String) {
//        self.id = id
//        self.name = name
//    }
//}
//
//struct Group {
//    let id: String
//    let name: String
//    let image: String?
//    
//    init(snapshot: DataSnapshot) {
//        let dictionary = snapshot.value as! [String:Any]
//        id = snapshot.key
//        name = dictionary["name"] as! String
//        image = dictionary["image"] as? String
//    }
//    
//    init(id: String, name: String) {
//        self.id = id
//        self.name = name
//        self.image = nil
//    }
//}
//
//
//
//class Conversation: Equatable {
//    let id: String
//    var user: EvaUser?
//    var lastMessage: Message?
//    var memebers: [ChatMember] = []
//    var isUnread = false
//    var unreadCount = 0
//    
//    init(snapshot: DataSnapshot) {
//        if let dictionary = snapshot.value as? [String: Any] {
//            id = snapshot.key
//            //self.title = dictionary["title"] as! String
//            if let message = dictionary["lastMessage"] as? [String:Any] {
//                self.lastMessage = Message(id: "xxx", dictionary: message)
//            }
//            
//            let snaps = snapshot.childSnapshot(forPath: "members")
//            memebers = snaps.children.compactMap ({ (snap) -> ChatMember? in
//                if let snap = snap as? DataSnapshot {
//                    return ChatMember(id: snap.key, name: snap.value as! String)
//                }
//                return nil
//            })
//            
//        } else {
//            id = ""
//        }
//    }
//    
//    var title: String = "" {
//        didSet {
//            didUpdateTitle?(title)
//        }
//    }
//    
//    private func formatTitle(from title: String) -> String {
//
//            let componenets = title.components(separatedBy: " ")
//            if componenets.count == 1 {
//                return componenets[0]
//            } else if componenets.count == 2 {
//                return "\(componenets[0]) \(componenets[1].first!)"
//            } else {
//                return ""
//            }
//    }
//    
//    var imageName: String? {
//        didSet {
//            didUpdateImageName?(imageName)
//        }
//    }
//
//    
//    var didUpdateTitle: ((String) -> Void)?
//    var didUpdateImageName: ((String?) -> Void)?
//    
//    init(id: String, title: String) {
//        self.id = id
//        self.title = title
//    }
//    
//    var timeString: String {
//        if let lastMessage = lastMessage,
//            let pretty = Date.datePrettyFromTimestamp(lastMessage.timeStamp) {
//            if pretty.day == TODAY {
//                return pretty.time
//            } else {
//                return pretty.day
//            }
//        }
//        return ""
//    }
//    
//    func fetchValues() {
//        
//            let user = memebers.filter { $0.id != "\(LoggedUserDetails.shared.user!.id)"}.first!
//            self.title = user.name
//            let userId = user.id
//            FirebaseHandler.handler.ref.child("users").child(userId).observe(.value) { (snapshot) in
//                if let snapshotDic = snapshot.value as? [String:Any],
//                    let imageName = snapshotDic["imageName"] as? String {
//                    self.imageName = imageName
//                }
//            }
//    }
//    
//    var placeHolderImage: UIImage {
//        #imageLiteral(resourceName: "profile")
//    }
//    
//    static func ==(lhs: Conversation, rhs: Conversation) -> Bool {
////        return (lhs.id == rhs.id) && (lhs.user?.id == rhs.user?.id)
//        return (lhs.user?.id == rhs.user?.id)
//    }
//    
//    static func getMemeberId(snapshot: DataSnapshot) -> Int {
//        let snaps = snapshot.childSnapshot(forPath: "members")
//        let id = snaps.children.compactMap ({ (snap) -> ChatMember? in
//            if let snap = snap as? DataSnapshot {
//                return ChatMember(id: snap.key, name: snap.value as! String)
//            }
//            return nil
//        }).first(where: { $0.id != "\(LoggedUserDetails.shared.user!.id)" })?.id
//        return Int(id ?? "") ?? -1
//    }
//}
//
//struct Sender {
//    let id: Int
//    let name: String
//}
//
//struct Message: Equatable {
//    
//    var documents: [String] = []
//    var images: [String] = []
//    var sameSender = false
//    var sender: Sender
//    var messageId: String
//    var sentDate: Date {
//        return Date.getDateFromTimeStamp(timeStamp: timeStamp, dtFormatter: "MMM d, yyyy hh:mm aa")!
//    }
//    
//    var timeStamp: Double
//    var text: String?
//    
//    var timeString: String {
//        let pretty = Date.datePrettyFromTimestamp(timeStamp)
//        if let timeDate = pretty {
//            if timeDate.day == TODAY {
//                return timeDate.time
//            } else {
//                return timeDate.day
//            }
//        }
//        
//        return ""
//    }
//    
//    var fbDictionary: [String: Any]? {
//    
//        var dict: Dictionary<String, Any> = [
//                "name": sender.name,
//                "senderID": sender.id,
//                "timestamp": timeStamp]
//        
//        if let text = text {
//            dict["message"] = text
//        }
//        
//        if images.count > 0 {
//            
//            dict["images"] = images
//        }
//        
//        if documents.count > 0 {
//            dict["documents"] = documents
//        }
//        
//        return dict
//    }
//    
//    static func == (lhs: Message, rhs: Message) -> Bool {
//        return lhs.messageId == rhs.messageId
//    }
//}
//
//extension Message {
//    
//    init(text: String, sender: Sender, messageId: String, date: Date, images: [String] = [], documents: [String] = []) {
//        self.timeStamp = (date.timeIntervalSince1970 * 1000).rounded()
//        self.sender = sender
//        self.messageId = messageId
//        self.text = text
//        self.images = images
//        self.documents = documents
//    }
//    
//    init(snapshot: DataSnapshot) {
//        let dictionary = snapshot.value as! [String:Any]
//        self.init(id: snapshot.key, dictionary: dictionary)
//    }
//    
//    init(id: String, dictionary: [String: Any]) {
//        self.messageId = id
//        self.timeStamp = dictionary["timestamp"] as! Double
//        self.sender = Sender(id: dictionary["senderID"] as! Int, name: dictionary["name"] as! String)
//        self.text = dictionary["message"] as? String
//        
//        if let images = dictionary["images"] as? [String] {
//            self.images = images
//        }
//        
//        if let documents = dictionary["documents"] as? [String] {
//            self.documents = documents
//        }
//    }
//}
