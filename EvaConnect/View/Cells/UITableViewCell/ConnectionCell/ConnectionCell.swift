//
//  ConnectionCell.swift
//  EvaConnect
//
//  Created by Metis on 11/06/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

protocol ConnectionCellDelegate: NSObject {
    func sendBtn(connection: UserConnection)
    func didViewProfile(connection: UserConnection)
    func acceptUser(connection: UserConnection)
    func declineUser(connection: UserConnection)
    func cancelRequest(connection: UserConnection)
}

class ConnectionCell: BaseCellClass {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDesignation: UILabel!
    @IBOutlet weak var userCompany: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var connect: UIButton!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var decline: UIButton!
    @IBOutlet var acceptanceStackView: UIStackView!
    @IBOutlet weak var connectedBtn: UIButton!
    
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var onlineStatusVw: UIView!
    @IBOutlet weak var stackViewWidth: NSLayoutConstraint!
    @IBOutlet weak var connectedView: UIView!
    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var blockedView: UIView!
    @IBOutlet weak var sentReqView: UIView!
    @IBOutlet weak var addFriendView: UIView!
    @IBOutlet weak var cancelReqBtn: UIButton!
    @IBOutlet weak var addFriendBtn: UIButton!
    
    
    var delegate: SelectionCellActionable?
    weak var connectionDelegate: ConnectionCellDelegate? = nil
    var connectionType: EvaConnectionType!
    var requestType: EvaRequestType!
    
