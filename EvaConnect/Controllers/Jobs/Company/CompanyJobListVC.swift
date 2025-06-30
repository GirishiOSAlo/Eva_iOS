//
//  CompanyJobListVC.swift
//  EvaConnect
//
//  Created by Metis on 25/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
//import IHProgressHUD
import ImageSlideshow

class CompanyJobListVC: BaseVC {
    
    //MARK: OUTLETS
    @IBOutlet weak var createNewJob: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: VARIABLES
    var offset = 0
    let pageSize = 10
    var jobs: [CompanyJobs] = []
    var isDataLoaded = false
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: VIEW LIFECYLCE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayOut()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCompanyJobs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true
    }
}

// MARK: IB Actions
extension CompanyJobListVC {
    
    @IBAction func createNew_touchUpInside(_ sender: UIButton) {
        
        let createEditJobPost = StoryboardRouter.createEditJobPost()
        createEditJobPost.delegate = self
        createEditJobPost.roleType = .add
        self.navigationController?.pushViewController(createEditJobPost, animated: true)
    }
    
    @IBAction func back_touchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension CompanyJobListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let job  = jobs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CompanyJobCell.id(), for: indexPath) as! CompanyJobCell
        
        cell.job = job
        cell.editButton.tag = indexPath.row
        cell.openJobDetailBtn.tag = indexPath.row
        cell.openJobDetailBtn.addTarget(self, action:#selector( navigateToJobDetail(sender:)), for: .touchUpInside)
        cell.editButton.addTarget(self, action:#selector( navigateToEditJobDetails(sender:)), for: .touchUpInside)
        return cell
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row  == jobs.count && !isDataLoaded {
            offset = jobs.count
            getCompanyJobs()
        }
    }
}

// MARK: Network Calls
private extension CompanyJobListVC {
    
     func getCompanyJobs() {
        let parameters: AFParameters = ["user_id": myUserDefaults.userId] //LoggedUserDetails.shared.user!.id ]
        let endPoint = EndPoints.companyJobs + "?limit=\(pageSize)" + "&offset=\(offset)"
        
        //showActivity()
        NetworkManagerr.request(endPoint, method: .post, parameters: parameters) { (response) in
           // self.hideActivity()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let companyJobListRoot = try jsonDecoder.decode(CompanyJobListRoot.self, from: response.data!)
                    
                    if !companyJobListRoot.error, companyJobListRoot.data.count > 0 {
                        self.jobs.removeAll()
                        self.jobs.append(contentsOf: companyJobListRoot.data)
                        self.tableView.reloadData()
                    }
                    
                    if !companyJobListRoot.error, companyJobListRoot.data.count == 0 {
                        self.isDataLoaded = true
                    }
                    
                } catch {
                    self.presentAlert("Failure", nil, response.result.error)
                }
            }
        }
    }
}

extension CompanyJobListVC {

    func setLayOut() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refresher
        createNewJob.applyGradient(colors: [AppColors.blueHigherGradient.cgColor, AppColors.lowerGradient.cgColor, AppColors.higherGradient.cgColor, AppColors.lowestGradient.cgColor])
        tableView.tableFooterView = UIView()
        tableView.registerCell(withType: CompanyJobCell.self)
    }
    
    @objc func reloadData() {
        jobs.removeAll()
        offset = 0
        getCompanyJobs()
    }
    
    @objc func navigateToJobDetail(sender: UIButton) {
        let postedJobDetail = StoryboardRouter.postedJobDetail()
        postedJobDetail.jobId = jobs[sender.tag].id
        self.navigationController?.pushViewController(postedJobDetail, animated: true)
    }
    
    @objc func navigateToEditJobDetails(sender: UIButton){
        
        let editPostedJob = StoryboardRouter.createEditJobPost()
        editPostedJob.jobId = jobs[sender.tag].id
        editPostedJob.roleType = .edit
        self.navigationController?.pushViewController(editPostedJob, animated: true)
    }
}

extension CompanyJobListVC: RefreshUpdateable {
    
    func refresh(homeStatus: Bool) {
        offset = 0
        jobs.removeAll()
        getCompanyJobs()
    }
}


