//
//  SpeakersDetailsVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 20/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class SpeakersDetailsVC: UIViewController, XIBed {

    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profileImgBaseVw: UIView!
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var profileBaseVw: UIView!
    @IBOutlet weak var descTitleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    var speakerID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    func setupUI() {
        headingLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        titleLbl.font = UIFont(name: Myfonts.bold, size: 18.0)
        profileBaseVw.cornerRadius = 20.0
        descTitleLbl.font = UIFont(name: Myfonts.medium, size: 14.0)
        descLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        nameLbl.font = UIFont(name: Myfonts.bold, size: 20.0)
        subLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        profileImgBaseVw.applyBorderWithRadius(color: UIColor(hex: "#5894DD"), value: 2.0, radius: profileImgBaseVw.frame.size.width/2)
        profileImgVw.cornerRadius = profileImgVw.frame.size.width/2
        
        self.fetchSpekerDetails(id: self.speakerID)
    }
    
    func setData(data: SpeakerDetails?) {
        if let imageUrl = data?.userImage,
           !imageUrl.trimmingCharacters(in: .whitespaces).isEmpty,
           let url = URL(string: imageUrl),
           UIApplication.shared.canOpenURL(url) {
            profileImgVw.kf.setImage(with: url, placeholder: UIImage(named: "profile"))
        } else {
            profileImgVw.image = UIImage(named: "profile")
        }
        nameLbl.text = (data?.firstName?.isEmpty ?? true) ? "--" : data?.firstName
        subLbl.text = (data?.designation?.isEmpty ?? true) ? "--" : data?.designation
        descLbl.text = (data?.description?.isEmpty ?? true) ? "--" : data?.description
    }
    
    func fetchSpekerDetails(id: Int) {
        showActivity()
        let url = EndPoints.speakerDetails + "?id=\(id)"
        NetworkManagerr.request(url, method: .get) { (response) in
            self.hideActivity()
            guard response.result.isSuccess else {
                print("Error ::", response.error?.localizedDescription ?? "Default Error")
                return
            }

            guard let data = response.data else {
                print("Error :: No data received.")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(SpeakerDetailsDataModel.self, from: data)
                if let data = decodedResponse.data {
                    let speakerDetails = data[0]
                    self.setData(data: speakerDetails)
                } else {
                    print("Error ::", decodedResponse.message ?? "No message")
                }
            } catch {
                print("Error ::", error)
            }
        }
    }
}
