//
//  EventDelegateProfileVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 20/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit
import Alamofire

class EventDelegateProfileVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var baseBackView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var professionLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var sheduleMeetingBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var delegateTitleLbl: UILabel!
    @IBOutlet weak var moreOptionBtn: UIButton!
    
    
    var eventId: Int = 0
    var companyName: String = ""
    var companyId: String = ""
    var userId: Int = 0
    var delegateListArr: [EventDelegateProfileDelegateList] = []
    var isChatEnable = true
    
    var completion: ((Int) -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getSettings()
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        self.completion?(3)
        navigationController?.popViewController(animated: true)
    }

    
    func setLayout() {
        self.sheduleMeetingBtn.isHidden = !myUserDefaults.isIndivisualUser
        self.baseBackView.layer.cornerRadius = 13.0
        self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2
        self.profileView.layer.borderWidth = 1
        self.profileView.layer.borderColor = UIColor(hex: "#4D76CD").cgColor

        self.profileImgVw.layer.cornerRadius = self.profileImgVw.frame.size.height/2
        self.sheduleMeetingBtn.layer.cornerRadius = self.sheduleMeetingBtn.frame.size.height/2
        self.messageBtn.layer.cornerRadius = self.messageBtn.frame.size.height/2
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.registerCell(withType: ConnectionCell.self)
        
        self.delegateTitleLbl.text = "Delegates From \(self.companyName)"
        self.fetchDelegateList()
        //self.tblVwHeight.constant = (80.0 * 5)
        
        self.fetchUserDetail(userId: userId) { (user, error) in
            if let user = user {
                self.setUI(for: user)
            }
            
            if let error = error {
                self.presentAlert("Failure", nil, error)
            }
        }
    }
    
    @IBAction func onSheduleMeetingBtnTapped(_ sender: UIButton) {
        presentAlert("Coming Soon!","")
    }
    
    @IBAction func onMessageBtnTapped(_ sender: UIButton) {
        if isChatEnable {
            let chatVC = StoryboardRouter.chat()
            chatVC.userId = self.userId
            navigationController?.pushViewController(chatVC, animated: true)
        } else {
            self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
        }
    }
    
    @IBAction func moreOptionTapped(_ sender: UIButton) {
        
        FTPopOverMenu.showForSender(sender: sender, with: ["Block"], done: { (selectedIndex) -> () in
            
            switch selectedIndex {
            case 0:
                print("Edit")
                self.blockUser(userId: self.userId)
                break
            default:
                break
            }
        })
    }
}

// MARK:
extension EventDelegateProfileVC {
    
