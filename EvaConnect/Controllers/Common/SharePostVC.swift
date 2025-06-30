//
//  SharePostVC.swift
//  EvaConnect
//
//  Created by Metis on 14/10/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

protocol SharePostDelegate: class {
    
    func selectedSharedType(classType: SharePostVC,type: ShareType, postType: TypePostEnum, postId: Int )
}

class SharePostVC: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var shareTable: UITableView!
    @IBOutlet weak var shareLbl: EditDeleteLbl!
    @IBOutlet weak var mainView: UIView!
    
    //MARK: Variables
    var dataSource: [ShareDataSource] = []
    var postId: Int!
    var postType: TypePostEnum!
    weak var delegate: SharePostDelegate? = nil
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iniVC()
        shareTable.registerCell(withType: ShareCell.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setTableViewContent()
       
    }
    
    func iniVC() {
        dataSource = [ShareDataSource(titleValue: "Share with a connection", ImageValue: #imageLiteral(resourceName: "connectionShare")),ShareDataSource(titleValue: "Share URL", ImageValue: #imageLiteral(resourceName: "copyLink")),ShareDataSource(titleValue: "Share on Whatsapp", ImageValue: #imageLiteral(resourceName: "whatsUpIcon")) ]
        shareTable.delegate = self
        shareTable.dataSource = self
        
        mainView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        mainView.layer.borderWidth = 1.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touches = touches.first{
            if touches.view == self.view {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func setTableViewContent() {
        let tableViewHeight = self.shareTable.frame.height
        let contentHeight = self.shareTable.contentSize.height
        let centeringInset = (tableViewHeight - contentHeight) / 2.0
        let topInset = max(centeringInset, 0.0)
        self.shareTable.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

//MARK:TableVew Delegates
extension SharePostVC: UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShareCell.id(), for: indexPath) as! ShareCell
        cell.shareDataSource = dataSource[indexPath.row]
        if indexPath.row == dataSource.count - 1 {
            cell.bottomView.isHidden = true
        } else {
            cell.bottomView.isHidden = false
        }
       return cell
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Selected")
        
//        if indexPath.row == 0 {
//            //delegate?.selectedSharedType(classType: self, type: .connection, postType: postType, postId: postId)
//        }
        if indexPath.row == 0 {
            delegate?.selectedSharedType(classType: self, type: .connection, postType: postType, postId: postId)
        }
        else if indexPath.row == 1 {
            UIPasteboard.general.string = "eva://\(postType.rawValue)/\(postId!)"
            // UIPasteboard.general.string
    }
        else if indexPath.row == 2 {
            delegate?.selectedSharedType(classType: self, type: .whatsup, postType: postType, postId: postId)
        }
        self.dismiss(animated: true, completion: nil)
    }
   
   @objc func button(_ sender: UIButton){
        
        
    }
}
struct ShareDataSource {
    var title: String!
    var image: UIImage!
    init(titleValue: String , ImageValue: UIImage) {
        title = titleValue
        image = ImageValue
    }
}


enum ShareType{
    case connection
    case whatsup
}
