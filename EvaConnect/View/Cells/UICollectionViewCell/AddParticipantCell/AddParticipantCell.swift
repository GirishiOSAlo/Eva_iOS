//
//  AddParticipantCell.swift
//  EvaConnect
//
//  Created by usama on 28/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Kingfisher

protocol AddParticipantActionable {
    func tappedCell()
}

class AddParticipantCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var crossView: UIView!
    @IBOutlet weak var imageContainer: UIView!
//    {
//        didSet {
//            imageContainer.layer.borderWidth = 1.0
//            imageContainer.layer.borderColor = UIColor.green.cgColor
//            imageContainer.roundOnly()
//        }
//    }
    @IBOutlet weak var userAvatar: UserAvatarView! {
        didSet {
            
            userAvatar.setImageSource(source: nil)
            userAvatar.outline = UserAvatarView.Outline(width: 2.0, color: AppColors.lightBlue)

            userAvatar.roundOnly()
        }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var occupation: UILabel!
    
    var tapGesture: UIGestureRecognizer?
    var delegate: AddParticipantActionable?

    var showCross: Bool = false {
        didSet {
            crossView.isHidden = !showCross
        }
    }
        
    var connection: UserConnection! {
        
        didSet {
            print("user", connection.firstName ?? connection.userName ?? "") //, connection.lastName)
            name.text = connection.firstName ?? connection.userName ?? "" //+ " " + connection.lastName.stringValue
            
            //let company = !connection.companyName.isNilOrEmpty ? "\(connection.companyName.stringValue)" : "\(connection.designation.stringValue)"
            
            occupation.text = connection.companyName ?? connection.company_Name ?? ""
            
            
            if !connection.userImage.isNil {
                userAvatar.sd_setImage(with: URL(string: connection.userImage!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
            }
        }
    }
    
    var attendees: AttendeesList! {
        
        didSet {
            name.text = attendees.name ?? "" //+ " " + connection.lastName.stringValue
            occupation.text = attendees.companyName ?? ""
            if !attendees.userImage.isNil {
                userAvatar.sd_setImage(with: URL(string: attendees.userImage!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
            }
        }
    }
    
    var invitedPeople: InvitedPeople! {
        
        didSet {
            print("user" ,invitedPeople.firstName ?? "") //, connection.lastName)
            name.text = invitedPeople.firstName ?? "" //+ " " + connection.lastName.stringValue
            
            //let company = !connection.companyName.isNilOrEmpty ? "\(connection.companyName.stringValue)" : "\(connection.designation.stringValue)"
            
            occupation.text = invitedPeople.companyName ?? ""
            
            
            if !invitedPeople.userImage.isNil {
                userAvatar.sd_setImage(with: URL(string: invitedPeople.userImageURL ?? ""), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .continueInBackground, completed: .none)
            }
        }
    }
    
//    var eventIntrested: EventIntrested! {
//
//        didSet {
//            // name.text = attendee.user.firstName + attendee.user.lastName.stringValue
//            name.text = eventIntrested.user.firstName
//            if let imageUrl = eventIntrested.user.userImage {
//
//                userAvatar.getImage(urlString: imageUrl) { (image, error) in
//                    if let image = image {
////                        self.userAvatar.image = image.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//                        self.userAvatar.image = image
//                    }
//                }
//            }
//
//            occupation.text = eventIntrested.user.designation ?? ""
////            occupation.textColor = UIColor(named: "Red")!
//        }
//    }
    

//    var participant: Participants! {
//
//        didSet {
//            name.text = participant.name
//            if let imageUrl = participant.imageUrl {
//
//                userAvatar.getImage(urlString: imageUrl) { (image, error) in
//                    if let image = image {
////                        self.userAvatar.image = image.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//                        self.userAvatar.image = image
//                    }
//                }
//            }
//
//            occupation.text = participant.designation.stringValue
//        }
//    }
    
//    var attendieParticipant: (attendee: Participants, type: ViewerType)! {
//        didSet {
//            name.text = attendieParticipant.attendee.name
//            if let imageUrl = attendieParticipant.attendee.imageUrl {
//                userAvatar.getImage(urlString: imageUrl) { (image, error) in
//                    if let image = image {
////                        self.userAvatar.image = image.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//                        self.userAvatar.image = image
//                    }
//                }
//                crossView.isHidden = false
//            } else {
//                userAvatar.image = UIImage(named: "addInvite")?.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//                crossView.isHidden = true
//            }
//            occupation.text = attendieParticipant.attendee.designation.stringValue
//        }
//    }
    
//    var connection: (user: User, type: ViewerType)! {
//        didSet {
//            name.text = connection.user.firstName
//            occupation.text = connection.user.designation.stringValue
//            if let userImage = connection.user.userImage {
//                userAvatar.getImage(urlString: userImage) { (image, error) in
//                    if let image = image {
//                        self.userAvatar.image = image.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//                    }
//                }
//                crossView.isHidden = false
//            } else {
//                userAvatar.image = UIImage(named: "addInvite")?.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//                crossView.isHidden = true
//            }
//            occupation.text = connection.user.designation.stringValue
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        tapGesture = nil
        userAvatar.image = nil
        name.text = ""
        occupation.text = ""
    }

    func initUI() {
        
        userAvatar.image = UIImage(named: "profileSample3")?.imageWithInsets(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        userAvatar.roundOnly()
        self.baseView.backgroundColor = .white //UIColor(hex: "F8F8F6")
        self.baseView.layer.cornerRadius = 6
        self.baseView.layer.masksToBounds = true
        
        crossView.isHidden = false
        
   //     imageContainer.layer.borderColor = AppColors.bgView.cgColor
    //    imageContainer.layer.borderWidth = 1.0
//        imageContainer.roundOnly()
//        userAvatar.roundOnly()
//        name.text = "Add Participant"
//        occupation.isHidden = true
    }
    
//    func addGestures() {
//
//        if name.text == "Add Participant" {
//            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedCell))
//            userAvatar.addGestureRecognizer(tapGesture!)
//            name.addGestureRecognizer(tapGesture!)
//            occupation.addGestureRecognizer(tapGesture!)
//            contentView.addGestureRecognizer(tapGesture!)
//        }
//    }
    
    func defaultUI() {
        userAvatar.image = UIImage(named: "addInvite")
        name.text = "Invite People"
        occupation.text = "From Connection"
        crossView.isHidden = true
    }
    
    @objc func tappedCell(_ sender: UITapGestureRecognizer) {
        delegate?.tappedCell()
      }
}


