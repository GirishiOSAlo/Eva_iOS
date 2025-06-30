//
//  ConferenceAgendaListCVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 23/06/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

protocol AgendaCellDelegate: AnyObject {
    func didTapDropdownButton(in cell: ConferenceAgendaListCVC)
}

class ConferenceAgendaListCVC: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var programsCollectionVw: UICollectionView!
    @IBOutlet weak var programsCollectionVwHeight: NSLayoutConstraint!
    
    weak var delegate: AgendaCellDelegate?
    var conferencePrograms: [ConferenceProgram] = []
    var isExpanded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }

    func initUI() {
        baseView.layer.cornerRadius = 20.0
        dateLbl.font = UIFont(name: Myfonts.semiBold, size: 16.0)
        
        programsCollectionVw.registerNib(cellNib: ConferenceProgramsCVC.self)
        programsCollectionVw.delegate = self
        programsCollectionVw.dataSource = self
    }
    
    func setData(data: EventAgendaData?) {
        self.dateLbl.text = data?.date ?? ""
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
    
    @objc func dropDownTapped(_ sender: UIButton) {
        delegate?.didTapDropdownButton(in: self)
    }
}

//MARK: UICollection Delegate & DataSource....
extension ConferenceAgendaListCVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.conferencePrograms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.programsCollectionVw.dequeueReusableCell(withReuseIdentifier: ConferenceProgramsCVC.ReuseId, for: indexPath) as! ConferenceProgramsCVC
        let program = self.conferencePrograms[indexPath.row]
        cell.setData(data: program)
        cell.isExpanded = self.isExpanded
        
        cell.dropButton.tag = indexPath.row
        cell.dropButton.addTarget(self, action: #selector(dropDownTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //-->Normal height
        let program = self.conferencePrograms[indexPath.row]
        let lblHeight_1 = self.heightForView(text: program.name ?? "", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.programsCollectionVw.frame.width - 64.0)
        let lblHeight_2 = self.heightForView(text: "--", font: UIFont(name: Myfonts.medium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.programsCollectionVw.frame.width - 64.0)
        let cellHeight = lblHeight_1 + lblHeight_2 + 139.0
        return CGSize(width: self.programsCollectionVw.frame.size.width, height: cellHeight)
    }
}
