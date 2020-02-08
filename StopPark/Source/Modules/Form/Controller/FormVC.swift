//
//  FormVC.swift
//  StopPark
//
//  Created by Arman Turalin on 12/31/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class FormVC: UIViewController {
        
    var sections: [Section] {
        var sections: [Section] = []
        
        sections += [
            Section(type: .from(Str.Form.sectionFrom), rows: FormData.fromData.map { Section.RowType.privacy($0) }),
            Section(type: .to(Str.Form.sectionTo), rows: FormData.toData.map { Section.RowType.form($0) }),
            Section(type: .messageData(Str.Form.sectionMessage), rows: FormData.messageData.map { Section.RowType.form($0) }),
            (Section(type: .images(Str.Form.sectionImages), rows: [.image])),
            (Section(type: .buttons, rows: [.button]))
        ]
        
        return sections
    }
    
    let router: RouterProtocol

    private var districtData = DistrictData.allCases
    
    var eventInfoForm: [FormData: String] = [:]
    var eventImages: [UIImage] = []
    lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.backgroundColor = .themeBackground
        tw.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tw.showsVerticalScrollIndicator = false
        [TextFieldCell.self, ClosedTableViewCell.self, ImagesTableViewCell.self, ButtonTableViewCell.self].forEach { tw.register($0)}
        tw.translatesAutoresizingMaskIntoConstraints = false
        return tw
    }()
    
    lazy var webView: WebView = {
        let w = WebView()
        w.delegate = self
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
    private lazy var loader: Loader = {
        let view = Loader()
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onShowWeb)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imagePicker: ImagePicker = {
        let picker = ImagePicker(presentationController: self, delegate: self)
        return picker
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let btn = UIButton()
        btn.setTitle(Str.Generic.cancel, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = Theme.buttonItemCornerRadius
        btn.layer.masksToBounds = true
        btn.backgroundColor = .highlited
        btn.contentEdgeInsets = .buttonItemContentInset
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(onCloseForm), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
        
    lazy var sendFormView: SendFormView = {
        let view = SendFormView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.initialRequest()
//        updateTemplates()
    }
    
    init(router: RouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.router.baseViewController = self
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    deinit {
        UserDefaultsManager.setSession(nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
        print("vc died")
    }
}

// MARK: - Private Functions
extension FormVC {
    private func setupView() {
        title = Str.Form.title
        view.backgroundColor = .themeBackground
        navigationItem.rightBarButtonItem = cancelButton
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .themeContainer
        
        hideKeyboardWhenTappedAround()
        observeKeyboard()
        configureViews()
        configureConstraints()
    }
    
    private func configureViews() {
        [webView, loader, tableView, sendFormView].forEach {
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
         
         sendFormView.topAnchor.constraint(equalTo: view.topAnchor),
         sendFormView.leftAnchor.constraint(equalTo: view.leftAnchor),
         sendFormView.rightAnchor.constraint(equalTo: view.rightAnchor),
         sendFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
    }
    
    func openSendFormView() {
        guard let buttonSectionIndex = sections.firstIndex(where: { $0.type.index == Section.SectionType.buttons.index }) else { return }
        let indexPath = IndexPath(row: 0, section: buttonSectionIndex)
        let frame = tableView.rectForRow(at: indexPath).offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y)
        
        sendFormView.animateFillingBackground(with: frame) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func sendPreFinalRequest(with code: String) {
        sendFormView.updateView(for: .startSendFullForm)
        webView.getSubUnitCode(with: code) { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let text): self.showErrorMessage(text)
                case .success(let data):
                    guard let code = data as? String else {
                        return
                    }

                    self.eventInfoForm[.subDivision] = code
                    self.webView.preFinalLoadData(self.eventInfoForm)
                    print(self.eventInfoForm)
                }
            }
        }
    }
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
        
    private func updateTemplates() {
        guard let buttonSectionIndex = sections.firstIndex(where: { $0.type.index == Section.SectionType.messageData(Str.Form.sectionMessage).index }) else { return }
        let indexPath = IndexSet(integer: buttonSectionIndex)
        tableView.reloadSections(indexPath, with: .fade)
    }
}

// MARK: - Actions
extension FormVC {
    @objc private func onCloseForm() {
        InvAnalytics.shared.sendEvent(event: .formClickCancel)
        Vibration.light.vibrate()
        dismiss(animated: true)
    }
    
    @objc private func onKeyboardWillShow(_ notification: Notification) {
        guard sendFormView.isHidden else {
            sendFormView.onKeyboard(notification)
            return
        }
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let height = keyboardFrame?.height ?? 243

        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    }
    
    @objc private func onKeyboardWillHide(_ notification: Notification) {
        guard sendFormView.isHidden else {
            sendFormView.onKeyboard(notification)
            return
        }
        tableView.contentInset = .zero
    }
    
    @objc private func onShowWeb() {
        view.bringSubviewToFront(webView)
    }
}

// MARK: - WebViewDelegate
extension FormVC: WebViewDelegate {
    func loading() {
        loader.status = .loading
        print("start")
    }
    
    func done() {
        loader.status = .done
        print("loaded")
    }
    
    func webView(_ webView: WebView, didReceiveCaptchaURL url: URL) {
        sendFormView.updateView(for: .getCaptcha(url))
    }
    
    func webView(_ webView: WebView, didReceiveError error: String) {
        showErrorMessage(error)
    }
    
    func showFinalBody() {
        InvAnalytics.shared.sendEvent(event: .formSuccessSend)
        sendFormView.updateView(for: .endSendFullForm)
    }
}

// MARK: - ImagePickerDelegate
extension FormVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        
        guard let buttonSectionIndex = sections.firstIndex(where: { $0.type.index == Section.SectionType.images(Str.Form.sectionImages).index }) else { return }

        
        eventImages.append(image)
        
        let indexSet = IndexSet(integer: buttonSectionIndex)
        tableView.reloadSections(indexSet, with: .none)
    }
}

// MARK: - UIPickerView
extension FormVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return districtData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return districtData[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TextFieldCell else { return }
        cell.textFieldText = districtData[row].rawValue
    }
}

// MARK: - Support
extension FormVC {
    enum Theme {
        static let buttonItemCornerRadius: CGFloat = 5.0
    }
    
    struct Section {
        enum SectionType {
            case from(String), to(String), messageData(String), images(String), buttons
            
            var index: Int {
                switch self {
                case .from:         return 0
                case .to:           return 1
                case .messageData:  return 2
                case .images:       return 3
                case .buttons:      return 4
                }
            }
        }
        enum RowType {
            case privacy(FormData)
            case form(FormData)
            case image
            case button
        }
        
        let type: SectionType
        var rows: [RowType]
    }
}