    var connection: UserConnection! {

        didSet {
            //print("user", connection.firstName) //, connection.lastName)
            userName.text = connection.firstName.stringValue //+ " " + connection.lastName.stringValue

            let company = !connection.companyName.isNilOrEmpty ? "\(connection.companyName.stringValue)" : "\(connection.designation.stringValue)"

            userDesignation.text = company
//            userDesignation.textColor = UIColor(named: "Red")!
            onlineStatusVw.isHidden = connection.loginStatus == "Online" ? false : true

            if !connection.userImage.isNil {
                userImage.sd_setImage(with: URL(string: connection.userImage!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
            }
            
            if !isIndivisualUser && !connection.userImageUrl.isNil {
                userImage.sd_setImage(with: URL(string: connection.userImageUrl!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
            }
            
            switch connectionType {
            case .followers:
                self.blockedView.isHidden = true
                self.pendingView.isHidden = true
                self.connectedView.isHidden = false
                self.addFriendView.isHidden = true
                self.sentReqView.isHidden = true
                self.addFriendView.isHidden = true

//                connect.setTitle("View Profile", for: .normal)
//                connect.isHidden = false
//                accept.isHidden = true
//                decline.isHidden = true

            case .pending:
                self.blockedView.isHidden = true
                self.connectedView.isHidden = true
                //self.addFriendView.isHidden = true
                
                if requestType == .received {
                    self.pendingView.isHidden = false
                    self.sentReqView.isHidden = true
                    self.addFriendView.isHidden = true
                } else {
                    self.pendingView.isHidden = true
                    self.sentReqView.isHidden = false
                    self.addFriendView.isHidden = true
                }
//                self.blockedView.isHidden = true
//                self.connectedView.isHidden = true
//                self.connectedView.isHidden = true
//                self.pendingView.isHidden = false
//                self.blockedView.isHidden = true
//                self.stackViewWidth.constant = 85

//                connect.isHidden = true
//                accept.isHidden = false
//                decline.isHidden = false
            case .blocked:
                self.blockedView.isHidden = false
                self.pendingView.isHidden = true
                self.connectedView.isHidden = true
                self.addFriendView.isHidden = true
                self.sentReqView.isHidden = true
                self.addFriendView.isHidden = true
//                self.connectedView.isHidden = true
//                self.pendingView.isHidden = true
//                self.blockedView.isHidden = false
//                self.stackViewWidth.constant = 88

                connect.setTitle("Unblock", for: .normal)
//                connect.isHidden = false
//                accept.isHidden = true
//                decline.isHidden = true
            case .none:
                print("none")
            }
        }
    }
    
    var applicants: ApplicationList! {

        didSet {
            userName.text = applicants.firstName

            userDesignation.text = applicants.companyName

            if !applicants.userImage.isNil {
                userImage.sd_setImage(with: URL(string: applicants.userImage!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
            }

                self.blockedView.isHidden = true
                self.pendingView.isHidden = true
                self.connectedView.isHidden = false
                self.addFriendView.isHidden = true

        }
    }
    
    var emps: Employees! {

        didSet {
            userName.text = emps.firstName

            userDesignation.text = emps.designation

            if !emps.userImageURL.isNil {
                userImage.sd_setImage(with: URL(string: emps.userImageURL!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
            }
            
            onlineStatusVw.isHidden = (emps.loginStatus == "Online" ? false : true)

                self.blockedView.isHidden = true
                self.pendingView.isHidden = true
                self.connectedView.isHidden = false
                self.addFriendView.isHidden = true

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    func initUI() {
        self.baseView.layer.cornerRadius = 13
        self.onlineStatusVw.layer.cornerRadius = self.onlineStatusVw.frame.size.height/2
        self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2
        
        //userImage.roundOnly()
//        accept.makeRoundView(boderColor: Constants.AppColorLiteral.greenColor, boderValue: 1.0)
//        decline.makeRoundView(boderColor: Constants.AppColorLiteral.loginColor, boderValue: 1.0)
//        connect.makeRoundView(boderColor: AppColors.evaBlue, boderValue: 1.0)
//        connect.setTitleColor(AppColors.evaBlue, for: .normal)
        
        self.connectedBtn.layer.cornerRadius = 12.0
//        connect.makeRoundView(boderColor: UIColor(hex: "#4D76CD"), boderValue: 1.0)
//        connect.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
//        connect.roundOnly()
        
    }
    
    func setData(obj: ApplicationList) {
        if let imageUrl = obj.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            self.userImage.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            self.userImage.image = UIImage(named: "profile")
        }
        
        userName.text = "\(obj.firstName ?? "") \(obj.lastName ?? "")"
        
        let company = !obj.companyName.isNilOrEmpty ? "\(obj.companyName ?? "")" : "\(obj.designation ?? "")"
        userDesignation.text = company
        
        onlineStatusVw.isHidden = obj.onlineStatus == "Online" ? false : true
        
        //ConnectionType == Followers
        self.blockedView.isHidden = true
        self.pendingView.isHidden = true
        self.connectedView.isHidden = false
        self.addFriendView.isHidden = true
        self.sentReqView.isHidden = true
        self.addFriendView.isHidden = true
    }
    
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        connectionDelegate?.sendBtn(connection: connection)
    }
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        connectionDelegate?.acceptUser(connection: connection)
    }
    
    @IBAction func declineBtnTapped(_ sender: Any) {
        connectionDelegate?.declineUser(connection: connection)
    }
    
    @IBAction func connect_touchUpInside(_ sender: UIButton) {
        connectionDelegate?.didViewProfile(connection: connection)
    }
    
    @IBAction func cancelReqBtnTapped(_ sender: UIButton) {
        print("Sent Request Button Tapped.")
        connectionDelegate?.cancelRequest(connection: connection)
    }
    
    @IBAction func addFriendBtnTapped(_ sender: UIButton) {
        print("Add Friend Button Tapped.")
    }
    
    
//    private func followers() {
//        switch connection.isConnected {
//        case .notConnected:
//            connect.isHidden = false
//            connect.setTitle("Connect", for: .normal)
//            acceptanceStackView.isHidden = true
//            
//        case .pending:
//            if connection.isReceiver! {
//                connect.isHidden = true
//                acceptanceStackView.isHidden = false
//                
//            } else {
//                connect.isHidden = false
//                connect.setTitle("Pending", for: .normal)
//                acceptanceStackView.isHidden = true
//            }
//            
//        case .active:
//            connect.isHidden = false
//            connect.setTitle("Connected", for: .normal)
//            acceptanceStackView.isHidden = true
//            
//        default:
//            break
//        }
//    }
}
extension ConnectionCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}
