//
//  AlertView.swift
//  Fabby
//
//  Created by Girish Bhuva on 08/07/24.
//

import UIKit

class AlertView: UIView {
    
    @IBOutlet weak var subPopupVw: UIView!
    @IBOutlet weak var popupTitleLbl: UILabel!
    @IBOutlet weak var popupDoneBtn: UIButton!
    @IBOutlet weak var popupCancelBtn: UIButton!
    
    var title: String?
    var doneBtnTitle: String = "OK"
    var actionHandler: (() -> Void)?
    
    init(title: String, doneBtnTitle: String, actionHandler: @escaping () -> Void) {
        self.title = title
        self.doneBtnTitle = doneBtnTitle
        self.actionHandler = actionHandler
        super.init(frame: CGRect.zero)
        commonInit()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        addSubview(view)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "AlertView", bundle: Bundle(for: type(of: self)))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func setupView() {
        self.subPopupVw.cornerRadius = 20.0
        popupTitleLbl.font = UIFont(name: Myfonts.bold, size: 18.0)
        popupDoneBtn.cornerRadius = 14.0
        popupDoneBtn.setTitle(doneBtnTitle, for: .normal)
        popupDoneBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        popupCancelBtn.applyBorderWithRadius(color: UIColor(hex: "#4D76CD"), value: 1.0, radius: 14.0)
        popupCancelBtn.titleLabel?.font = UIFont(name: Myfonts.medium, size: 16.0)
        
        self.popupTitleLbl.text = title
    }

    
    @IBAction func onDoneBtn(_ sender: UIButton) {
        actionHandler?()
        self.removeFromSuperview()
    }
    @IBAction func onCancelBtn(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
