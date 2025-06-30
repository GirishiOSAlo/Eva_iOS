//
//  ProfileVC.swift
//  EvaConnect
//
//  Created by Metis on 21/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
import IHProgressHUD

class ProfileVC: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var sector: UILabel!
    @IBOutlet weak var userDataThird: UILabel!
    @IBOutlet weak var totalConnectionLbl: UILabel!
    @IBOutlet weak var locationLBl: UILabel!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var showingMenu: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var imageBorder: UIView!

    //MARK: VARIABLES
    var dashBoardGetter: HomePostModel?
    var getId: Int?
    var postId: Int?
    var PostDataModel: PostModel?
    var showMenuCheck = false
    var profileSettings: [ProfileData] = []
    var homePostType: HomePosts?
    var homeProfileType = 2
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserInfo()
        setLayout()
    }
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileVC {
    
    @IBAction func blockUser(_ sender: Any) {
  
    }
    @IBAction func removeUser(_ sender: Any) {

    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSettings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileSetting = profileSettings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.titleLbl.text = profileSetting.title
        cell.cellImage.image = profileSetting.userImage
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bindData = profileSettings[indexPath.row]
        switch bindData.title {
        case "Notification":
            if let navVC = tabBarController?.viewControllers![2] as? UINavigationController,
                let chatListVC =  navVC.viewControllers[0] as? ChatListVC {
                
                if tabBarController?.selectedIndex != 2 {
                    
                    chatListVC.dataType = .notifications
                    tabBarController?.selectedIndex = 2
                    
                } else {
                    
                    chatListVC.segmentControl.selectedSegmentIndex = 1
                    chatListVC.dataType = .notifications
                    chatListVC.tableView.reloadData()
                }
            }
        case "Edit Details":
            performSegue(withIdentifier: Constants.Segues.editProfile, sender: nil)
        case "Settings":
            performSegue(withIdentifier: Constants.Segues.settings, sender: nil)
        case "Disconnect":
            removeConnection()
        case "Block":
             blockConnection()
        default:
            break
        }
    }
}

extension ProfileVC {

