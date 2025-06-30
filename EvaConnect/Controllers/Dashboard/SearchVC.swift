//
//  SearchVC.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/31/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var connectionContainerView: UIView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var homeContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    
    private var tags = SearchTags.filter.map({ (tag: $0, selected: false) })
    private var previousSelectedIndex = 0
    private var homeVC: HomeVC!
    private var connectionVC: ConnectionVC!
    private var selectedFilterTag: SearchTags!
    
    //ModelArray
    var searchResults: [SearchResult] = []
    
    var recentSearches: [RecentSearchData] = []
    
    var showShowRecent: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
    }
}

extension SearchVC {
    
    func setLayout() {
        
        self.navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        recentSearch()
//        searchView.applyShadow()
//        collectionView.applyShadow()
//
//        tags[0].selected = true
//        selectedFilterTag = tags.first!.tag
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout, LoggedUserDetails.shared.user?.isUser ?? false {
//            layout.estimatedItemSize = CGSize(width: 120, height: 25)
//        }
//        searchImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchImageViewTapped)))
//
//        setHomeContainerView()
//        setConnectionContainerView()
    }
    
    private func setHomeContainerView() {
        homeVC = StoryboardRouter.homeVC()
        homeVC.searchEnabled = true
        homeVC.view.frame = CGRect(x: 0, y: 0, width: homeContainerView.frame.width, height: homeContainerView.frame.height)
        homeContainerView.addSubview(homeVC.view)
        addChild(homeVC)
    }
    
    private func setConnectionContainerView() {
        connectionVC = StoryboardRouter.connectionVC()
        connectionVC.view.frame = CGRect(x: 0, y: 0, width: connectionContainerView.frame.width, height: connectionContainerView.frame.height)
        connectionContainerView.addSubview(connectionVC.view)
        connectionVC.isGlobalSearch = true
        connectionContainerView.isHidden = true
        addChild(connectionVC)
    }
    
    @objc private func searchImageViewTapped() {
        let query = searchTxt.text?.trim ?? ""
        if query.isEmpty {
            ErrorView(contentView: navigationController?.view ?? view).show(message: "Please enter something to search")
        } else if selectedFilterTag.isHome {
            connectionContainerView.isHidden = true
            homeContainerView.isHidden = false
            homeVC.searchEnabled = false
            homeVC.selectedTab = selectedFilterTag.homeTab
            homeVC.searchFilterKey = (key: selectedFilterTag.filterKey, query: query)
        } else {
            homeContainerView.isHidden = true
            connectionContainerView.isHidden = false
            connectionVC.globalSearchQuery = (query: query, filter: selectedFilterTag.filterKey)
        }
    }
    
}

//MARK: Network Calls

extension SearchVC {
    
