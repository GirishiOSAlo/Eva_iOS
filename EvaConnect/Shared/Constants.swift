//
//  Constants.swift
//  EvaConnect
//
//  Created by usama on 18/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

//var isIndivisualUser: Bool = true
//var isIndivisualUser: Bool = false
enum AppColors {
    
    static let textColor = UIColor(hex: "2D2D28")
    static let textColor2 = UIColor(hex: "545454")
    static let textColor3 = UIColor(hex: "EA5454")
    static let evaBackground = UIColor(hex: "F0F0F0")
    static let textViewBackground = UIColor(hex: "F4F5F6")
    static let border = UIColor(hex: "707070")
    static let border2 = UIColor(hex: "E5E5E5")
    static let shadow = UIColor(hex: "000000")
    static let lightBg = UIColor(hex: "B4B4B4")
    static let lightGrayBG = UIColor(hex: "FCFBFF")
    static let lowerGradient = UIColor(hex: "507FD2")
    static let higherGradient = UIColor(hex: "4D74CC")
    static let evaBlue = UIColor(hex: "5894DD")
    static let higherGradient2 = UIColor(hex: "59D38C")
    static let lowerGradient2 = UIColor(hex: "5BD78F")
    static let dullRed = UIColor(hex: "EA5454")
    static let appColor = UIColor(hex: "5894DD")
    static let lightBlue = UIColor(hex: "5197E2")
    static let darkBlue = UIColor(hex: "393DA8")
    static let solidBlue = UIColor(hex: "5DA9E2")
    static let lighterBlue = UIColor(hex: "5698E0")
    static let blueLowerGradient = UIColor(hex: "3C3FAF")
    static let blueHigherGradient = UIColor(hex: "599AE0")
    static let greenHigherGradient = UIColor(hex: "5BD78F")
    static let greenlowerGradient = UIColor(hex: "5DD887")
    static let lightGrey = UIColor(hex: "EFEFEF")
    static let lowestGradient = UIColor(hex: "3C3FAF")
    static let aquaGreen = UIColor(hex: "59E098")
    static let mildGreen = UIColor(hex: "2ECC71")
    static let placeHolder = UIColor(hex: "DFDFE4")
    static let mildGray = UIColor(hex: "F8F8F8")
    static let appGreen = UIColor(hex: "#2ECC71")
    static let appRed = UIColor(hex: "#EA5454")
    static let appBlue = UIColor(hex: "#4D76CD")
    static let appBlueWith10Alpha = UIColor(hex: "#4D76CD").withAlphaComponent(0.01)
}

enum Myfonts {
    static let regular = "SFProText-Regular"
    static let medium = "SFProText-Medium"
    static let semiBold = "SFProText-Semibold"
    static let bold = "SFProText-Bold"
    static let light = "SFProText-Light"
    static let heavy = "SFProText-Heavy"
}

enum Constants {
    
    enum Login {
        static let signUp = "You have signed up successfully! Thank you for choosing Aviation Connect,please check your email to activate your account"
    }
    enum InternetConnection: String{
        case Offline = "The Internet connection appears to be offline."
    }

    
    enum Segues {
        
        static let signUp1 = "showSignUp1"
        static let signUp2 = "showSignUp2"
        static let signUp3 = "showSignUp3"
        static let signUp4 = "showSignUp4"
        static let signUpLocation = "showSignUpLocation"
        static let showNewsSource = "showNewsSource"
        static let inviteConnections = "showInviteConnections"
        static let editProfile = "showEditProfile"
        static let settings = "showSettings"
        static let linkedIn = "showLinkedIn"
        static let meetingDialog = "showDialog"
        static let meetingView = "showMeetingView"
        static let eventView = "showEventView"
        static let eventDetails = "showEventDetails"
        static let meetingDetails = "showMeetingDetails"
        static let chat = "showChatVC"
        static let textComment = "showTextComment"
        static let otherComments = "showOtherComments"
        static let urlComment = "showURLComment"
        static let editJobUser = "showEditJobUser"
        static let jobApply = "showJobApply"
    }
    
