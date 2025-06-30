//
//  FAQsVC.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 09/05/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import UIKit

class FAQsVC: UIViewController, XIBed, FAQsCellDelegate {

    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var faqCollectionVw: UICollectionView!
    var expandedIndexPath: IndexPath?
    
    var questionsList = ["What is Aviation Connect, and how can it benefit me?","How do I create an account on Aviation Connect?","Is there a mobile app available for Aviation Connect?","How can I connect with other aviation professionals?","Are there any networking events or webinars hosted on the platform?","Can I create my own group or community within Aviation Connect?"]
    var answerList = ["Vestibulum eu quam nulla. Sed libero magna, pharetra non dolor a, volutpat sodales sapien. Aliquam accumsan fermentum pharetra. Sed sit amet finibus mi, eu ultricies orci. Aenean dapibus lacinia leo eu mollis. Donec varius arcu sem, quis interdum augue porta nec. Pellentesque bibendum lacus eget urna sagittis, vitae tincidunt enim pulvinar. Nam velit augue, accumsan quis fermentum eu, blandit id nulla. Morbi leo risus, venenatis a ex efficitur, rhoncus sagittis nunc.","Vestibulum eu quam nulla. Sed libero magna, pharetra non dolor a, volutpat sodales sapien. Aliquam accumsan fermentum pharetra. Sed sit amet finibus mi, eu ultricies orci.","Donec varius arcu sem, quis interdum augue porta nec.","Pellentesque bibendum lacus eget urna sagittis, vitae tincidunt enim pulvinar. Nam velit augue, accumsan quis fermentum eu, blandit id nulla. Morbi leo risus, venenatis a ex efficitur, rhoncus sagittis nunc.","Sed sit amet finibus mi, eu ultricies orci.","Pellentesque bibendum lacus eget urna sagittis, vitae tincidunt enim pulvinar."]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupUI()
    }
    
    func registerCell() {
        faqCollectionVw.registerNib(cellNib: FAQsCVC.self)
        faqCollectionVw.delegate = self
        faqCollectionVw.dataSource = self
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        headingLbl.font = UIFont(name: Myfonts.bold, size: 16.0)
        self.registerCell()
        self.faqCollectionVw.reloadData()
    }
    
    
    func didTapDropdownButton(in cell: FAQsCVC) {
        guard let indexPath = faqCollectionVw.indexPath(for: cell) else { return }
        
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
        faqCollectionVw.performBatchUpdates {
            faqCollectionVw.reloadItems(at: indexPathsToReload)
        }
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


//MARK: UICollection Delegate & DataSource....
extension FAQsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questionsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.faqCollectionVw.dequeueReusableCell(withReuseIdentifier: FAQsCVC.ReuseId, for: indexPath) as! FAQsCVC
        
        cell.baseVw.layer.cornerRadius = 0
        cell.baseVw.layer.maskedCorners = []
        
        let isFirst = indexPath.item == 0
        let isLast = indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1
        
        cell.baseVw.layer.cornerRadius = 16.0 // or any radius
        cell.baseVw.clipsToBounds = true
        
        if isFirst && isLast {
            // Only one item
            cell.baseVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                               .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.underlineVw.isHidden = true
        } else if isFirst {
            // First item: top corners
            cell.baseVw.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.underlineVw.isHidden = false
        } else if isLast {
            // Last item: bottom corners
            cell.baseVw.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.underlineVw.isHidden = true
        }
        
        cell.questionLbl.text = self.questionsList[indexPath.row]
        cell.questionLbl.font = UIFont(name: Myfonts.medium, size: 16.0)
        cell.answerLbl.text = self.answerList[indexPath.row]
        cell.answerLbl.font = UIFont(name: Myfonts.regular, size: 14.0)
        
        cell.delegate = self
        cell.isExpanded = (indexPath == expandedIndexPath)

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == expandedIndexPath {
            // Expanded height
            let question = self.questionsList[indexPath.row]
            let answer = self.answerList[indexPath.row]
            
            let questionLblHeight = self.heightForView(text: question, font: UIFont(name: Myfonts.medium, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 152.0)
            let answerLblHeight = self.heightForView(text: answer, font: UIFont(name: Myfonts.regular, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0), width: self.view.frame.width - 126.0)
            let totalCellHeight = questionLblHeight + answerLblHeight + 56.0
            
            return CGSize(width: self.faqCollectionVw.frame.size.width, height: totalCellHeight)
        }
        else {
            // Normal height
            let question = self.questionsList[indexPath.row]
            
            let lblHeight = self.heightForView(text: question, font: UIFont(name: Myfonts.medium, size: 16.0) ?? UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 152.0)
            let cellHeight = lblHeight + 40
            return CGSize(width: self.faqCollectionVw.frame.size.width, height: cellHeight)
        }
    }
    
}
