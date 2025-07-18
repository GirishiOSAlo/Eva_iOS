//
//  ProfileVC.swift
//  EvaConnect
//
//  Created by Metis on 21/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

class ProfileVC: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var sector: UILabel!
    @IBOutlet weak var totalConnectionLbl: UILabel!
    @IBOutlet weak var locationLBl: UILabel!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var imageBorder: UIView!

    //MARK: VARIABLES
    var connectionDetail: DashboardItem?
    var userId: Int!
    var profileSettings: [ProfileData] = []
    var homePostType: HomePosts?
    var userDetail: EvaUser?
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayout()
    }
}

extension ProfileVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditProfileVC, let userDetail = sender as? EvaUser  {
            destination.userDetail = userDetail
        }
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileSettings.count
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
            navigateToNotifiations()
        case "Edit Details":
            performSegue(withIdentifier: Constants.Segues.editProfile, sender: userDetail)
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
        
        if userId.isNil {
            userId = myUserDefaults.userId  //LoggedUserDetails.shared.user!.id
        }
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileImage.roundOnly()
        connectBtn.layer.cornerRadius =  (connectBtn.layer.frame.height)/2
        sector.layer.cornerRadius = (sector.frame.height)/2
        (sector as? HeadingTwoBold)?.textColor = AppColors.dullRed
        buttonCustomization(actionBtn: self.connectBtn,setClipsBound:false,borderColor: Constants.AppColorLiteral.signUpNew,addBorder: true)
        imageBorder.makeRoundView(boderColor: Constants.AppColorLiteral.signUpNew)
        fetchUserInfo()

    }
    
    func updateUI(user: EvaUser) {
        userDetail = user
        if user.userImage != nil {
            if user.isLinkedin == 0 {
                profileImage.sd_setImage(with: URL(string: (user.userImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
            } else {
                if user.linkedinImageURL != nil {
                    profileImage.sd_setImage(with: URL(string: (user.linkedinImageURL)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
                } else {
                    profileImage.image = #imageLiteral(resourceName: "profile")
                }
            }
        } else {
            profileImage.image = #imageLiteral(resourceName: "profile")
        }
        
        userName.text = user.fullName
       
       
        if user.city.isNilOrEmpty  && user.country.isNilOrEmpty {
             locationLBl.text = "No Address"
        } else {
            locationLBl.text = "\(user.city ?? ""), \(user.country ?? "")"
        }
        if user.type == "company" {
            designation.text = user.companyName
        }
        else {
            designation.text = user.designation ?? "No Designation"
        }
        totalConnectionLbl.text = "\(user.connectionCount ?? 0)"
        connectBtn.isHidden = true
        otherFieldOption(user: userDetail!)
    }
    
    func updateUI(otherUser: DashboardItem) {
        if otherUser.user?.userImage != nil {
            profileImage.sd_setImage(with: URL(string: otherUser.user?.userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
        } else {
            profileImage.image = #imageLiteral(resourceName: "noImage")
        }
        designation.text = otherUser.user?.designation ?? "No Designation Selected"
        sector.text = "\(otherUser.user?.sector ?? "No Sector Selected") | \(otherUser.user?.companyName ?? "No Company Selected")"
        //userDataThird.text =
        let fullName = "\(otherUser.user?.firstName ?? "") \(otherUser.user?.lastName ?? "")"//+
        userName.text = fullName
        locationLBl.text = "\(otherUser.user!.city.stringValue),\(otherUser.user!.country.stringValue)"
        
        totalConnectionLbl.text = "\(otherUser.user?.totalConnection ?? 0)"
        
        let bindData = otherUser
        
        if bindData.userID != myUserDefaults.userId {  //LoggedUserDetails.shared.user!.id {
            connectBtn.isHidden = false
            if bindData.isConnected == "deleted" {
                connectBtn.isHidden = true
            }
            
            if bindData.isConnected == "not_connected" {
                connectBtn.isUserInteractionEnabled = true
                connectBtn.setTitle("Connect", for: .normal)
                connectBtn.addTarget(self, action:#selector(createConnection(sender:)), for: .touchUpInside)
            }
            else if bindData.isConnected == "pending" && bindData.isReceiver == false {
                connectBtn.setTitle("Pending", for: .normal)
                connectBtn.isUserInteractionEnabled = false
            }
            else if bindData.isConnected == "pending" && bindData.isReceiver == false {
                connectBtn.setTitle("Pending", for: .normal)
                connectBtn.isUserInteractionEnabled = false
            }
            else if bindData.isConnected == "pending" && bindData.isReceiver == true {
                connectBtn.setTitle("Accept", for: .normal)
                connectBtn.isUserInteractionEnabled = true
                connectBtn.addTarget(self, action:#selector(updateConnection(sender:)), for: .touchUpInside)
            }
            else if bindData.isConnected == "active" {
                connectBtn.setTitle("Connected", for: .normal)
                connectBtn.isUserInteractionEnabled = false
            }
        } else {
            connectBtn.isHidden = true
        }
    }
    
    private func otherFieldOption(user: EvaUser) {
        if "Other" == user.sector {
            sector.text = "\(user.otherSector ?? "No Sector") | \(user.companyName ?? "No Company")"
          
        } else {
           
            sector.text = "\(user.sector ?? "No Sector") | \(user.companyName ?? "No Company")"
        }
    }
    //MARK: CUSTOM FUNCTION
    @objc func createConnection(sender: UIButton) {
        
        if connectionDetail!.isConnected == "not_connected" {
            addConnection(id: connectionDetail!.id)
        }
    }
    
    @objc func updateConnection(sender: UIButton) {

        let bindData = connectionDetail
        if bindData!.isConnected == "pending" && bindData!.isReceiver == true {
            //Working
            updateConnection(id: bindData!.connectionID!)
            sender.isUserInteractionEnabled = true
        }
    }
    
    @objc func removeConnection() {
        let  bindData = connectionDetail
        if bindData!.connectionID != nil {
            deleteConnection(id: (bindData?.connectionID!)!)
        } else {
            makeAlert(titleMsg: "Sorry", messageData: "User Not Connected")
        }
    }
    
    @objc func blockConnection() {
        blockConnection(id: connectionDetail!.user?.id ?? 0)
    }
    
    func fetchUserInfo() {
        if userId == LoggedUserDetails.shared.user!.id {
            profileSettings = [ProfileData(userImage: #imageLiteral(resourceName: "ProfileNotification"), title: "Notification"),
                               ProfileData(userImage: #imageLiteral(resourceName: "EditProfileIcon"), title: "Edit Details"),
                               ProfileData(userImage: #imageLiteral(resourceName: "ProfileSetting"), title: "Settings")]
            fetchUserDetail()
            
        } else {
            profileSettings = [ProfileData(userImage: #imageLiteral(resourceName: "UserMessage"), title: "Message"),
                               ProfileData(userImage: #imageLiteral(resourceName: "UserDisconnect"), title: "Disconnect"),
                               ProfileData(userImage: #imageLiteral(resourceName: "UserBlock"), title: "Block")]
            
            
            updateUI(otherUser: connectionDetail!)
        }
    }
}

private extension ProfileVC {
    
    func addConnection(id: Int) {
        
        let parameters: AFParameters = [ "receiver_id": id,
                                         "sender_id": myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id,
                                         "status": "pending" ]
        
        showActivity()
        NetworkManagerr.request(EndPoints.addConnection, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            
            if response.result.isSuccess {
                
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let genericRoot = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if !genericRoot.error {
                        self.presentAlertWithAction(title: "Success", message: "Your connection is created successfully") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } catch {
                    self.presentAlert("Error", nil, response.error)
                }
            }
        }
    }
    
    func updateConnection(id: Int) {
        
        let parameters: AFParameters = [ "modified_by_id": myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id,
                                         "status": "active",
                                         "modified_datetime": Date().toString(formatter: .standardDateWithTime) ]
        
        let endPoint = EndPoints.updateConnection + "\(id)/"
        showActivity()
        NetworkManagerr.request(endPoint, method: .patch, parameters: parameters) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                
              
                self.view.isUserInteractionEnabled = true
                
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    
                    if !genericResponse.error {
                        
                        self.presentAlertWithAction(title: "Success", message: "Connection is blocked successfully") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } catch {
                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
                self.presentAlert("Failure", nil, response.error)
            }
        }
    }
    
    func deleteConnection(id: Int) {
        
        let endPoint = EndPoints.deleteConnection + "\(id)/"
        showActivity()
        
        NetworkManagerr.request(endPoint, method: .delete) { (response) in
            self.hideActivity()
            self.view.isUserInteractionEnabled = true
            
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    
                    if !genericResponse.error {
                        self.presentAlert("Success", "Your Connection is Remove Successfully", nil)
                    }
                } catch {
                    self.presentAlert("Failure", nil, response.result.error)
                }
            }
        }
    }
    
    func blockConnection(id: Int) {
        
        let parameters: AFParameters = [ "receiver_id": id,
                                         "sender_id" : myUserDefaults.userId,  //LoggedUserDetails.shared.user!.id,
                                         "status": "deleted" ]
        
        showActivity()
        NetworkManagerr.request(EndPoints.blockConnection, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                
              
                self.view.isUserInteractionEnabled = true
                
                do {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    
                    if !genericResponse.error {
                        self.presentAlert("Success", "Connection is Block Successfully", nil)
                    }
                } catch {
                    self.presentAlert("Failure", nil, response.error)
                }
            } else {
                self.presentAlert("Failure", nil, response.error)
            }
        }
    }

    func fetchUserDetail() {
      
        showActivity()
        let url = "\(EndPoints.userDetail)\(userId!)/"
        NetworkManagerr.request(url, method: .get) { (response) in
            self.hideActivity()
            if response.result.isSuccess {
                
             
                let jsonDecoder = JSONDecoder()
                
                let loginData = try! jsonDecoder.decode(LoginStruct.self, from:response.data!)
                if !loginData.error {
                    self.updateUI(user: loginData.data!.first!)
                    } else {
                    self.presentAlert("Error", nil, response.error)
                }

            }
            
        }
    }
}

struct ProfileData {
    var userImage: UIImage
    var title: String
}
