//
//  ConnectionViewController.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 07/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit
import Lottie

enum TypeConectionEnum: String {
    case Followers
    case Following
    case Requests
}

class ConnectionViewController: UIViewController, XIBed {
    
    @IBOutlet weak var searchMainView: UIView!
    @IBOutlet weak var searchBaseVw: UIView!
    @IBOutlet weak var searchTxtField: UITextField!
    
    @IBOutlet weak var followerBtn: UIButton!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var requestBtn: UIButton!
    
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var listCollectionVw: UICollectionView!
    
    @IBOutlet weak var successPopupVw: UIView!
    @IBOutlet weak var successSubPopupVw: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titlePopupLbl: UILabel!
    @IBOutlet weak var okPopupBtn: UIButton!
    var animationView: LottieAnimationView!
    
    var type: TypeConectionEnum = .Followers
    
    var delegatesDetails: DelegatesDetails?
    var list: [Follower] = [] {
        didSet {
            let count = list.count
            if count > 0 {
                self.noRecordLbl.isHidden = true
            } else {
                self.noRecordLbl.isHidden = false
            }
            self.listCollectionVw.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSearchBtnTapped(_ sender: UIButton) {
        self.searchTxtField.text = ""
        self.searchMainView.isHidden = false
    }
    
    @IBAction func searchCloseBtnTapped(_ sender: UIButton) {
        self.searchTxtField.text = ""
        self.searchMainView.isHidden = true
        self.searchTxtField.resignFirstResponder()
    }
    
    func setupUI() {
        self.searchMainView.isHidden = true
        self.searchBaseVw.layer.cornerRadius = 8
        self.searchBaseVw.layer.borderColor = UIColor(hex: "#837A88").cgColor
        self.searchBaseVw.layer.borderWidth = 1
        self.searchMainView.isHidden = true
        self.searchTxtField.delegate = self
        self.searchTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.successPopupVw.isHidden = true
        self.successSubPopupVw.cornerRadius = 20.0
        self.titlePopupLbl.font = UIFont(name: Myfonts.bold, size: 20)
        self.okPopupBtn.cornerRadius = 14.0
        self.okPopupBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16)
        
        listCollectionVw.registerNib(cellNib: FollowersCVC.self)
        listCollectionVw.delegate = self
        listCollectionVw.dataSource = self
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
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
    @IBAction func onFollowersBtnTap(_ sender: UIButton) {
        self.followersBtnSelected()
        self.type = .Followers
        self.list = self.delegatesDetails?.followers ?? []
    }
    
    @IBAction func onFollowingBtnTap(_ sender: UIButton) {
        self.followingBtnSelected()
        self.type = .Following
        self.list = self.delegatesDetails?.following ?? []
    }
    
    @IBAction func onRequestsBtnTap(_ sender: UIButton) {
        self.requestsBtnSelected()
        self.type = .Requests
        self.list = self.delegatesDetails?.request ?? []
    }
}

//MARK: TextField Delegates
extension ConnectionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool{
        self.view.isUserInteractionEnabled = true
        return true
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        print(textfield.text ?? "")
    }
}

extension ConnectionViewController {
    func followersBtnSelected() {
        self.followerBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        self.followerBtn.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
        self.followingBtn.titleLabel?.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.followingBtn.setTitleColor(UIColor(hex: "#707070"), for: .normal)
        self.requestBtn.titleLabel?.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.requestBtn.setTitleColor(UIColor(hex: "#707070"), for: .normal)
    }
    
    func followingBtnSelected() {
        self.followerBtn.titleLabel?.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.followerBtn.setTitleColor(UIColor(hex: "#707070"), for: .normal)
        self.followingBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        self.followingBtn.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
        self.requestBtn.titleLabel?.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.requestBtn.setTitleColor(UIColor(hex: "#707070"), for: .normal)
    }
    
    func requestsBtnSelected() {
        self.followerBtn.titleLabel?.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.followerBtn.setTitleColor(UIColor(hex: "#707070"), for: .normal)
        self.followingBtn.titleLabel?.font = UIFont(name: Myfonts.regular, size: 14.0)
        self.followingBtn.setTitleColor(UIColor(hex: "#707070"), for: .normal)
        self.requestBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 14.0)
        self.requestBtn.setTitleColor(UIColor(hex: "#4D76CD"), for: .normal)
    }
}

