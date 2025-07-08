//
//  UserSettingsVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/30/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import Lottie

class UserSettingsVC: BaseVC {

    @IBOutlet weak var headerLbl: HeadingLabel!
    @IBOutlet weak var tableView: UITableView!
    private var settings = UserSetting.allCases
    
    
    @IBOutlet weak var privateAccountBtn: UIButton!
    @IBOutlet weak var privateTitleLbl: UILabel!
    @IBOutlet weak var privateDescLbl: UILabel!
    
    
    @IBOutlet weak var scheduleNotificationBaseVw: UIView!
    @IBOutlet weak var otherNotificationBaseVw: UIView!
    @IBOutlet weak var conferanceGoalsBaseVw: UIView!
    @IBOutlet weak var responsibilitiesBaseVw: UIView!
    
    @IBOutlet var sectionHeaderlabelCollection: [UILabel]!
    @IBOutlet var responsibilityTitlerlabelCollection: [UILabel]!
    @IBOutlet var labelCollection: [UILabel]!
    
    @IBOutlet weak var successPopupVw: UIView!
    @IBOutlet weak var successSubPopupVw: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titlePopupLbl: UILabel!
    @IBOutlet weak var okPopupBtn: UIButton!
    var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.successPopupVw.isHidden = true
//        if LoggedUserDetails.shared.user?.isCompany ?? false { settings = settings.filter({ $0 != .rss }) }
        if !isIndivisualUser {
            settings = settings.filter({$0 != .rss })
        }
        setLayout()
        setLabelUI()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        goBack()
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) { logOut() }
    
    private func setLayout() {
        self.navigationController?.isNavigationBarHidden = true
//        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        scheduleNotificationBaseVw.layer.cornerRadius = 20.0
        otherNotificationBaseVw.layer.cornerRadius = 20.0
        conferanceGoalsBaseVw.layer.cornerRadius = 20.0
        responsibilitiesBaseVw.layer.cornerRadius = 20.0
        
        self.successSubPopupVw.cornerRadius = 20.0
        self.titlePopupLbl.font = UIFont(name: Myfonts.bold, size: 20)
        self.okPopupBtn.cornerRadius = 14.0
        self.okPopupBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        if myUserDefaults.isPrivate {
            self.privateAccountBtn.isSelected = true
        } else {
            self.privateAccountBtn.isSelected = false
        }
    }
    
    func setLabelUI() {
        headerLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        privateTitleLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        privateDescLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        for label in sectionHeaderlabelCollection {
            label.font = UIFont(name: Myfonts.bold, size: 16.0)
        }
        for label in responsibilityTitlerlabelCollection {
            label.font = UIFont(name: Myfonts.bold, size: 14.0)
        }
        for label in labelCollection {
            label.font = UIFont(name: Myfonts.regular, size: 14.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func onPrivateAccountBtn(_ sender: UIButton) {
        if self.privateAccountBtn.isSelected {
            self.privateAccountBtn.isSelected = false
            self.isAccountPrivacyMode(isPrivate: 1) //make Public...
        } else {
            self.privateAccountBtn.isSelected = true
            self.isAccountPrivacyMode(isPrivate: 0) //make Private...
        }
    }
    
    @IBAction func onScheduleNotificationButtons(_ sender: UIButton) {
        if sender.tag == 101 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 102 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 103 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 104 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 105 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 106 {
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func onOtherNotificationButtons(_ sender: UIButton) {
        if sender.tag == 201 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 202 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 203 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 204 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 205 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 206 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 207 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 208 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 209 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 210 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 211 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 212 {
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func onConfernceGoalsButtons(_ sender: UIButton) {
        if sender.tag == 301 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 302 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 303 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 304 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 305 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 306 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 307 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 308 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 309 {
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func onRegionButtons(_ sender: UIButton) {
        if sender.tag == 401 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 402 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 403 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 404 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 405 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 406 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 407 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 408 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 409 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 410 {
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func onHandlingButtons(_ sender: UIButton) {
        if sender.tag == 501 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 502 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 503 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 504 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 505 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 506 {
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func onResponsibilitiesButtons(_ sender: UIButton) {
        if sender.tag == 601 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 602 {
            sender.isSelected.toggle()
        }
        else if sender.tag == 603 {
            sender.isSelected.toggle()
        }
    }
    
    @IBAction func onSuccessOkBtn(_ sender: UIButton) {
        self.successPopupVw.isHidden = true
        self.animationView.stop()
    }
    
    func addAnimation(){
        animationView = LottieAnimationView(name: "successLottie.json")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        animationView.center = animationContainerView.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationContainerView.addSubview(animationView)
        animationView.play()
    }
}

extension UserSettingsVC {
    
    func isAccountPrivacyMode(isPrivate: Int) {
        let url = EndPoints.privacyMode
        let parameters = ["is_public": isPrivate] as [String: Any]
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let privacyRoot = try jsonDecoder.decode(DataStringResponse.self, from: response.data!)
                if !(privacyRoot.error ?? false) {
                    self.successPopupVw.isHidden = false
                    self.addAnimation()
                    self.titlePopupLbl.text = privacyRoot.data ?? "--"
                    //Set Private & Public value...
                    if isPrivate == 0 {
                        myUserDefaults.isPrivate = true
                    } else {
                        myUserDefaults.isPrivate = false
                    }
                } else {
                    print("Error :: \(privacyRoot.message ?? "Default Message")")
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
}

extension UserSettingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { settings.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EditUserProfileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.title = settings[indexPath.item].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 63 }
    
}

extension UserSettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationController?.navigationBar.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch settings[indexPath.item] {
        case .profile:
            let vc = StoryboardRouter.editUserProfile()
            vc.userDetail = LoggedUserDetails.shared.user
            navigationController?.pushViewController(vc, animated: true)
        case .notification:
            let vc = StoryboardRouter.userNotificationSettings()
            navigationController?.pushViewController(vc, animated: true)
        case .rss:
            let vc = StoryboardRouter.newsSources()
            vc.updateNewsSource = true
            vc.mode = .edit
            navigationController?.pushViewController(vc, animated: true)
        case .blockList:
            let vc = BlockListVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case .security:
            let vc = StoryboardRouter.editPasswordVC()
            navigationController?.pushViewController(vc, animated: true)
        case .help:
            let vc = StoryboardRouter.help()
            vc.section = .help
            navigationController?.pushViewController(vc, animated: true)
        case .language:
            let vc = StoryboardRouter.signUpLocationDOB()
            vc.isFromSettings = true
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .terms:
            let vc = StoryboardRouter.help()
            vc.section = .termsOfServices
            navigationController?.pushViewController(vc, animated: true)
        case .cookies:
            let vc = StoryboardRouter.help()
            vc.section = .cookies
            navigationController?.pushViewController(vc, animated: true)
        case .privacy:
            let vc = StoryboardRouter.help()
            vc.section = .privacy
            navigationController?.pushViewController(vc, animated: true)
        case .account:
            let vc = StoryboardRouter.account()
            
            navigationController?.pushViewController(vc, animated: true)
            print("Coming soon")
        }
        
        
    }
    
}

extension UserSettingsVC: EditUserProfileDelegate {
    
    func didProfileUpdated(item: EditProfile, value: String) {
        
    }
    
}
