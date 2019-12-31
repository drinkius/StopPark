//
//  FromView.swift
//  StopPark
//
//  Created by Arman Turalin on 12/13/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class FormView: BaseView {
    
    public var formDestination: Form.Destination = .requestToServer {
        didSet { form.updateData(for: formDestination); tableView.reloadData() }
    }
    
    private lazy var form = Form(formDestination)
    private lazy var tableView: UITableView = {
        let tw = UITableView()
        tw.allowsSelection = false
        tw.separatorStyle = .none
        tw.delegate = self
        tw.dataSource = self
        tw.register(TextInputCell.self, forCellReuseIdentifier: TextInputCell.identifier)
        tw.register(ImageInputCell.self, forCellReuseIdentifier: ImageInputCell.identifier)
        tw.translatesAutoresizingMaskIntoConstraints = false
        return tw
    }()
    
    override func setupView() {
        super.setupView()
        configureViews()
        configureConstraints()
    }
}

// MARK: - Private Functions
extension FormView {
    private func configureViews() {
        [tableView].forEach {
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [tableView.topAnchor.constraint(equalTo: topAnchor),
         tableView.leftAnchor.constraint(equalTo: leftAnchor),
         tableView.rightAnchor.constraint(equalTo: rightAnchor),
         tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FormView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if formDestination == .requestToServer {
            return form.data.count + 1
        }
        return form.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.data[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.data[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextInputCell.identifier, for: indexPath)
        if let textInputCell = cell as? TextInputCell {
            textInputCell.fill(with: form.data[indexPath.section].cells[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .cellHeight
    }
}
