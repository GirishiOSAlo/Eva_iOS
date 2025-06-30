////
////  ChatManager.swift
////  EvaConnect
////
////  Created by usama on 10/07/2020.
////  Copyright © 2020 HyperNym. All rights reserved.
////
//
//import Foundation
////import FirebaseDatabase
//
//class ConversationFilterOperation: Operation {
//    
//    //Private vars for maintaining states
//    //When ever these changes notify KVO
//    
//    var didFindConversation: ((Conversation) -> Void)?
//    
//    private let chatID: String
//    private let user: User
//    
//    init(snapshot: DataSnapshot, user: User) {
//        self.chatID = snapshot.key
//        self.user = user
//    }
//    
//    private var pExecuting = false {
//        willSet {
//            willChangeValue(forKey: "isExecuting")
//        }
//        didSet {
//            didChangeValue(forKey: "isExecuting")
//            if pExecuting == true {
//                print("Custom Async operation is executing")
//            } else {
//                print("Custom Async method is not executing")
//            }
//        }
//    }
//    private var pFinished = false {
//        willSet {
//            willChangeValue(forKey: "isFinished")
//        }
//        didSet {
//            didChangeValue(forKey: "isFinished")
//            if pFinished {
//                print("Custom Async operation has finished")
//            }
//        }
//    }
//    
//    // MARK: - Override Methods and Properties
//    
//    override var isExecuting: Bool {
//        return pExecuting
//    }
//    override var isFinished: Bool {
//        return pFinished
//    }
//    override var isConcurrent: Bool {
//        return true
//    }
//    
//    
//    override func start() {
//        //Check if is cancelled
//        print("Custom Async operation has started")
//        if isCancelled {
//            //If it cancelled move the operation to finish state
//            pFinished = true
//            return
//        }
//        
//        //Operation is executing
//        pExecuting = true
//        
//        //Setup when you function starts
//        //Create a serial queue
//        let queue = DispatchQueue(label: "com.concurrency.imageQueue")
//        
//        //Dispatch async to continue the execution
//        queue.async {
//            self.main()
//        }
//    }
//    
//    //This is the task which operation does. Its the requirement for subclassing Operation.
//    //Its important to check if the operation was cancelled before doing actual work.
//    //Places to check for isCancelled,
//    //Immediately before you perform any actual work
//    //At least once during each iteration of a loop, or more frequently if each iteration is relatively long
//    //At any points in your code where it would be relatively easy to abort the operation
//    override func main() {
//        //check if operation was cancelled before performing any thing
//        if !isCancelled {
//            FirebaseHandler.handler.ref.child("chats/\(chatID)").observe(.value) { [weak self] (chatsnapshot) in
//                guard let strongSelf = self else {
//                    return
//                }
//                if !strongSelf.isCancelled {
//                    let conversation = Conversation(snapshot: chatsnapshot)
//                        conversation.memebers.forEach { (member) in
//                            if member.id == "\(strongSelf.user.id)" {
//                                conversation.title = strongSelf.user.firstName
//                                strongSelf.didFindConversation?(conversation)
//                            }
//                            strongSelf.completeOperation()
//                        }
//                }
//            }
//            
//        } else {
//            //Operation was cancelled
//            completeOperation()
//        }
//    }
//    
//    //Changed the state when operation is complete.
//    private func completeOperation() {
//        pExecuting = false
//        pFinished = true
//    }
//}
//
//
//protocol ConversationFilterProvidable {
//    func findExistingConversation(with user: User, _ completionHandler: @escaping (Conversation?) -> Void)
//}
//
//
//extension ConversationFilterProvidable {
//    func findExistingConversation(with user: User, _ completionHandler: @escaping (Conversation?) -> Void) {
//        FirebaseHandler.handler.ref.child("users/\(LoggedUserDetails.shared.user!.id)/chats").observeSingleEvent(of: .value) { (chatsnapshot) in
//            if chatsnapshot.childrenCount == 0 {
//                completionHandler(nil)
//                return
//            }
//            
//            let queue = OperationQueue()
//            
//            var hasFoundAMatch: Bool = false
//            
//            let operations: [ConversationFilterOperation] = chatsnapshot.children.map { snapshot in
//                
//                let dataSnapshot = snapshot as! DataSnapshot
//                
//                let operation = ConversationFilterOperation(snapshot: dataSnapshot, user: user)
//                
//                operation.didFindConversation = { [weak queue] conversation in
//                    hasFoundAMatch = true
//                    completionHandler(conversation)
//                    queue?.cancelAllOperations()
//                }
//                return operation
//            }
//            
//            operations.onFinish {
//                DispatchQueue.main.async {
//                    if !hasFoundAMatch {
//                        completionHandler(nil)
//                    }
//                }
//            }
//            
//            queue.addOperations(operations, waitUntilFinished: false)
//        }
//    }
//}
//
//extension NewMessageVC: ConversationFilterProvidable { }
//extension ChatVC: ConversationFilterProvidable { }
