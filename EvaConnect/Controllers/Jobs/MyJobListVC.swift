//
//  MyJobListVC.swift
//  EvaConnect
//
//  Created by Metis on 23/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
//import IHProgressHUD
import ImageSlideshow

class MyJobListVC: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var newJobBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: VARIABLES
    var offSetChanger = 0
    let pageLimit = 20
    var jobList: [JobListModel] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var stopAPICall = false
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
//        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tableView.refreshControl = refresher
//        getJobs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editJobUser = segue.destination as? EditJobUserVC, let jobId = sender as? Int {
            editJobUser.jobId = jobId
//            editJobUser.delegate = self
        }
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension MyJobListVC {
    
    func setLayOut() {
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 120
        giveButtonCorner(actionBtn: newJobBtn,setClipsBound: false, giveShadow:true)
        tableView.registerCell(withType: JobListing.self)
        tableView.registerCell(withType: CompanyJobCell.self)
    }
}

// MARK: Network Calls
//extension MyJobListVC {
//
//    private func getJobs() {
//
//        let parameters: Parameters = ["user_id": LoggedUserDetails.shared.user!.id ?? 0]
//
//        let limit = "?limit=\(pageLimit)"
//        let offset = "&offset=\(offSetChanger)"
//
//        //showActivity()
//        let endPoint = EndPoints.getMyJobListing + limit + offset
//        NetworkManagerr.request(endPoint, method: .post, parameters: parameters) { (response) in
//           // self.hideActivity()
//            self.refresher.endRefreshing()
//            if response.result.isSuccess {
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let jobListRoot = try jsonDecoder.decode(AllJobListing.self, from: response.data!)
//
//                    if !jobListRoot.error, jobListRoot.data.count > 0 {
//                        self.jobList.removeAll()
//                        self.jobList.append(contentsOf: jobListRoot.data)
//                        self.tableView.reloadData()
//                    }
//
//                    if !jobListRoot.error, jobListRoot.data.count == 0 {
//                        self.stopAPICall = true
//                    }
//                } catch {
//                    self.presentAlert("Failure", nil, response.result.error)
//                }
//            }
//        }
//    }
//
//       private func likePost(postId: Int, action: String, index: Int) {
//
//        let parameters: Parameters = [ "job_id": postId,
//                                       "created_by_id": LoggedUserDetails.shared.user!.id ?? 0,
//                                       "status": "active",
//                                       "action": action ]
//
//        NetworkManagerr.request(EndPoints.jobLikePost, method: .post, parameters: parameters) { (response) in
//
//            if response.result.isSuccess {
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let genericResponse = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
//                    if !genericResponse.error {
//                        if action == "like" {
//                            self.jobList[index].isJobLike = 1
//                            self.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
//                        }
//                        else {
//                            self.jobList[index].isJobLike = 0
//                            self.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
//                        }
//                    }
//
//                } catch {
//                    self.presentAlert("failure", nil, error)
//
//                }
//            }
//        }
//    }
//}

//extension MyJobListVC {
//
//    @objc func reloadData() {
//
//        jobList.removeAll()
//        offSetChanger = 0
//        getJobs()
//    }
//
//    @objc func likePost(sender: UIButton) {
//
//        let job = jobList[sender.tag]
//        if job.isJobLike == nil || job.isJobLike == 1 {
//            likePost(postId: job.id, action: "unlike", index: sender.tag)
//        } else {
//            likePost(postId: job.id, action: "like", index: sender.tag)
//        }
//    }
//
//    @objc func navigateToJobList(_ sender: UIButton) {
//
//        let jobVC = StoryboardRouter.jobVC()
//        jobVC.jobId = jobList[sender.tag].id
//        jobVC.navigationType = .comments
//        jobVC.delegate = self
//        self.navigationController?.pushViewController(jobVC, animated: true)
//    }
//
//    @objc func cellBtnAction(sender: UIButton) {
//        //performSegue(withIdentifier: Constants.Segues.editJobUser, sender: jobList[sender.tag].id)
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//              let vc = storyboard.instantiateViewController(withIdentifier: "EditJobUserVC") as! EditJobUserVC
//              vc.jobId = jobList[sender.tag].id
//              vc.delegate = self
//             self.navigationController?.pushViewController(vc, animated: true)
//    }
//}

