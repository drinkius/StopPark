//
//  FormVC.swift
//  StopPark
//
//  Created by Arman Turalin on 12/31/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class FormVC: UIViewController {
    
    private var eventInfoForm: [FormData: String] = [:]
    private var eventImages: [UIImage] = []
    private var requestForm = Form(.requestToServer)
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.backgroundColor = .smokeWhite
        tw.showsVerticalScrollIndicator = false
        tw.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tw.register(ImagesTableViewCell.self, forCellReuseIdentifier: ImagesTableViewCell.identifier)
        tw.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tw.translatesAutoresizingMaskIntoConstraints = false
        return tw
    }()
    
    private lazy var webView: WebView = {
        let w = WebView()
        w.delegate = self
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
    private var loader: Loader = {
        let view = Loader()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var captureView: CaptchaView = {
        let view = CaptchaView()
        view.isHidden = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imagePicker: ImagePicker = {
        let picker = ImagePicker(presentationController: self, delegate: self)
        return picker
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let btn = UIButton()
        btn.setTitle("Отмена", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.layer.masksToBounds = true
        btn.backgroundColor = .highlited
        btn.contentEdgeInsets = Theme.buttonItemContentInset
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(closeForm), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        print("vc died")
    }
}

// MARK: - Private Functions
extension FormVC {
    private func setupView() {
        title = "Форма обращения"
        view.backgroundColor = .smokeWhite
        navigationItem.rightBarButtonItem = cancelButton
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        [webView, tableView, loader, captureView].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        [tableView.topAnchor.constraint(equalTo: view.topAnchor),
         tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
         tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
         webView.topAnchor.constraint(equalTo: view.topAnchor),
         webView.leftAnchor.constraint(equalTo: view.leftAnchor),
         webView.rightAnchor.constraint(equalTo: view.rightAnchor),
         webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
         loader.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -.nanoPadding),
         loader.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.nanoPadding),
      
         captureView.topAnchor.constraint(equalTo: view.topAnchor),
         captureView.leftAnchor.constraint(equalTo: view.leftAnchor),
         captureView.rightAnchor.constraint(equalTo: view.rightAnchor),
         captureView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
}

// MARK: - Actions
extension FormVC {
    @objc private func closeForm() {
        dismiss(animated: true)
    }
}

// MARK: - UITableView
extension FormVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return requestForm.data.count + 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case requestForm.data.count, requestForm.data.count + 1: return 1
        default: return requestForm.data[section].cells.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case requestForm.data.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagesTableViewCell.identifier, for: indexPath)
            if let imagesCell = cell as? ImagesTableViewCell {
                imagesCell.images = eventImages
                imagesCell.destination = .single
                imagesCell.delegate = self
            }
            return cell
        case requestForm.data.count + 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath)
            if let buttonCell = cell as? ButtonTableViewCell {
                buttonCell.delegate = self
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: indexPath)
            if let textFieldCell = cell as? TextFieldCell {
                
                if requestForm.data[indexPath.section].cells.count == 1 {
                    textFieldCell.destination = .single
                }

                if indexPath.row == 0 {
                    textFieldCell.destination = .top
                } else if indexPath.row == requestForm.data[indexPath.section].cells.count - 1 {
                    textFieldCell.destination = .bottom
                } else {
                    textFieldCell.destination = .middle
                }
                
                let name = requestForm.data[indexPath.section].cells[indexPath.row].name
                textFieldCell.fill(with: name.rawValue) { [unowned self] text in
                    guard let text = text else { return }
                    self.eventInfoForm[name] = text
                }
            }
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section <= requestForm.data.count else { return nil }
        let headerView = HeaderView()
        
        if section == requestForm.data.count {
            headerView.fill(with: "Прикрепите фотографии")
            return headerView
        }

        headerView.fill(with: requestForm.data[section].name)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case requestForm.data.count: return 80.0 + (2 * .padding)
        case requestForm.data.count + 1: return 44.0 + (2 * .nanoPadding)
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section <= requestForm.data.count - 1 else { return }
        guard let _ = tableView.cellForRow(at: indexPath) as? TextFieldCell else { return }
    }
}

// MARK: - ButtonTableViewCellDelegate
extension FormVC: ButtonTableViewCellDelegate {
    func send() {
        guard let _ = eventInfoForm[.district],
            let _ = eventInfoForm[.subDivision],
            let _ = eventInfoForm[.eventDate],
            let _ = eventInfoForm[.autoMark],
            let _ = eventInfoForm[.autoNumber],
            let _ = eventInfoForm[.eventAddress],
            let _ = eventInfoForm[.photoDate] else {
                showErrorMessage("Вы заполнили не все пункты.")
                return
        }

        webView.loadRequest(with: eventInfoForm)

        print(eventInfoForm)
        tableView.isHidden = true
    }
}

// MARK: - WebViewDelegate
extension FormVC: WebViewDelegate {
    func showError(_ text: String?) {
        showErrorMessage(text ?? "Ошибка загрузки.")
    }
    
    func loading() {
        loader.status = .loading
        print("start")
    }
    
    func done() {
        loader.status = .done
        print("loaded")
    }
    
    func showCapture(with url: URL?) {
        captureView.imageURL = url
        captureView.isHidden = false
    }
}

// MARK: - CaptureViewDelegate
extension FormVC: CaptureViewDelegate {
    func needsUpdateForm(with captcha: String) {
        webView.loadAppealRequest(with: captcha)
//        webView.loadAppealRequest()
    }
}

// MARK: - ImagePickerDelegate
extension FormVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        
        eventImages.append(image)
        
        let indexSet = IndexSet(integer: requestForm.data.count)
        tableView.reloadSections(indexSet, with: .none)
    }
}

// MARK: - ImageCollectionViewCellDelegate
extension FormVC: ImagesTableViewCellDelegate, ImageCollectionViewCellDelegate {
    func addImage() {
        imagePicker.present()
    }

    func delete(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        guard let index = eventImages.firstIndex(of: image) else {
            return
        }
        
        eventImages.remove(at: index)
        
        let indexSet = IndexSet(integer: requestForm.data.count)
        tableView.reloadSections(indexSet, with: .none)
    }
}

// MARK: - Support
extension FormVC {
    enum Theme {
        static let buttonItemCornerRadius: CGFloat = 5.0
        static let buttonItemContentInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
}