    func fetchUserDetail(userId: Int, completion: @escaping (OtherUserData?, Error?) -> Void) {
        
        let url = "\(EndPoints.userDetail)/\(userId)"
        NetworkManagerr.request(url, encoding: JSONEncoding.default) { (response) in
            self.hideActivity()
            
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let userData = try jsonDecoder.decode(OtherUserDataModel.self, from: response.data!)
                    if !(userData.error ?? false), userData.data?.count ?? 0 > 0 {
                        
                        completion(userData.data?[0], nil)
                    }
                    
                } catch {
                    completion(nil, response.result.error)
                }
            } else {
                completion(nil, response.result.error)
            }
            
        }
    }
    
    func fetchDelegateList() {
        let parameters: AFParameters = [ "event_id": self.eventId, "company_id": self.companyId, "id": self.userId]
        showActivity()
        NetworkManagerr.request(EndPoints.eventProfileDelegateList, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let decoder = JSONDecoder()
                let eventDelegate = try decoder.decode(EventDelegateProfileDelegateListRes.self, from: response.data!)
                print("Event Profile Delegate List :: \(eventDelegate.data?.count ?? 0)")
                
                if eventDelegate.data?.count ?? 0 > 0 {
                    self.delegateListArr = eventDelegate.data!
                    self.tblView.reloadData()
                    
                    let count = eventDelegate.data?.count ?? 0
                    self.tblVwHeight.constant = (80.0 * CGFloat(count))
                } else {
                    self.presentAlert("Alert!", "\(eventDelegate.message ?? "Error")")
                }
            } catch {
                print(error)
            }
        }
    }
    
    func blockUser(userId: Int) {
        
        let url = "\(EndPoints.blockUser)"
        print(url)
        
        let param: AFParameters = ["target_user_key": userId]

        NetworkManagerr.request(url, method: .post, parameters: param) { [weak self] (result: Result<GenericResponse>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.error == true {
                    self.presentAlert("Error", response.message)
                }
                
                if response.error == false {
                    //showToast(message: "User Blocked Successfully")
                    let alert = UIAlertController(title: "User Blocked", message: "You can unblock this user anytime from your account settings under 'BlockList'", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                        //Back Button Click.....
                        self.back_touchUpInside(self.backBtn)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let failure):
                self.presentAlert("Error", nil, failure)
            }
        }
    }
    
    private func getSettings() {
        NetworkManagerr.request(EndPoints.settingsOptions) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let newsRoot = try jsonDecoder.decode(SettingsOptionsDataModel.self, from: response.data!)
                self.hideActivity()
                if !(newsRoot.error!) {
                    if let data = newsRoot.data {
                        self.isChatEnable = data[0].privateMessaging ?? true
                    }
                } else {
                    self.presentAlert("Failure", newsRoot.message, nil)
                }
            } catch {
                print("Error: \(error)")
            }
            
        }
    }

    func setUI(for user: OtherUserData?) {
        self.nameLbl.text = user?.firstName
        self.professionLbl.text = "\(user?.designation ?? "") | \(user?.companyName ?? "")"
//        self.onlineStatusDotView.backgroundColor = user?.isConnected == .active ? .green : .red
//        self.onlineStatusLbl.text = user?.isConnected == .active ? "Online" : "Offline"
//        self.onlineStatusLbl.textColor = user?.isConnected == .active ? UIColor.green : UIColor.red
//        self.connectionCountLbl.text = "\(user?.totalConnection ?? 0)"
        self.aboutLbl.text = user?.bioData
        self.profileImgVw.sd_setImage(with: URL(string: (user?.userImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
    }
}


extension EventDelegateProfileVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegateListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConnectionCell.id(), for: indexPath) as! ConnectionCell
        
        cell.addFriendView.isHidden = true
        cell.blockedView.isHidden = true
        cell.pendingView.isHidden = true
        cell.connectedView.isHidden = false
        
        let obj = self.delegateListArr[indexPath.row]
        let imgUrl = obj.userImageURL ?? ""
        if imgUrl.elementsEqual("") {
            cell.userImage.image = UIImage(named: "profile")
        } else {
            cell.userImage.sd_setImage(with: URL(string: imgUrl), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        }
        
        cell.userName.text = "\(obj.firstName ?? "") \(obj.lastName ?? "")"
        cell.userDesignation.text = "\(obj.designation ?? "")"
        
        let isOnline = obj.isOnline ?? false
        if isOnline {
            cell.onlineStatusVw.isHidden = false
        } else {
            cell.onlineStatusVw.isHidden = true
        }

        cell.sendButton.tag = indexPath.row
        cell.sendButton.addTarget(self, action: #selector(sendBtnTapped(sender:)), for: .touchUpInside)

        return cell
    }
    
    @objc private func sendBtnTapped(sender: UIButton) {
        let obj = self.delegateListArr[sender.tag]
        if isChatEnable {
            let chatVC = StoryboardRouter.chat()
            chatVC.userId = obj.id ?? 0
            navigationController?.pushViewController(chatVC, animated: true)
        } else {
            self.presentAlert("Alert", "This action has been disabled, Please contact admin.")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = delegateListArr[indexPath.row].id ?? 0
        
        let vc = StoryboardRouter.othersProfileVC()
        vc.profileID = id
        vc.isFrom = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

