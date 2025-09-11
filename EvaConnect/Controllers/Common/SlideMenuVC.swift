//
//  SlideMenuVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/24/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import SDWebImage

protocol SlideMenuVCDelegate {
    func didSelect(menu: String)
    func didLogout()
    func didClose()
    func didSearch()
}

class SlideMenuVC: UIViewController {

    @IBOutlet weak var logoutBottomConst: NSLayoutConstraint!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var notificationsLbl: UILabel!
    @IBOutlet weak var connectionsLbl: UILabel!
    @IBOutlet weak var viewProfileLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageBorderView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var connectionStackView: UIStackView!
    @IBOutlet weak var viewProfileBtn: UIButton!
    @IBOutlet weak var notificationStackView: UIStackView!
    @IBOutlet weak var connectionTextLbl: UILabel!
    
    
    private var items = [String]()
    private var user = LoggedUserDetails.shared.user
    private var contentViewTapGesture: UITapGestureRecognizer!
    
    var delegate: SlideMenuVCDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setItemsData()
        //setUserData()
        setTableView()
        setupTapGesture()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fetchUserDetail()
        fetchUserDetailsData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        baseView.roundCorners([.topRight, .bottomRight], radius: 20)
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) { delegate?.didSearch() }
    @IBAction func closeBtnTapped(_ sender: Any) { delegate?.didClose() }
    @IBAction func logoutBtnTapped(_ sender: Any) { delegate?.didLogout() }
    
    @objc func connectionTapped() {
        delegate?.didClose()
        let vc = StoryboardRouter.connectionVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func notificationTapped() {
        delegate?.didClose()
        let vc = DashboardTabbarVC.instantiate()
        vc.tabType = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func viewProfileTapped(_ sender: UIButton) {
        delegate?.didClose()
        let vc = DashboardTabbarVC.instantiate()
        vc.tabType = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SlideMenuVC {
    
    private func setLayout() {
        logoutBtn.layer.cornerRadius = 14.0
        connectionTextLbl.text = isIndivisualUser ? "Connections" : "Followers"
        imageBorderView.applyBorderWithRadius(color: AppColors.appBlue, value: 1, radius: imageBorderView.bounds.width / 2)
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        searchBtn.isHidden = true
        searchBtn.setImage(UIImage(named: "TopSearch")!, for: .normal)
        closeBtn.setImage(UIImage(named: "Close")!, for: .normal)
        searchBtn.setTitle(" ", for: .normal)
        closeBtn.setTitle(" ", for: .normal)
        contentViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeBtnTapped(_:)))
        contentViewTapGesture.delegate = self
        contentView.addGestureRecognizer(contentViewTapGesture)
        if !UIDevice.current.hasNotch { logoutBottomConst.constant = 0 }
    }
    
    private func setUserData() {
        if isIndivisualUser {
            nameLbl.text = myUserDefaults.fullName
        } else {
            nameLbl.text = myUserDefaults.companyName
        }
        viewProfileLbl.text = "View Profile"
//        if let url = URL(string: myUserDefaults.userImage) { profileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profile")) }
        
        let imageUrl = myUserDefaults.userImage
        if !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            self.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            self.profileImageView.image = UIImage(named: "profile")
        }
    }
    
    private func setupTapGesture(){
        let connectionTapGesture = UITapGestureRecognizer(target: self, action: #selector(connectionTapped))
        connectionStackView.isUserInteractionEnabled = true
        connectionStackView.addGestureRecognizer(connectionTapGesture)
        
        let connectionTapGesture2 = UITapGestureRecognizer(target: self, action: #selector(notificationTapped))
        notificationStackView.isUserInteractionEnabled = true
        notificationStackView.addGestureRecognizer(connectionTapGesture2)
    }
    
}

extension SlideMenuVC {
    
    private func setItemsData() {
//        let isUser = user?.type == "user"
//        items.append(contentsOf: [
//            (title: "My Activity", image: #imageLiteral(resourceName: "MyActivity")),
//            (title: "Calender", image: #imageLiteral(resourceName: "MyCalander")),
//            (title: "Settings", image: #imageLiteral(resourceName: "settings"))
//            //(title: "Calender \(isUser ? "" : "and Events")", image: #imageLiteral(resourceName: "MyCalander")),
//            //(title: isUser ? "Job Listings" : "My Jobs", image: #imageLiteral(resourceName: "MyJobListing"))
//        ])
        
        items = [
            "Home",
            "Events",
            "Meetings",
            "News",
            "Jobs",
            "Posts",
            "My Schedule",
            "Blocklist",
            "Change Password",
            "Settings",
            "FAQs",
            "Help"]
    }
    
    private func setTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
    }
    
}

extension SlideMenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "side_menu_cell", for: indexPath) as! NewSlideMenuCell
        cell.nameLbl.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

extension SlideMenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelect(menu: items[indexPath.row])
    }
}

extension SlideMenuVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        (touch.view?.isDescendant(of: tableView) ?? false) ? false : true
    }
}

extension SlideMenuVC {
    
    private func fetchUserDetail() {
        ProfileManager.shared.fetchUserDetail(userId: user?.id ?? 0, showLoader: false) { user, error in
            if let error = error {
                self.presentAlert("Error", error)
            } else if let user = user {
                self.user = user
                LoggedUserDetails.shared.updateUser(userModel: user)
                self.setUserData()
            } else {
                self.presentAlert("Error", "Unable to fetch user details")
            }
        }
        
//        EvaNotificationHandler.shared.numberOfUnreadMessages { [weak self] (count) in
//            guard let strongSelf = self else { return }
//            strongSelf.notificationsLbl.text = "\(count ?? 0)"
//        }
    }
    
    func fetchUserDetailsData() {
        showActivity()
        let url = "\(EndPoints.userDetail)"
        
        NetworkManagerr.request(url, method: .get) { (response) in
            self.hideActivity()
            guard response.result.isSuccess else {
                self.presentAlert("Error", nil, response.error?.localizedDescription as? Error)
                return
            }

            guard let data = response.data else {
                self.presentAlert("Error", nil, "No data received." as? Error)
                return
            }

            do {
                let response = try JSONDecoder().decode(UserDetailsDataModel.self, from: data)
                print(response)
                if let user = response.data?.first {
                    //Save changes.....
                    myUserDefaults.fullName = user.firstName ?? ""
                    myUserDefaults.companyName = user.companyName ?? ""
                    myUserDefaults.userImage = user.userImage ?? ""
                    self.setUserData()

                } else {
                    self.presentAlert("Error", nil, response.message as? Error)
                }
            } catch {
                print(error)
                self.presentAlert("Error", nil, error.localizedDescription as? Error)
            }
        }
    }
    
}
