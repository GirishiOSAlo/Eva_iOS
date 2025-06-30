//
//  ReplyTVCell.swift
//  EvaConnect
//
//  Created by Pranay Barua on 15/01/24.
//  Copyright © 2024 HyperNym. All rights reserved.
//

import UIKit

class ReplyTVCell: UITableViewCell {

    @IBOutlet weak var mainUIView: UIView!
    @IBOutlet weak var wholeBGVIew: UIView!
    @IBOutlet weak var rplyView: UIView!
    @IBOutlet weak var wholeBGVWleadingConst: NSLayoutConstraint!
    @IBOutlet weak var wholeBGVWtrailingConst: NSLayoutConstraint!
    @IBOutlet weak var textViewRP: UIView!
    @IBOutlet weak var textLblRP: UILabel!
    @IBOutlet weak var imageViewRP: UIView!
    @IBOutlet weak var imageRP: UIImageView!
    @IBOutlet weak var DocViewRP: UIView!
    @IBOutlet weak var docRoundIconRP: UIImageView!
    @IBOutlet weak var docIconRP: UIImageView!
    @IBOutlet weak var docNameRP: UILabel!
    @IBOutlet weak var docSizeRp: UILabel!
    @IBOutlet weak var docDLBtnRP: UIButton!
    @IBOutlet weak var DocTimeLblRP: UILabel!
    @IBOutlet weak var AudViewRP: UIView!
    @IBOutlet weak var audBGImageVw: UIImageView!
    @IBOutlet weak var audImage: UIImageView!
    @IBOutlet weak var audNameLbl: UILabel!
    @IBOutlet weak var audSizeLbl: UILabel!
    @IBOutlet weak var audTimeLbl: UILabel!
    @IBOutlet weak var audDLBtn: UIButton!
    
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var msgTimeLbl: UILabel!
    
    
    var chat: ChatList? = nil {
        didSet {
            switch chat?.type {
            case .message:
//                self.AudViewRP.isHidden = true
//                self.imageViewRP.isHidden = true
//                self.DocViewRP.isHidden = true
//                self.textViewRP.isHidden = false
//                self.textLblRP.text = chat?.message
                break
            case .image:
//                self.AudViewRP.isHidden = true
//                self.imageViewRP.isHidden = true
//                self.DocViewRP.isHidden = false
//                self.textViewRP.isHidden = true
//                self.imageRP.sd_setImage(with: URL(string: chat?.imageURL ?? ""))
                break
            case .doc:
//                self.AudViewRP.isHidden = true
//                self.imageViewRP.isHidden = false
//                self.DocViewRP.isHidden = true
//                self.textViewRP.isHidden = true
//                self.docNameRP.text = chat?.actualDocumentName
//                self.docSizeRp.text = chat?.documentSize
//                self.DocTimeLblRP.text = chat?.createdAt
                break
            case .audio:
//                self.AudViewRP.isHidden = false
//                self.imageViewRP.isHidden = true
//                self.DocViewRP.isHidden = true
//                self.textViewRP.isHidden = true
//                self.audNameLbl.text = chat?.actualAudioFileName
//                self.audSizeLbl.text = chat?.audioSize
//                self.audTimeLbl.text = chat?.createdAt
                break
            case .reply:
                self.msgLbl.text = chat?.message
                self.msgTimeLbl.text = chat?.chatTime
                if chat?.replyMessage?.message != "" && chat?.replyMessage?.message != nil {
                    self.AudViewRP.isHidden = true
                    self.imageViewRP.isHidden = true
                    self.DocViewRP.isHidden = true
                    self.textViewRP.isHidden = false
                    self.textLblRP.text = chat?.replyMessage?.message
                } else if chat?.replyMessage?.imageURL != "" && chat?.replyMessage?.imageURL != nil {
                    self.AudViewRP.isHidden = true
                    self.imageViewRP.isHidden = false
                    self.DocViewRP.isHidden = true
                    self.textViewRP.isHidden = true
                    self.imageRP.sd_setImage(with: URL(string: chat?.replyMessage?.imageURL ?? ""))
                } else if chat?.replyMessage?.audioFileURL != "" && chat?.replyMessage?.audioFileURL != nil {
                    self.AudViewRP.isHidden = false
                    self.imageViewRP.isHidden = true
                    self.DocViewRP.isHidden = true
                    self.textViewRP.isHidden = true
                    self.audNameLbl.text = chat?.replyMessage?.actualAudioFileName
                    self.audSizeLbl.text = chat?.replyMessage?.audioSize
                    self.audTimeLbl.text = chat?.replyMessage?.chatTime
                    self.audTimeLbl.isHidden = true
                } else if chat?.replyMessage?.documentURL != "" && chat?.replyMessage?.documentURL != nil {
                    self.AudViewRP.isHidden = true
                    self.imageViewRP.isHidden = true
                    self.DocViewRP.isHidden = false
                    self.textViewRP.isHidden = true
                    self.docNameRP.text = chat?.replyMessage?.actualDocumentName
                    self.docSizeRp.text = chat?.replyMessage?.documentSize
                    self.DocTimeLblRP.isHidden = true
                    self.DocTimeLblRP.text = chat?.replyMessage?.chatTime
                }
                break
            default:
                break
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.wholeBGVIew.layer.cornerRadius = 13.0
        self.rplyView.layer.cornerRadius = 13.0
        self.textViewRP.layer.cornerRadius = 13.0
        self.imageViewRP.layer.cornerRadius = 13.0
        self.AudViewRP.layer.cornerRadius = 13.0
        self.DocViewRP.layer.cornerRadius = 13.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ReplyTVCell: Dequeueable {
    static func id() -> String {
        return String(describing: self)
    }
    
    static func hasNib() -> Bool {
        return true
    }
}