    func recentSearch() {
        
        let endPoint = "\(EndPoints.getRecentSearch)?offset=1&limit=10"
        NetworkManagerr.request(endPoint) { (response) in
//            self.postsTableView.refreshControl?.endRefreshing()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let recentSearchPostsRoot = try jsonDecoder.decode(RecentSearchModel.self, from: response.data!)
                    if recentSearchPostsRoot.error == false {
                        if !(self.searchTxt.text!.isEmpty) {
                            self.recentSearches.removeAll()
                        } else {
                            self.recentSearches = recentSearchPostsRoot.data ?? []
                            self.searchTableView.reloadData()
                        }
                    }
                } catch {
                    self.presentAlert("Error", nil, error)
                }
            } else {
                self.presentAlert("Error", nil, response.result.error)
            }
        }
    }
    
    func sendSearchQuery() {
        
        guard searchTxt.text != "" else {
            return
        }
        
        let param: AFParameters = [
            "search" : searchTxt.text ?? ""
        ]
        
        let endPoint = EndPoints.getRecentSearch
        NetworkManagerr.request(endPoint, method: .post, parameters: param) { (response) in
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let resResult = try jsonDecoder.decode(GenericResponse.self, from: response.data!)
                    if resResult.error == false {
                        
                    } else {
//                        self.presentAlert("Error", resResult.message)
                    }
                } catch {
                    self.presentAlert("Error", nil, error)
                }
            } else {
                self.presentAlert("Error", nil, response.result.error)
            }
        }
    }
    
    func gloabalSearch(txt: String, nextScreen: Bool) {
        
        let param: AFParameters = [
            "search_text" : searchTxt.text ?? ""
//            "search_text" : txt
        ]
        
        let endPoint = EndPoints.globalSearch
        NetworkManagerr.request(endPoint, method: .post, parameters: param) { (response) in
//            self.postsTableView.refreshControl?.endRefreshing()
            if response.result.isSuccess {
                do {
                    let jsonDecoder = JSONDecoder()
                    let searchPostsRoot = try jsonDecoder.decode(SearchDataModel.self, from: response.data!)
                    if searchPostsRoot.error == false {
                        if self.searchTxt.text!.isEmpty {
                            self.searchResults.removeAll()
//                            self.totalRecode.text =  "Found \(0) result"
//                            self.noRecordLbl.isHidden = false
                        } else {
//                            for i in searchPostsRoot.searchData?.searchResults {
//                                self.searchResults.append(i)
//                            }
                            self.sendSearchQuery()
                            self.searchResults = searchPostsRoot.data ?? []
//                             if self.searchResults.isEmpty || self.searchResults.count <= 0{
//                                self.totalRecode.text =  "Found \(0) result"
//                                self.stopAPICall = true
//                                self.noRecordLbl.isHidden = false
//                            } else {
//                                self.totalRecode.text = "Found \(self.searchResults.count)"
//                                self.noRecordLbl.isHidden = true
//                            }
                            self.searchTableView.reloadData()
                            
//                            if nextScreen {
//                                let storyboard = UIStoryboard(name: "Home", bundle: nil)
//                                let vc = storyboard.instantiateViewController(withIdentifier: "SearchDetailsVC") as! SearchDetailsVC
//                                vc.searchText = txt
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            }else {
//                                print("Tableview Data Reload...")
//                            }
                        }
                        
                        
//                        self.searchTableView.reloadData()
                    }
                } catch {
                    self.presentAlert("Error", nil, error)
                }
            } else {
                self.presentAlert("Error", nil, response.result.error)
            }
        }
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showShowRecent ? recentSearches.count : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GlobalSearchTVC = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        if showShowRecent {
            let obj = recentSearches[indexPath.row]
            cell.searchResult.text = obj.search
            cell.icon.image = UIImage(named: "recentTime")
        } else {
            cell.results = searchResults[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showShowRecent {
            self.searchTxt.text = recentSearches[indexPath.row].search
            let txt = recentSearches[indexPath.row].search ?? ""
            self.gloabalSearch(txt: txt, nextScreen: true)
            self.showShowRecent = false
        } else {
            let searchText = searchResults[indexPath.row].content
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchDetailsVC") as! SearchDetailsVC
            vc.searchText = searchText ?? "" //self.searchTxt.text ?? ""
            navigationController?.pushViewController(vc, animated: true)
//            let txt = searchResults[indexPath.row].content ?? ""
//            self.gloabalSearch(txt: txt, nextScreen: true)
        }
    }
    
}

extension SearchVC: UITextFieldDelegate {
    
    //MARK: TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField)-> Bool{
        self.view.isUserInteractionEnabled = true
        return true
    }
    @objc func textFieldDidChange(_ textfield: UITextField) {
        
        if searchTxt.text!.count > 0 {
            showShowRecent = false
            //filteredConnections.removeAll()
//            dataType = .search
//            inSearchMode = true
            gloabalSearch(txt: self.searchTxt.text!, nextScreen: false)
        } else {
            showShowRecent = true
            recentSearch()
        }
    }
}


extension SearchVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { tags.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchTagCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.item = tags[indexPath.item]
        return cell
    }
    
}

extension SearchVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if previousSelectedIndex == indexPath.item { return }
        didSelectedTag(at: indexPath.item)
    }
    
    private func didSelectedTag(at index: Int) {
        let paths = [IndexPath(item: index, section: 0), IndexPath(item: previousSelectedIndex, section: 0)]
        tags[index].selected.toggle()
        tags[previousSelectedIndex].selected.toggle()
        collectionView.reloadItems(at: paths)
        previousSelectedIndex = index
        selectedFilterTag = tags[index].tag
        
        homeContainerView.isHidden = true
        connectionContainerView.isHidden = true
    }
    
}

extension SearchVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = tags[indexPath.item].tag.rawValue.widthHeightForView(height: 40).width
        let isCompany = LoggedUserDetails.shared.user?.type == userType.company.rawValue
        return CGSize(width: isCompany ? collectionView.frame.width / 2.8 : width, height: 30)
    }
    
}


