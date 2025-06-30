//
//  BottomContentPicker.swift
//  EvaConnect
//
//  Created by Muhammad Salman Zafar on 1/4/22.
//  Copyright © 2022 HyperNym. All rights reserved.
//

import UIKit

protocol BottomContentPickerDelegate: NSObject {
    func didSelectContentPicker(_ content: BottomContentPicker.BottomContentType)
}

class BottomContentPicker: UIView {
    
    enum BottomContentType: String {
        case photo  = "ic_picture"
        case document = "ic_document"
        case link = "ic_url_link"
        case event = "ic_event"
        case meeting = "ic_meeting"
        case note = "ic_note"
        case conversation = "ic_share_conversation"
        case whatsapp = "ic_share_whatsapp"
        case other = "ic_share_other"
    }
    
    private let tableView: UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .white
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.tableFooterView = UIView()
        return tb
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        Constants.setUpperCornerRadius(uiView: view, radius: 20)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private var bottomConst: NSLayoutConstraint!
    private var heightConst: NSLayoutConstraint!
    private var contentView: UIView!
    private var heightSize: CGFloat = 0
    private var contents = [(title: String, type: BottomContentPicker.BottomContentType)]()
    weak var delegate: BottomContentPickerDelegate? = nil
    var data: Any? = nil
    var userId: Any? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(contents: [(title: String, type: BottomContentPicker.BottomContentType)]) {
        super.init(frame: .zero)
        self.contents = contents
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BottomContentPicker {
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
//        setTopSperatorLine()
        setTableView()
    }
    
    private func setTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(withType: BottomContentPickerCell.self)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: tableView.topAnchor, constant: -4),
            leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: -36),
            trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 37),
            bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])

        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainViewTapped)))
    }
    
    private func setTopSperatorLine() {
        
        let pinkView = UIView()
        pinkView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
        
        let darkBlueView = UIView()
        darkBlueView.backgroundColor = #colorLiteral(red: 0.2352941176, green: 0.2470588235, blue: 0.3607843137, alpha: 1)
        
        let stackView = UIStackView(arrangedSubviews: [pinkView, darkBlueView])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            topAnchor.constraint(equalTo: stackView.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    func addConstraint(_ view: UIView) {
        
        contentView = view
        contentView.addSubview(self)
        let count = CGFloat(contents.count)
        heightSize = (50 * (count == 0 ? 1 : count)) + 55

        bottomConst = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: heightSize * -1)
        heightConst = heightAnchor.constraint(equalToConstant: heightSize >= 560 ? 560 : heightSize)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomConst, heightConst
        ])
        
        tableView.isScrollEnabled = heightSize >= 560
        
        Constants.setUpperCornerRadius(uiView: view, radius: 25)
        view.addSubview(mainView)
        view.insertSubview(mainView, belowSubview: self)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            view.topAnchor.constraint(equalTo: mainView.topAnchor),
            view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
    }
    
    func presentView(hide: Bool = false) {
        mainView.isHidden = hide
        UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1.0) {
            self.mainView.backgroundColor = hide ? .clear : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.bottomConst.constant = hide ? (-1 * self.heightSize) : 0
            self.contentView.layoutIfNeeded()
        }.startAnimation()
    }

    @objc func mainViewTapped() { presentView(hide: true) }
}

extension BottomContentPicker: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { contents.count  }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BottomContentPickerCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.content = contents[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 50 }
}

extension BottomContentPicker: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentView(hide: true)
        delegate?.didSelectContentPicker(contents[indexPath.item].type)
    }
}