//extension MyJobListVC: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        jobList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
////        let bindData = jobList[indexPath.row]
////        let cell = tableView.dequeueReusableCell(withIdentifier: JobListing.id(), for: indexPath) as! JobListing
////        cell.companyLbl.text = "\(bindData.jobTitle ?? "") for \(bindData.jobNature ?? "")"
////        cell.jobContentLbl.text = bindData.content
////        cell.designationLbl.text = bindData.position
////        cell.likeBtn.tag = indexPath.row
////        cell.commnetBtn.tag = indexPath.row
////        cell.shareBtn.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
////        cell.openJobBtn.tag = indexPath.row
////        cell.openJobBtn.addTarget(self, action:#selector(cellBtnAction(sender:)), for: .touchUpInside)
////        cell.likeBtn.addTarget(self, action:#selector(likePost(sender:)), for: .touchUpInside)
////        cell.commnetBtn.addTarget(self, action:#selector(navigateToJobList(_:)), for: .touchUpInside)
////
////        cell.likeImage.image = bindData.isJobLike == 1 ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like")
////
////        cell.profileImg.sd_setImage(with:URL(string: (bindData.jobImage!)), placeholderImage: #imageLiteral(resourceName: "noImage"), options: .progressiveLoad, completed: .none)
////
////        return cell
//
//
//        let cell: CompanyJobCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//        cell.jobList = jobList[indexPath.item]
//        cell.goToAd = { [weak self] job in self?.navigateToJobListing(job: job) }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == jobList.count {
//            if !stopAPICall {
//                offSetChanger = jobList.count
//                getJobs()
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
//
//    private func navigateToJobListing(job: JobListModel) {
//        let jobListing = StoryboardRouter.userJobListing()
//        jobListing.job = DashboardItem(id: job.id, userID: job.userID, user: nil, jobTitle: job.jobTitle, jobNature: job.jobNature,
//                                       jobtype: .fullTime, jobSector: job.jobSector, position: job.position, weeklyHours: job.weeklyHours,
//                                       location: job.location, salary: job.salary, content: job.content, jobImage: job.jobImage, attendees: 0,
//                                       commentCount: job.commentCount, applicantCount: job.applicantCount, isJobLike: job.isJobLike,
//                                       isApplied: job.isApplied, likeCount: job.likeCount, createdByID: job.createdByID,
//                                       createdDatetime: job.createdDatetime, modifiedByID: job.modifiedByID, modifiedDatetime: job.modifiedDatetime,
//                                       type: .job, os: job.os, status: job.status, isURL: nil, postVideo: nil, isConnected: nil,
//                                       connectionId: nil, isReceiver: nil, isPostLike: nil, createdDate: job.createdDatetime,
//                                       postImage: nil, connectionID: nil, eventName: nil, eventCity: nil, eventAddress: nil, eventStartDate: nil,
//                                       eventEndDate: nil, isEventLike: nil, eventImage: nil, newsSource: nil, title: nil, summary: nil, author: nil,
//                                       published: nil, link: nil, image: nil, isNewsLike: nil, postDocument: nil, activeHours: 0, connectionCount: 0, shareCount: 0,
//                                       startTime: "", endTime: "", isAttending: "null", saved: 0, tempImage: "", tempImageUser: "", applicationsCount: "0", value: "", evaNewsCategory: nil, documentFileName: "", documentSize: "")
//        navigationController?.pushViewController(jobListing, animated: true)
//    }
//}

//extension MyJobListVC: RefreshUpdateable {
//    func refresh(homeStatus: Bool) {
//        jobList.removeAll()
//        offSetChanger = 0
//        getJobs()
//    }
//}
//extension MyJobListVC {
//
//    @objc func handleShare(_ sender: UIButton) {
//        if jobList.count > 0 {
//            openShareVC(id: jobList[sender.tag].id, type: .job)
//        }
//    }
//}
