//
//  MenuXib.swift
//  EvaConnect
//
//  Created by Metis on 18/02/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import SDWebImage

protocol SideMenuActionable: AnyObject {
    func sideMenuAction(item: menuStruct)
    func logout()
    func close()
    func closeMenu()
}

class SideMenu: UIView {
    
    // MARK: Properties

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var LogOut: UIButton!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var connectionLbl: UILabel!
    @IBOutlet weak var totalNotification: UILabel!
    weak var delegate: SideMenuActionable?
    var view: UIView!
    var menus: [menuStruct] = []
    var dismissGesturee: UITapGestureRecognizer!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var itemTableView: UITableView! {
        didSet {
            itemTableView.delegate = self
            itemTableView.dataSource = self
        }
    }

  private var menus0: [menuStruct] = [menuStruct(titleData: "My Activity",
                                                   imageData: #imageLiteral(resourceName: "MyActivity")),
                                        menuStruct(titleData: "Calender",
                                                   imageData: #imageLiteral(resourceName: "MyCalander")),
                                        menuStruct(titleData: "Job Listings",
                                                   imageData: #imageLiteral(resourceName: "MyJobListing"))] {

        didSet {
            itemTableView?.reloadData()
        }
    }
    
    private var menus1: [menuStruct] = [menuStruct(titleData: "My Activity",
                                                   imageData: #imageLiteral(resourceName: "MyActivity")),
                                        menuStruct(titleData: "Calender and Events",
                                                   imageData: #imageLiteral(resourceName: "MyCalander")),
                                        menuStruct(titleData: "My Jobs",
                                                   imageData: #imageLiteral(resourceName: "MyJobListing"))] {
        didSet {
            itemTableView?.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //xibSetup()
        //configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

extension SideMenu {
    
    @objc func openVCAction(sender: UIButton) {
        delegate?.sideMenuAction(item: menus[sender.tag])
    }
    
    @IBAction func logOut_touchUpInside(_ sender: UIButton) {
        delegate?.logout()
    }
    
    @IBAction func close_touchUpInside(_ sender: UIButton) {
        delegate?.close()
    }
    
    func inittUI() {
        dismissGesturee = UITapGestureRecognizer(target: self, action: #selector(dismissVieww(_:)))
        dismissGesturee.delegate = self
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVieww(_:)))
        mainView.addGestureRecognizer(dismissGesturee)
        mainView.isUserInteractionEnabled = true
    }
    
    @objc func dismissVieww(_ sender: UITapGestureRecognizer) {
        //delegate?.closeMenu()
        
    }
}

//Setup
extension SideMenu: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if LoggedUserDetails.shared.user!.type == "user" {
            menus = menus0
        } else {
            menus = menus1
        }
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.id(), for: indexPath) as! SideMenuCell
        
        let menu = menus[indexPath.row]
        cell.menu = menu
        cell.showIcon = indexPath.row != menus.count
        cell.openVC.tag = indexPath.row
        cell.openVC.addTarget(self, action:#selector(openVCAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sideMenuAction(item: menus[indexPath.row])
    }
    
    private func xibSetup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        if !LoggedUserDetails.shared.user!.userImage.isNil {
            userProfileImage.sd_setImage(with: URL(string: (LoggedUserDetails.shared.user!.userImage)!), placeholderImage: #imageLiteral(resourceName: "profile"), options: .progressiveLoad, completed: .none)
        } else {
            userProfileImage.image = #imageLiteral(resourceName: "profile")
        }
    
        itemTableView.registerCell(withType: SideMenuCell.self)

        profileView.roundOnly()
        userProfileImage.roundOnly()
        profileView.layer.borderWidth = 1
        profileView.layer.borderColor = #colorLiteral(red: 0.3450980392, green: 0.5803921569, blue: 0.8666666667, alpha: 1)
        
        totalNotification.text = "0"
        nameLbl.text = LoggedUserDetails.shared.user!.fullName
        connectionLbl.text = "\((LoggedUserDetails.shared.user!.totalConnection ?? 0)!)"
        
        if !LoggedUserDetails.shared.user!.city.isNilOrEmpty || !LoggedUserDetails.shared.user!.country.isNilOrEmpty {
            address.text = String(format: "%@, %@",
            LoggedUserDetails.shared.user!.city.stringValue,
            LoggedUserDetails.shared.user!.country.stringValue)
        }
        
        designationLbl.setAttibutedString(strings: ["\(LoggedUserDetails.shared.user!.designation.stringValue)", " at \(LoggedUserDetails.shared.user!.companyName.stringValue)"],
                                          colors: [.darkGray, Constants.AppColorLiteral.loginColor], font: UIFont(defaultFontStyle: .regular, size: 14.0))
        if LoggedUserDetails.shared.user!.designation.isNilOrEmpty {
            designationLbl.isHidden = false
            designationLbl.text = "\(LoggedUserDetails.shared.user!.companyName ?? "")"
            designationLbl.textColor = Constants.AppColorLiteral.loginColor
            
        }
        inittUI()
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SideMenu", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}

extension SideMenu: UIGestureRecognizerDelegate {
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
   
       if let menuView = mainView {
        if touch.view == menuView {
            delegate?.closeMenu()
                return false
            }
            return true
       }
       return true
    }
}

struct menuStruct {
    var titleData : String
    var imageData : UIImage?
}
