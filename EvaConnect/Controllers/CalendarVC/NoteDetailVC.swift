//
//  NoteDetailVC.swift
//  EvaConnect
//
//  Created by Pranay Barua on 12/09/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import UIKit

class NoteDetailVC: UIViewController {

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navBarTitle: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescLabel: UILabel!
    
    @IBOutlet weak var dateTimeView: UIView!
    @IBOutlet weak var dateTimeHeadingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsHeadingLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var noteID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupUI()
    }
    
    func setupUI(){
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 15
        fetchNoteDetails()
    }
    
    func updateUI(data: CalenderEventsdata){
        titleDescLabel.text = data.title
        dateLabel.text = data.occurrenceDate
        timeLabel.text = data.occurrenceTime
        detailsLabel.text = data.details
    }
    
    func fetchNoteDetails(){
        showActivity()
        let url = "\(EndPoints.noteDetails)/\(noteID)"
        NetworkManagerr.request(url) { (response) in
            self.hideActivity()
            do {
                let jsonDecoder = JSONDecoder()
                let notesRoot = try jsonDecoder.decode(CalenderEventListDataModel.self, from: response.data!)
                
                if !(notesRoot.error!) {
                    if let data = notesRoot.data?[0] {
                        self.updateUI(data: data)
                    }
                } else {
                    self.presentAlert("Failure", notesRoot.message, nil)
                }
            } catch {
                print("\(String(describing: response.result.error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
