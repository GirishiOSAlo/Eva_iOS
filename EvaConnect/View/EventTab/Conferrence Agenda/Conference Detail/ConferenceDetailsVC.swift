//
//  ConferenceDetailsVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 15/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class ConferenceDetailsVC: UIViewController, XIBed {

    static func instantiate(eventId: Int) -> Self {
        let vc = Self.instantiate()
        vc.eventId = eventId
        return vc
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headingLabel: HeadingLabel!
    
    @IBOutlet weak var agendaCollectionVw: UICollectionView!
    
    var eventId = 0
    var eventAgendaData: [EventAgendaData] = []
    var expandedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
        fetchEventConferanceAgenda()
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        headingLabel.font = UIFont(name: Myfonts.semiBold, size: 16)
    }
    
    func registerCell() {
        self.agendaCollectionVw.registerNib(cellNib: ConferenceAgendaListCVC.self)
        self.agendaCollectionVw.delegate = self
        self.agendaCollectionVw.dataSource = self
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
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

extension ConferenceDetailsVC: AgendaCellDelegate {
    func didTapDropdownButton(in cell: ConferenceAgendaListCVC) {
        guard let indexPath = agendaCollectionVw.indexPath(for: cell) else { return }
        
        var indexPathsToReload: [IndexPath] = [indexPath]
        
        if let previous = expandedIndexPath, previous != indexPath {
            indexPathsToReload.append(previous)
        }
        
        // Update the expandedIndexPath
        if expandedIndexPath == indexPath {
            expandedIndexPath = nil // collapse
        } else {
            expandedIndexPath = indexPath // expand new
        }
        
        // Animate height and layout changes
        agendaCollectionVw.performBatchUpdates {
            agendaCollectionVw.reloadItems(at: indexPathsToReload)
        }
    }
}

extension ConferenceDetailsVC {
    func fetchEventConferanceAgenda() {
        showActivity()
        let url = "\(EndPoints.eventConferenceAgenda)"
        let parameters = ["eventid" : eventId] as [String: Any]
        showActivity()
        NetworkManagerr.request(url, method: .post, parameters: parameters) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let agendaRoot = try jsonDecoder.decode(EventAgendaListDataModel.self, from: response.data!)
                
                if !(agendaRoot.error!) {
                    if (agendaRoot.data?.count ?? 0) > 0 {
                        if let data = agendaRoot.data {
                            self.eventAgendaData = data
                            self.agendaCollectionVw.reloadData()
                        }
                    } else {
                        print("Agenda List is Empty...")
                    }
                } else {
                    print("Error :: \(agendaRoot.message ?? "")")
                }
            } catch {
                print("Error:: ", error)
            }
        }
    }
}

extension ConferenceDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventAgendaData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.agendaCollectionVw.dequeueReusableCell(withReuseIdentifier: ConferenceAgendaListCVC.ReuseId, for: indexPath) as! ConferenceAgendaListCVC
        let obj = self.eventAgendaData[indexPath.row]
        cell.setData(data: obj)
        cell.conferencePrograms = obj.conferencePrograms ?? []
        cell.delegate = self
        cell.isExpanded = (indexPath == expandedIndexPath)

        var insideHeight = 0.0
        for program in obj.conferencePrograms ?? [] {
            let lblHeight_1 = self.heightForView(text: program.name ?? "", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 104.0)
            let lblHeight_2 = self.heightForView(text: "--", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 104.0)
            let cellHeight = lblHeight_1 + lblHeight_2 + 139.0
            insideHeight = insideHeight + cellHeight
        }
        insideHeight = insideHeight + 70.0
        
        if indexPath == expandedIndexPath { //-->Expanded height
            cell.programsCollectionVwHeight.constant = insideHeight
        }
        else { //-->Normal height
            cell.programsCollectionVwHeight.constant = insideHeight - 57.0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var totalHeight = 0.0
        let conferencePrograms = self.eventAgendaData[indexPath.row].conferencePrograms ?? []
        for program in conferencePrograms {
            let lblHeight_1 = self.heightForView(text: program.name ?? "", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 104.0)
            let lblHeight_2 = self.heightForView(text: "--", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 104.0)
            let cellHeight = lblHeight_1 + lblHeight_2 + 139.0
            totalHeight = totalHeight + cellHeight
        }
        totalHeight = totalHeight + 70.0
        if indexPath == expandedIndexPath { //-->Expanded height
            return CGSize(width: self.agendaCollectionVw.frame.size.width, height: totalHeight)
        }
        else { //-->Normal height
            return CGSize(width: self.agendaCollectionVw.frame.size.width, height: totalHeight - 57.0)
        }
    }
}