    enum AppColorLiteral {
        static let loginColor = #colorLiteral(red: 0.9176470588, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
        static let loginByNew = #colorLiteral(red: 0, green: 0.4666666667, blue: 0.7098039216, alpha: 1)
        static let loginByFacebook = #colorLiteral(red: 0.2352941176, green: 0.3490196078, blue: 0.5960784314, alpha: 1)
        static let signUpNew = #colorLiteral(red: 0.2352941176, green: 0.2470588235, blue: 0.6862745098, alpha: 1)
        static let nextButtonColor = #colorLiteral(red: 0.3450980392, green: 0.5803921569, blue: 0.8666666667, alpha: 1)
        static let newUnSelectedBackColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let meetingCalenderType =  #colorLiteral(red: 0.9254901961, green: 0.9215686275, blue: 0.937254902, alpha: 1)
        static let calenderTableBack =  #colorLiteral(red: 0.9254901961, green: 0.9215686275, blue: 0.937254902, alpha: 1)
        static let grayShade = #colorLiteral(red: 0.9254901961, green: 0.9215686275, blue: 0.937254902, alpha: 1)
        static let greenColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        static let postTypeBackground = #colorLiteral(red: 0.9803921569, green: 0.9764705882, blue: 0.9921568627, alpha: 1)
        static let borderColor = #colorLiteral(red: 0.301279217, green: 0.3193230033, blue: 0.4364625812, alpha: 1)
        static let selectedColor = #colorLiteral(red: 0.4128893614, green: 0.6531267166, blue: 0.8934965134, alpha: 1)
        static let unSelectedColor = #colorLiteral(red: 0.7574564815, green: 0.7574744821, blue: 0.7574648261, alpha: 1)
    }
    
    enum Chat {
        static let composeMessage = "Compose Your Message"
        static let reply = "Write a reply"
    }

    enum MenuAnimationTime {
         static let menuViewAnimationTime = 0.5
    }
    
    enum DateFormats {
        static let hms = "HH:mm:ss"
        static let hm = "H:mm:ss"
    }
    
    enum PlaceHolders {
        static let typeHere = "Type here....."

    }
    
    enum Label {
        static let error = "Error"
        static let connect = "Connect"
        static let pending = "Pending"
        static let accept = "Accept"
        static let connected = "Connected"
        static let email = "aviation@connect.co.uk"
        static let documentAttactedError = "Cannot attach document, Please remove images or video"
        static let emptyPost = "Please enter something to create a post"
        static let inviteToFollow = "  Invite to Follow  "
        static let invited = "Invited"
        static let active = "active"
        static let newMessage = "New Message"
        static let removeParticipantTitle = "Conformation"
        static let removeParticipantMessage = "Are you sure you want to remove this user?"
    }
    
    
    
    static let maxCharactersToShow = 100
    
    
    // Save enum to UserDefaults
    public static func saveEnumToUserDefaults(_ yourEnum: HomeTabs) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(yourEnum.rawValue, forKey: "yourEnumKey")
    }

    // Retrieve enum from UserDefaults
    public static func getEnumFromUserDefaults() -> HomeTabs? {
        let userDefaults = UserDefaults.standard
        if let rawValue = userDefaults.string(forKey: "yourEnumKey"),
           let yourEnum = HomeTabs(rawValue: rawValue) {
            return yourEnum
        }
        return nil
    }
    
    public static func setUpperCornerRadius(uiView: UIView, radius: CGFloat ) {
        uiView.layer.masksToBounds = true;
        uiView.layer.cornerRadius = radius
        uiView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    public static func getCurrentDate() -> String {
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        let formattedDate = dateFormatter.string(from: currentDate)
        
        return formattedDate
    }
    
    
    public static func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    public static func generateSelectionFeedback() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.prepare()
        selectionFeedback.selectionChanged()
    }
    
    public static func truncateContent(_ content: String) -> NSAttributedString {
        let fullText = NSMutableAttributedString()

        if content.count > Constants.maxCharactersToShow {
            let truncatedText = String(content.prefix(Constants.maxCharactersToShow))
            let seeMoreText = " ...more"

            let truncatedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black, // You can set the color you want for truncated text
            ]

            let seeMoreAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: AppColors.appBlue, // Set the color to blue
//                .underlineStyle: NSUnderlineStyle.single.rawValue, // Optional: Add underline
            ]

            let truncatedAttributedString = NSAttributedString(string: truncatedText, attributes: truncatedAttributes)
            let seeMoreAttributedString = NSAttributedString(string: seeMoreText, attributes: seeMoreAttributes)

            fullText.append(truncatedAttributedString)
            fullText.append(seeMoreAttributedString)
        } else {
            fullText.append(NSAttributedString(string: content))
        }

        return fullText
    }
    
    public static func configWithMenuStyle() -> FTConfiguration {
        let config = FTConfiguration()
        config.backgoundTintColor = UIColor.white
        config.borderColor = UIColor.lightGray
        config.menuWidth = 80
        config.menuSeparatorColor = UIColor.lightGray
        config.menuRowHeight = 40
        config.cornerRadius = 6
        config.textColor = UIColor.black
        config.textAlignment = NSTextAlignment.center
        return config
    }
    
}
