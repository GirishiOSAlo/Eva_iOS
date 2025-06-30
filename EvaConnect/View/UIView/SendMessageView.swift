//
//  SendMessageView.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 12/23/21.
//  Copyright © 2021 HyperNym. All rights reserved.
//

import UIKit

//class SendMessgeView: UIView {
//
//    var textView: UITextView = {
//        let tx = UITextView()
//        tx.translatesAutoresizingMaskIntoConstraints = false
//        tx.isScrollEnabled = false
//        tx.font = UIFont(defaultFontStyle: .regular, size: 17)
//        tx.sizeToFit()
//        tx.text = "Write a reply"
//        tx.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        return tx
//    }()
//
//    var sendButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setImage(#imageLiteral(resourceName: "send"), for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//
//    var addButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//
//        translatesAutoresizingMaskIntoConstraints = false
//        setLayout()
//        setTopSperatorLine()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setLayout() {
//
//        addSubview(textView)
//        addSubview(sendButton)
//        addSubview(addButton)
//
//        backgroundColor = .white
//        textView.delegate = self
//
//        NSLayoutConstraint.activate([
//            leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: -52),
//            trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 52),
//            bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
//            topAnchor.constraint(equalTo: textView.topAnchor)
//        ])
//
//        NSLayoutConstraint.activate([
//            trailingAnchor.constraint(equalTo: sendButton.trailingAnchor, constant: 16),
//            bottomAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 16),
//            sendButton.widthAnchor.constraint(equalToConstant: 40),
//            sendButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//
//        NSLayoutConstraint.activate([
//            leadingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -16),
//            sendButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
//            addButton.widthAnchor.constraint(equalToConstant: 40),
//            addButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//    }
//
//
//    private func setTopSperatorLine() {
//
//        let pinkView = UIView()
//        pinkView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
//
//        let darkBlueView = UIView()
//        darkBlueView.backgroundColor = #colorLiteral(red: 0.2352941176, green: 0.2470588235, blue: 0.3607843137, alpha: 1)
//
//        let stackView = UIStackView(arrangedSubviews: [pinkView, darkBlueView])
//        stackView.distribution = .fillEqually
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
//            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
//            topAnchor.constraint(equalTo: stackView.topAnchor),
//            stackView.heightAnchor.constraint(equalToConstant: 1)
//        ])
//    }
//}


//extension SendMessgeView: UITextViewDelegate {
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) {
//            textView.text = ""
//            textView.textColor = .black
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Write a reply"
//            textView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        }
//    }
//    
//}

