//
//  UserNotificationSettingsVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/30/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit
import Alamofire

class UserNotificationSettingsVC: BaseVC {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var notifications = [(item: UserNotificationSetting, selected: Bool)]()
    
    var isValueChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        getNotifications()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        goBack()
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if isValueChanged {
            self.sendNotificationSettings()
        } else {
            goBack()
        }
    }
}

extension UserNotificationSettingsVC {
    
    private func setLayout() {
        self.navigationController?.isNavigationBarHidden = true
        isSeparatorHidden = true
        let item = LoggedUserDetails.shared.user?.type == userType.user.rawValue ? UserNotificationSetting.user : UserNotificationSetting.company
        notifications = item.map({ (item: $0, selected: false) })
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        submitBtn.layer.cornerRadius = 24
    }
    
    private func getNotifications() {
//        let params: AFParameters = ["user_id": "\(LoggedUserDetails.shared.user?.id ?? 0)"]
//        guard let url = params.getURL(EndPoints.addPushNotificationSettings) else { return }
        let url = EndPoints.addPushNotificationSettings
        showActivity()
        NetworkManagerr.request(url) { [weak self] (result: Result<Wrapper<[PushNotificationSettings]>>) in
            guard let self = self else { return }
            self.hideActivity()
            switch result {
            case .success(let rsl):
                if rsl.error {
                    self.presentAlert("Failure", rsl.message, nil)
                } else if let notification = rsl.data.last?.notifications {
                    notification.forEach { (key, value) in
                        if let index = self.notifications.firstIndex(where: { $0.item.apiKey == key }) {
                            self.notifications[index].selected = value == 1
                        }
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                self.presentAlert("Error", nil, error)
            }
        }
    }
    
    func sendNotificationSettings(){
        let notifications: AFParameters = Dictionary(notifications.map({ ($0.item.apiKey, $0.selected ? 1 : 0) })) { first, _ in first }
        let params: AFParameters = ["notifications": notifications, "user_id": LoggedUserDetails.shared.user?.id ?? 0, "status": "active",
                                    "created_datetime": "", "os": "iOS", "created_by": LoggedUserDetails.shared.user?.id ?? 0]
        
        showActivity()
        NetworkManagerr.request(EndPoints.addPushNotificationSettings, method: .post, parameters: params) { [weak self] (result: Result<GenericResponse>) in
            guard let self = self else { return }
            self.hideActivity()
            switch result {
            case .success(let rsl):
//                self.presentAlert(rsl.error ? "Failure" : "Success", rsl.message, nil)
                goBack()
            case .failure(let error):
                self.presentAlert("Error", nil, error)
            }
        }
    }
    
}

extension UserNotificationSettingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { notifications.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PushNotificationCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.indexPath = indexPath
        cell.notification = notifications[indexPath.item]
        cell.pushChanged = { [weak self] (indexPath, isOn) in
            self?.isValueChanged = true
            print("ValueChanged: ",self?.isValueChanged ?? false)
            self?.notifications[indexPath.item].selected.toggle()
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
    
}

extension UserNotificationSettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