    func setLayout() {
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileImage.layer.cornerRadius =  (profileImage.layer.frame.width)/2
        connectBtn.layer.cornerRadius =  (connectBtn.layer.frame.height)/2
        sector.layer.cornerRadius = (sector.frame.height)/2
        (sector as? HeadingTwoBold)?.textColor = AppColors.dullRed
        buttonCustomization(actionBtn: self.connectBtn,setClipsBound:false,borderColor: Constants.AppColorLiteral.signUpNew,addBorder: true)
        imageBorder.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew)
        
    }
    
    func setLayDataForUser(getUserData: EvaUser) {

        if getUserData.userImage != nil {
            if getUserData.isLinkedin == 0 {
                profileImage.sd_setImage(with: URL(string: (getUserData.userImage)!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
            }
            else{
                if getUserData.linkedinImageURL != nil{
                    profileImage.sd_setImage(with: URL(string: (getUserData.linkedinImageURL)!), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
                }
                else{
                    profileImage.image = #imageLiteral(resourceName: "noImage")
                }
            }
        }
        else {
            profileImage.image = #imageLiteral(resourceName: "noImage")
        }
        
        let fullName = "\(getUserData.firstName)  \(getUserData.lastName ?? "")"
        userName.text = fullName
        designation.text = getUserData.designation ?? "No Designation"
        sector.text = "\(getUserData.sector ?? "No Sector") | \(getUserData.companyName ?? "No Company")"
        if getUserData.city.isNilOrEmpty  && getUserData.country.isNilOrEmpty {
             locationLBl.text = "No Address"
        }
        else{
            locationLBl.text = "\(getUserData.city ?? ""),\(getUserData.country ?? "")"
        }
        totalConnectionLbl.text = "\(getUserData.connectionCount ?? 0)"
        connectBtn.isHidden = true
        
    }
    //MARK:-LAYOUT DATA SETTING
    func setLayDataForOther(modelSetter: HomePostModel) {
        if modelSetter.user?.userImage != nil {
            profileImage.sd_setImage(with: URL(string: modelSetter.user?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
        } else {
            profileImage.image = #imageLiteral(resourceName: "noImage")
        }
        designation.text = modelSetter.user?.designation ?? "No Designation Selected"
        sector.text = "\(modelSetter.user?.sector ?? "No Sector Selected") | \(modelSetter.user?.companyName ?? "No Company Selected")"
        //userDataThird.text =
        let fullName = "\(modelSetter.user?.firstName ?? "") \(modelSetter.user?.lastName ?? "")"//+
        userName.text = fullName
        locationLBl.text = "\(modelSetter.user!.city.stringValue),\(modelSetter.user!.country.stringValue)"
        
        totalConnectionLbl.text = "\(modelSetter.user?.totalConnection ?? 0)"
        
        let bindData = modelSetter
        
        if bindData.userID != LoggedUserDetails.shared.user!.id {
            connectBtn.isHidden = false
            if bindData.isConnected == .deleted {
                connectBtn.isHidden = true
            }
            if bindData.isConnected == .notConnected {
                connectBtn.isUserInteractionEnabled = true
                connectBtn.setTitle("Connect", for: .normal)
                connectBtn.addTarget(self, action:#selector(createConnection(sender:)), for: .touchUpInside)
            }
            else if bindData.isConnected == .pending && bindData.isReceiver == false {
                connectBtn.setTitle("Pending", for: .normal)
                connectBtn.isUserInteractionEnabled = false
            }
            else if bindData.isConnected == .pending && bindData.isReceiver == false {
                connectBtn.setTitle("Pending", for: .normal)
                connectBtn.isUserInteractionEnabled = false
            }
            else if bindData.isConnected == .pending && bindData.isReceiver == true {
                connectBtn.setTitle("Accept", for: .normal)
                connectBtn.isUserInteractionEnabled = true
                connectBtn.addTarget(self, action:#selector(updateConnection(sender:)), for: .touchUpInside)
            }
            else if bindData.isConnected == .active {
                connectBtn.setTitle("Connected", for: .normal)
                connectBtn.isUserInteractionEnabled = false
            }
            
        }
        else {
            connectBtn.isHidden = true
        }
    }
    
    func setLayDataForOtherType(modelSetter: HomePosts?) {
        if modelSetter != nil {
            if modelSetter!.user?.userImage != nil {
                profileImage.sd_setImage(with: URL(string: modelSetter!.user?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
            }
            else {
                profileImage.image = #imageLiteral(resourceName: "noImage")
            }
            designation.text = modelSetter?.user?.designation ?? "No Designation Selected"
            sector.text = "\(modelSetter?.user?.sector ?? "No Sector Selected") | \(modelSetter?.user?.companyName ?? "No Company Selected")"
            //userDataThird.text =
            let fullName = "\(modelSetter?.user?.firstName ?? "") \(modelSetter?.user?.lastName ?? "")"//+
            userName.text = fullName
            if modelSetter!.user!.city.isNilOrEmpty  && modelSetter!.user!.country.isNilOrEmpty {
                 locationLBl.text = "No Address"
            }
            else{
            locationLBl.text = "\(modelSetter!.user!.city ?? ""),\(modelSetter!.user!.country ?? "")"
            }
            totalConnectionLbl.text = "\(modelSetter?.user?.totalConnection ?? 0)"
            let bindData = modelSetter
            
            if bindData?.userID != LoggedUserDetails.shared.user!.id {
                connectBtn.isHidden = false
                if bindData?.isConnected == .deleted {
                    connectBtn.isHidden = true
                }
                if bindData?.isConnected == .notConnected {
                    connectBtn.isUserInteractionEnabled = true
                    connectBtn.setTitle("Connect", for: .normal)
                    connectBtn.addTarget(self, action:#selector(createConnection(sender:)), for: .touchUpInside)
                } else if bindData?.isConnected == .pending && bindData?.isReceiver == false {
                    connectBtn.setTitle("Pending", for: .normal)
                    connectBtn.isUserInteractionEnabled = false
                } else if bindData?.isConnected == .pending && bindData?.isReceiver == true {
                    connectBtn.setTitle("Accept", for: .normal)
                    connectBtn.isUserInteractionEnabled = true
                    connectBtn.addTarget(self, action:#selector(updateConnection(sender:)), for: .touchUpInside)
                } else if bindData?.isConnected == .active {
                    connectBtn.setTitle("Connected", for: .normal)
                    connectBtn.isUserInteractionEnabled = false
                }
            } else {
                connectBtn.isHidden = true
            }
        }
    }
    
    //MARK: CUSTOM FUNCTION
    @objc func createConnection(sender: UIButton) {

        let bindData = dashBoardGetter
        if bindData != nil {
            if bindData!.isConnected == .notConnected{
                addConnection(receiverId: bindData!.id)
            }
        }
    }
    
    @objc func updateConnection(sender: UIButton) {

        let bindData = dashBoardGetter
        if bindData!.isConnected == .pending && bindData!.isReceiver == true {
            //Working
            updateConnection(otherID: bindData!.connectionID!)
            sender.isUserInteractionEnabled = true
        }
        print("ButtonIndex\(sender.tag)")
    }
    
    @objc func removeConnection(){
        if homeProfileType == 0 {
            let  bindData = homePostType
            if  !bindData.isNil {
                if bindData!.connectionID != nil {
                    deleteConnection(otherID: (bindData?.connectionID!)!)
                }
                else{
                    makeAlert(titleMsg: "Sorry", messageData: "User Not Connected")
                }
            }
            else {
                makeAlert(titleMsg: "Sorry", messageData: "User Not Connected")
            }
        }
        else {
            let  bindData = dashBoardGetter
            if  !bindData.isNil {
                if bindData!.connectionID != nil {
                    deleteConnection(otherID: (bindData?.connectionID!)!)
                }
                else{
                    makeAlert(titleMsg: "Sorry", messageData: "User Not Connected")
                }
            }
            else {
                makeAlert(titleMsg: "Sorry", messageData: "User Not Connected")
            }
            
        }
    }
    
    @objc func blockConnection() {
        if homeProfileType == 0 {
            let  bindData = homePostType
            if  !bindData.isNil {
                blockConnection(otherID: bindData!.user!.id)
            }
        }
        else {
            let bindData = dashBoardGetter
            if !bindData.isNil {
                blockConnection(otherID:  bindData!.user!.id ?? 0)
            }
        }
    }
    
    func fetchUserInfo() {
        if getId == nil {
            
            profileSettings = [ProfileData(userImage: #imageLiteral(resourceName: "ProfileNotification"), title: "Notification"),
                               ProfileData(userImage: #imageLiteral(resourceName: "EditProfileIcon"), title: "Edit Details"),
                               ProfileData(userImage: #imageLiteral(resourceName: "ProfileSetting"), title: "Settings")]
            self.setLayDataForUser(getUserData: LoggedUserDetails.shared.user!)
        } else {
           if getId == LoggedUserDetails.shared.user!.id {
                          profileSettings = [ProfileData(userImage: #imageLiteral(resourceName: "ProfileNotification"), title: "Notification"),
                                             ProfileData(userImage: #imageLiteral(resourceName: "EditProfileIcon"), title: "Edit Details"),
                                             ProfileData(userImage: #imageLiteral(resourceName: "ProfileSetting"), title: "Settings")]
                              self.setLayDataForUser(getUserData: LoggedUserDetails.shared.user!)

                      }
                      else {
                          profileSettings = [ProfileData(userImage: #imageLiteral(resourceName: "UserMessage"), title: "Message"),
                                             ProfileData(userImage: #imageLiteral(resourceName: "UserDisconnect"), title: "Disconnect"),
                                             ProfileData(userImage: #imageLiteral(resourceName: "UserBlock"), title: "Block")]
                          
                          if homeProfileType == 0 {
                              setLayDataForOtherType(modelSetter:homePostType)
                          } else {
                              setLayDataForOther(modelSetter: dashBoardGetter!)
                          }
                      }
        }
    }
    
    //MARK: API CALLER
    
    private func addConnection(receiverId: Int) {
        
        let parameters: AFParameters = [ "receiver_id" : receiverId,
                                         "sender_id" : LoggedUserDetails.shared.user!.id,
                                         "status": "pending" ]
        
        showActivity()
        NetworkManagerr.request(EndPoints.addConnection, method: .post, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                
                self.hideActivity()
                let jsonDecoder = JSONDecoder()
                
                do {
                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericRoot.error {
                        print(genericRoot.message)
                    }
                } catch {
                    self.presentAlert("Error", nil, response.error)
                }
            }
        }
    }
    
    private func updateConnection(otherID: Int) {

        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myCurrentDate = formatter.string(from: currentDateTime)
        print(myCurrentDate)
        var param:Parameters = [:]
        param = [
            "modified_by_id":LoggedUserDetails.shared.user!.id,
            "status":"active",
            "modified_datetime": myCurrentDate
        ]
        print("param:\(param)\n\(LoggedUserDetails.shared.token!)\n\(LoggedUserDetails.shared.user!.id)")
        IHProgressHUD.show()
        ApiCallerClass.updateConnectionServiceFunc(usertoken: LoggedUserDetails.shared.token!,
                                                   connectionID: otherID,
                                                   para: param,
                                                   success: { (dataRespose) in
                                                    print(dataRespose)
                                                    let data = dataRespose as? NSDictionary
                                                    let error = data?["error"] as? Int
                                                    
                                                    IHProgressHUD.dismiss()
                                                    self.view.isUserInteractionEnabled = true
                                                    if error == 0 {

                                                        self.makeAlert2(messageData: "Your Connection is Block Successfully")
                                                        self.view.isUserInteractionEnabled = true
                                                    }
                                                    else{
                                                        self.makeAlert(messageData:data?["message"] as! String)

                                                        self.view.isUserInteractionEnabled = true
                                                    }
        })
        { (error) in
            
            IHProgressHUD.dismiss()
            print(error.localizedDescription)

            self.view.isUserInteractionEnabled = true
            
        }
    }
    
    private func deleteConnection(otherID: Int) {
        let getToken = LoggedUserDetails.shared.user!.token
        
        IHProgressHUD.show()
        ApiCallerClass.deleteConnectionServiceFunc(usertoken: getToken!,
                                                   connectionID: otherID,
                                                   success: { (dataRespose) in
                                                    
                                                    print(dataRespose)
                                                    let data = dataRespose as? NSDictionary
                                                    let error = data?["error"] as? Int
                                                    IHProgressHUD.dismiss()
                                                    self.view.isUserInteractionEnabled = true
                                                    
                                                    if error == 0{

                                                        self.makeAlert2(messageData: "Your Connection is Remove Successfully")
                                                        self.view.isUserInteractionEnabled = true
                                                    }
                                                    else{
                                                        self.makeAlert(messageData:data?["message"] as! String)

                                                        self.view.isUserInteractionEnabled = true
                                                    }
        })
        { (error) in
            IHProgressHUD.dismiss()
            print(error.localizedDescription)

            self.view.isUserInteractionEnabled = true
            
        }
    }
    
    private func blockConnection(otherID: Int) {
        let parameters: AFParameters = [ "receiver_id" : otherID,
                                         "sender_id" : LoggedUserDetails.shared.user!.id,
                                         "status": "deleted" ]
        
        NetworkManagerr.request(EndPoints.blockConnection, method: .post, parameters: parameters) { (response) in
            
            if response.result.isSuccess {
                let data = response.result.value as? NSDictionary
                let error = data?["error"] as? Int
                IHProgressHUD.dismiss()
                self.view.isUserInteractionEnabled = true
                if error == 0 {
                    self.makeAlert2(messageData: "Connection is Block Successfully")
                    self.view.isUserInteractionEnabled = true
                }
                else {
                    self.makeAlert(messageData:data?["message"] as! String)
                    self.view.isUserInteractionEnabled = true
                }
                
            } else {
                IHProgressHUD.dismiss()
                //self.makeAlert(messageData:response.data?["message"] as! String)
            }
        }
    }
}

struct ProfileData {
    var userImage: UIImage
    var title: String
}
