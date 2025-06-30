//
//  NewsSourceVC.swift
//  EvaConnect
//
//  Created by usama on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire

class NewsSourceVC: BaseForAuthentication {

    @IBOutlet weak var TopStackConstraint: NSLayoutConstraint!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var createAccntLbl: NameLabel!
    @IBOutlet weak var newsCategoryLbl: NameLabel!
    
    @IBOutlet weak var bottom: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    private var newsSources: [NewsSource] = []
    {
        didSet {
            if newsSources.filter({ $0.selected }).count > 0 {
//                bottom.isHidden = true
                nextButton.isEnabled = true
                collectionView.reloadData()
            } else {
//                bottom.isHidden = false
                nextButton.isEnabled = false
            }
        }
    }
    
    var updateNewsSource: Bool = false
    var mode: PostLoadingMode = .create

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) { goBack() }
    @IBAction func closeBtnTapped(_ sender: Any) { goToRootViewController() }
    
}

extension NewsSourceVC {
    
    func initUI() {
        
//        header.font = UIFont(defaultFontStyle: .bold, size: 14)
//        header.textColor = AppColors.textColor3
//
//        bottom.font = UIFont(defaultFontStyle: .regular, size: 12)
//        bottom.textColor = AppColors.evaBlue
        
        // giveButtonCorner(actionBtn: nextButton, backColor: updateNewsSource ? Constants.AppColorLiteral.loginByNew : Constants.AppColorLiteral.loginColor)
        TopStackConstraint.constant = updateNewsSource ? 20 : 50
        header.isHidden = updateNewsSource ? true : false
        newsCategoryLbl.isHidden = updateNewsSource ? false : true
        createAccntLbl.isHidden = updateNewsSource ? true : false
//        giveButtonCorner(actionBtn: nextButton, backColor: AppColors.appBlue)
        nextButton.layer.cornerRadius = 14
        nextButton.setTitle(updateNewsSource ? "Submit" : "Finish", for: .normal)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(cellNib: NewsSourceCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        getNewsSources()
    }
    
    func getNewsSources() {

        showActivity()
//        self.getUserSelectedNews()
        NetworkManagerr.request(EndPoints.newsSources) { (response) in
            if !self.updateNewsSource { self.hideActivity() }
            if response.result.isSuccess {
                let jsonDecoder = JSONDecoder()
                let newsSourcesRoot = try? jsonDecoder.decode(NewsSourceRoot.self, from: response.data!)
                self.hideActivity()
//                if let newsSources = newsSourcesRoot {
                if ((newsSourcesRoot?.error) != nil) {
                    self.newsSources = newsSourcesRoot?.data ?? []
                    self.collectionView.reloadData()
                } else {
                    self.presentAlert("\(newsSourcesRoot?.message ?? "Error")")
                }
//                    self.getUserSelectedNews()
//                }
            }
        }
    }
    
    func postNewsSources() {
//        self.gotoDashboard()
//        if let user = myUserDefaults.userId {
            let ids = newsSources.filter({ $0.selected }).compactMap({ $0.id })
            let parameters = ["user_id": myUserDefaults.userId,
                              "news_ids": ids,
                              "created_by_id": myUserDefaults.userId,
                              "status": "active"] as [String : Any]

            NetworkManagerr.request(EndPoints.postNewsSources, method: .post, parameters: parameters) { (response) in
                self.hideActivity()
                if response.result.isSuccess {
                    let jsonDecoder = JSONDecoder()
                    let genericResponse = try? jsonDecoder.decode(GenericResponse.self, from: response.data!)

                    if let genericResponse = genericResponse, !(genericResponse.error) {
                        // check if the response is okay. proceed
                        self.updateNewsSource ? self.goBack() : self.gotoDashboard()
                    }
                }
            }
//        }
    }
    
    func deleteNewsSources(completion: @escaping () -> Void) {
//        showActivity()
//        if let user = LoggedUserDetails.shared.user {
//            let ids = newsSources.filter({ !$0.selected }).compactMap({ $0.id })
//            let parameters = ["user_id": user.id,
//                              "news_ids": ids,
//                              "created_by_id": user.id,
//                              "status": "deletec"] as [String : Any]
//
//            NetworkManagerr.request(EndPoints.deleteNewsSources, method: .patch, parameters: parameters) { (response) in
//                if response.result.isSuccess {
//                    completion()
//                }
//            }
//        }
    }
    
    func getUserSelectedNews() {
        guard let userId = LoggedUserDetails.shared.user?.id else { return }
        let params = ["user_id": userId]
        NetworkManagerr.request(EndPoints.getUserNews, method: .post, parameters: params) { [weak self] (result: Result<NewsSourceRoot>) in
            guard let self = self else { return }
            self.hideActivity()
            switch result {
            case .success(let rsl):
                rsl.data.map({ $0.name }).forEach { name in
                    if let index = self.newsSources.firstIndex(where: { $0.name == name }) {
                        self.newsSources[index].selected = true
                    }
                }
                self.collectionView.reloadData()
            case .failure(let failure):
                self.presentAlert("Error", nil, failure)
            }

        }
    }
    
}

extension NewsSourceVC {
    
    @IBAction func send_touchUpInside(_ sender: UIButton) {
//        self.postNewsSources()
        
        if newsSources.filter({ $0.selected }).count > 0 && mode == .create {
            postNewsSources()
        } else if mode == .create {
            self.presentAlert("Alert", "Please select news sources", nil)
        } else if newsSources.filter({ $0.selected }).count > 0 && mode == .edit {
            postNewsSources()
        } else {
            deleteNewsSources {
                self.postNewsSources()
            }
        }
    }
}

extension NewsSourceVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newsSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsSourceCell.ReuseId, for: indexPath) as? NewsSourceCell {

            cell.delegate = self
            cell.newsImage.tag = indexPath.row
            cell.newsSource = newsSources[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}

extension NewsSourceVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//        let inset: CGFloat = 3
//        let width = collectionView.frame.size.width * 0.3
//        let height = collectionView.frame.size.height * 0.25
//
//        return CGSize(width: width - inset, height: height)
        
        return CGSize(width: collectionView.frame.size.width/3 - 20, height: 136)
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 5
//    }
}

extension NewsSourceVC: NewsImageActionable {
    
    func tappedImage(newsSourceId: Int, completion: @escaping ((Bool) -> Void)) {
        var newsSource = newsSources.filter { $0.id == newsSourceId }
//        newsSource[0].selected.toggle()
        
        newsSources[newsSourceId].selected.toggle()
        completion(newsSources[newsSourceId].selected)
    }
    
    func loadImage() -> UIImage? {
        if let filePath = UserDefaults.standard.string(forKey: "userImageFilePath") {
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }
    
    func deleteImage() {
        if let filePath = UserDefaults.standard.string(forKey: "userImageFilePath") {
            do {
                try FileManager.default.removeItem(atPath: filePath)
                UserDefaults.standard.removeObject(forKey: "userImageFilePath")
            } catch {
                print("Error deleting image: \(error.localizedDescription)")
            }
        }
    }
}
