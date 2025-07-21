//
//  ReportVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 21/07/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

protocol ReportCellDelegate: AnyObject {
    func didTapSelectButton(report: ReportData, newsID: Int, commentId: Int)
}

class ReportVC: UIViewController, XIBed {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var topLineVw: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var complainsCollectionVw: UICollectionView!
    @IBOutlet weak var noComplainLbl: UILabel!
    
    var reportList: [ReportData] = []
    weak var delegate: ReportCellDelegate?
    var selectedNewsId = 0
    var commentID = 0

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        baseView.roundCorners([.topLeft, .topRight], radius: 35)
    }
    
    func setupUI() {
        self.noComplainLbl.isHidden = true
        topLineVw.layer.cornerRadius = topLineVw.frame.size.height / 2
        titleLbl.font = UIFont(name: Myfonts.bold, size: 18.0)
        noComplainLbl.font = UIFont(name: Myfonts.medium, size: 20.0)
        self.fetchReportData()
        self.registerCell()
        self.complainsCollectionVw.reloadData()
    }
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func registerCell() {
        complainsCollectionVw.registerNib(cellNib: ReportCVC.self)
        complainsCollectionVw.delegate = self
        complainsCollectionVw.dataSource = self
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
}

extension ReportVC {
    func fetchReportData() {
        showActivity()
        let url = "\(EndPoints.complainList)"
        NetworkManagerr.request(url, method: .get) { (response) in
            self.hideActivity()
            guard response.result.isSuccess else {
                print("Error ::", response.error?.localizedDescription as? Error ?? "Default Error")
                return
            }

            guard let data = response.data else {
                print("Error :: No data received.")
                return
            }

            do {
                let response = try JSONDecoder().decode(ReportDataModel.self, from: data)
                if let data = response.data {
                    self.reportList = data
                    self.complainsCollectionVw.reloadData()
                    if self.reportList.count == 0 {
                        self.noComplainLbl.isHidden = false
                    } else {
                        self.noComplainLbl.isHidden = true
                    }
                } else {
                    print("Error ::", response.message as? Error ?? "Default Error")
                }
            } catch {
                print("Error ::", error)
            }
        }
    }
}

//MARK: UICollection Delegate & DataSource....
extension ReportVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reportList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.complainsCollectionVw.dequeueReusableCell(withReuseIdentifier: ReportCVC.ReuseId, for: indexPath) as! ReportCVC
                
        let report = reportList[indexPath.row]
        cell.titleLbl.text = report.tagName ?? "--"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let report = reportList[indexPath.row]
        let lblHeight = self.heightForView(text: report.tagName ?? "--", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 40.0)
        let cellHeight = lblHeight + 40.0
        return CGSize(width: self.complainsCollectionVw.frame.size.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let complain = self.reportList[indexPath.row]
            self.delegate?.didTapSelectButton(report: complain, newsID: self.selectedNewsId, commentId: self.commentID)
        }
    }
}