extension ConnectionViewController {
    func fetchData() {
        showActivity()
        let url = "\(EndPoints.followersData)"
        
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
                let response = try JSONDecoder().decode(FollowersDataModel.self, from: data)
                //print(response)
                self.delegatesDetails = response.data?.delegatesDetails
                if self.type == .Followers {
                    self.onFollowersBtnTap(self.followerBtn)
                } else if self.type == .Following {
                    self.onFollowingBtnTap(self.followingBtn)
                } else if self.type == .Requests {
                    self.onRequestsBtnTap(self.requestBtn)
                }
            } catch {
                print(error)
                self.presentAlert("Error", nil, error.localizedDescription as? Error)
            }
        }
    }
    
    func userAcceptReject(connection_id: Int, action: String) {
        //action : "accept" & "reject"
        let url = EndPoints.userAcceptReject
        let parameters = [
            "connection_id" : connection_id,
            "action": action ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let res = try jsonDecoder.decode(AcceptRejectDataModel.self, from: response.data!)
                if !(res.error ?? false) {
                    self.successPopupVw.isHidden = false
                    self.addAnimation()
                    if action == "accept" {
                        self.titlePopupLbl.text = "User Accepted Successfully."
                    } else {
                        self.titlePopupLbl.text = "User Rejected Successfully."
                    }
                    self.fetchData()
                } else {
                    print("Error :: \(res.message ?? "Default Message")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
    
    func userFollowUnfollow(receiverId: Int, status: Int) {
        //Status : 2 = follow , 6 = unfollow
        let url = EndPoints.userFollowUnfollow
        let parameters = [
            "receiverId" : receiverId,
            "status": status ] as [String: Any]
        
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let res = try jsonDecoder.decode(DataStringResponse.self, from: response.data!)
                if !(res.error ?? false) {
                    self.successPopupVw.isHidden = false
                    self.addAnimation()
                    self.titlePopupLbl.text = res.data ?? "Default Message"
                    self.fetchData()
                } else {
                    print("Error :: \(res.message ?? "Default Message")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}

//MARK: UICollection Delegate & DataSource....
extension ConnectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listCollectionVw.dequeueReusableCell(withReuseIdentifier: FollowersCVC.ReuseId, for: indexPath) as! FollowersCVC
        
        let obj = self.list[indexPath.row]
        cell.setData(obj: obj)
        
        cell.gotoProfileBtn.tag = indexPath.row
        cell.gotoProfileBtn.addTarget(self, action: #selector(gotoProfileTapped(sender:)), for: .touchUpInside)
        cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action: #selector(followTapped(sender:)), for: .touchUpInside)
        cell.unfollowBtn.tag = indexPath.row
        cell.unfollowBtn.addTarget(self, action: #selector(unfollowTapped(sender:)), for: .touchUpInside)
        cell.acceptBtn.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(acceptTapped(sender:)), for: .touchUpInside)
        cell.rejectBtn.tag = indexPath.row
        cell.rejectBtn.addTarget(self, action: #selector(rejectTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let obj = self.list[indexPath.row]
        let width = self.view.frame.width - 250.0
        let nameLblHeight = self.heightForView(text: obj.firstName ?? "", font: UIFont(name: Myfonts.bold, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: width)
        let designationLblHeight = self.heightForView(text: obj.designation ?? "", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 16.0), width: width)
        let companyLblHeight = self.heightForView(text: obj.companyName ?? "", font: UIFont(name: Myfonts.regular, size: 12.0) ?? UIFont.systemFont(ofSize: 16.0), width: width)
        let totalHeight = nameLblHeight + designationLblHeight + companyLblHeight + 54.0
        
        return CGSize(width: self.listCollectionVw.frame.size.width, height: totalHeight)
    }
}

extension ConnectionViewController {
    @objc func gotoProfileTapped(sender: UIButton) {
        let obj = list[sender.tag]
        let vc = StoryboardRouter.othersProfileVC()
        vc.profileID = obj.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func followTapped(sender: UIButton) {
        let obj = list[sender.tag]
        self.userFollowUnfollow(receiverId: obj.id ?? 0, status: 2)
    }
    
    @objc func unfollowTapped(sender: UIButton) {
        let obj = list[sender.tag]
        self.userFollowUnfollow(receiverId: obj.id ?? 0, status: 6)
    }
    
    @objc func acceptTapped(sender: UIButton) {
        let obj = list[sender.tag]
        self.userAcceptReject(connection_id: obj.id ?? 0, action: "accept")
    }
    
    @objc func rejectTapped(sender: UIButton) {
        let obj = list[sender.tag]
        self.userAcceptReject(connection_id: obj.id ?? 0, action: "reject")
    }
}
