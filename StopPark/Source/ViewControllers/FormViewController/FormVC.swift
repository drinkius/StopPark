//
//  FormVC.swift
//  StopPark
//
//  Created by Arman Turalin on 12/31/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

class FormVC: UIViewController {
    
    private var districtData = DistrictData.allCases
    
    private var eventInfoForm: [FormData: String] = [:]
    private var eventImages: [UIImage] = []
    private var requestForm = Form(.requestToServer)
    private lazy var tableView: UITableView = {
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
    
    private lazy var webView: WebView = {
        let w = WebView()
        w.delegate = self
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
    private lazy var loader: Loader = {
        let view = Loader()
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showWeb)))
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
        btn.contentEdgeInsets = .buttonItemContentInset
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(closeForm), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
        
    private lazy var sendFormView: SendFormView = {
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
        title = "Форма обращения"
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
        [webView, tableView, sendFormView, loader].forEach {
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
    
    private func openSendFormView() {        
        let indexPath = IndexPath(row: 0, section: requestForm.data.count + 1)
        let frame = tableView.rectForRow(at: indexPath).offsetBy(dx: -tableView.contentOffset.x, dy: -tableView.contentOffset.y)
        
        sendFormView.animateFillingBackground(with: frame) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func sendPreFinalRequest(with code: String) {
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
    
    private func showGeneratedMessage() {
        view.endEditing(true)
        guard eventImages.count > 0 else {
            InvAnalytics.shared.sendEvent(event: .formEditMessageRejectNoImage)
            showErrorMessage("Загрузите сначала фотографии.")
            return
        }
        guard let date = eventInfoForm[.eventDate],
            let auto = eventInfoForm[.autoMark],
            let num = eventInfoForm[.autoNumber],
            let addr = eventInfoForm[.eventAddress],
            let photoDate = eventInfoForm[.photoDate] else {
                InvAnalytics.shared.sendEvent(event: .formEditMessageRejectNotFilled)
                showErrorMessage("Вы заполнили не все пункты.")
                return
        }
        InvAnalytics.shared.sendEvent(event: .formClickEditMessage)
        let event = eventInfoForm[.eventViolation]
        let template = Strings.generateTemplateText(date: date, auto: auto, number: num, address: addr, photoDate: photoDate, eventViolation: event, imageCount: eventImages.count)
        let generatedMessage = eventInfoForm[.editedMessage] ?? template

        let vc = EditorVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.actionBlock = { [weak self] text in self?.eventInfoForm[.editedMessage] = text }
        vc.generatedMessage = generatedMessage
        present(vc, animated: true)
    }
    
    private func openPayVC() {
        let presenter = PayPresenter()
        presenter.destination = .pay
        let vc = PayVC(with: presenter)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - Actions
extension FormVC {
    @objc private func closeForm() {
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
    
    @objc private func showWeb() {
        view.bringSubviewToFront(webView)
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
            let cell: ImagesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.images = eventImages
            cell.destination = .single
            cell.delegate = self
            return cell
        case requestForm.data.count + 1:
            let cell: ButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case 0:
            let cell: ClosedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let formData = requestForm.data[indexPath.section].cells[indexPath.row].name
            let dataCount = requestForm.data[indexPath.section].cells.count
            cell.fill(with: formData, dataCount: dataCount, cellIndex: indexPath.row)
            return cell
        default:
            let cell: TextFieldCell = tableView.dequeueReusableCell(for: indexPath)            
            let formData = requestForm.data[indexPath.section].cells[indexPath.row].name
            let dataCount = requestForm.data[indexPath.section].cells.count
            cell.pickerDelegate = self
            cell.fill(with: formData, dataCount: dataCount, cellIndex: indexPath.row) { [unowned self] text in
                guard let text = text, !text.isEmpty else {
                    self.eventInfoForm[formData] = nil
                    return
                }
                
                InvAnalytics.shared.sendEvent(fillFormData: formData)
                if formData == .district {
                    self.eventInfoForm[formData] = String(text.dropLast(text.count - 2))
                    return
                }
                
                self.eventInfoForm[formData] = text
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
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == requestForm.data.count - 1 else { return nil }
        let footerView = ButtonFooterView()
        footerView.fill(buttonName: "Отредактировать сообщение",
                        editAction: { [weak self] in
                            self?.showGeneratedMessage()},
                        activateAction: { [weak self] in
                            self?.openPayVC()
        })
        return footerView
    }
}

// MARK: - ButtonTableViewCellDelegate
extension FormVC: ButtonTableViewCellDelegate {
    func send() {
        view.endEditing(true)
        guard Reachability.isConnectedToNetwork() else {
            showErrorMessage(Strings.notConnected)
            return
        }
        
        guard eventImages.count > 0 else {
            InvAnalytics.shared.sendEvent(event: .formSendFormRejectNoImage)
            showErrorMessage("Загрузите сначала фотографии.")
            return
        }
        
        guard let code = eventInfoForm[.district] else {
            InvAnalytics.shared.sendEvent(event: .formSendFormRejectNotFilled)
            showErrorMessage("Вы не заполнили пункт: \"\(FormData.district.rawValue)\"")
            return
        }

        guard let _ = eventInfoForm[.eventDate],
            let _ = eventInfoForm[.autoMark],
            let _ = eventInfoForm[.autoNumber],
            let _ = eventInfoForm[.eventAddress],
            let _ = eventInfoForm[.photoDate] else {
                InvAnalytics.shared.sendEvent(event: .formSendFormRejectNotFilled)
                showErrorMessage("Заполните все не опциональные пункты для генерации текста обращения.")
                return
        }
        
        if eventImages.count < 5 {
            InvAnalytics.shared.sendEvent(event: .formSendFormImageNotify)
            let continueAction = UIAlertAction(title: "Продолжить", style: .destructive, handler: { _ in
                InvAnalytics.shared.sendEvent(event: .formClickIgnoreImageNotify)
                self.continueSend(code: code)
            })
            let addMoreImagesAction = UIAlertAction(title: "Добавить еще фотографий", style: .default) { _ in
                InvAnalytics.shared.sendEvent(event: .formClickAcceptImageNotify)
            }
            showMessage("Рекомендуем добавлять как минимум 5 фото для успешного рассмотрения вашего дела.", addAction: [continueAction, addMoreImagesAction])
        } else {
            continueSend(code: code)
        }
    }
    
    private func continueSend(code: String) {
        InvAnalytics.shared.sendEvent(event: .formClickSendForm)
        Vibration.success.vibrate()
        openSendFormView()
                
        sendFormView.updateView(for: .uploadImages)
        webView.sendImageToServer(images: eventImages) { [weak self] result in
            switch result {
            case .failure(let text): self?.showErrorMessage(text)
            case .success(_): self?.sendPreFinalRequest(with: code)
            }
        }
    }
}

// MARK: - WebViewDelegate
extension FormVC: WebViewDelegate {
    func showWebViewError(_ text: String?) {
        showErrorMessage(text ?? Strings.cantGetData)
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
        sendFormView.updateView(for: .getCaptcha(url))
    }
    
    func showFinalBody() {
        InvAnalytics.shared.sendEvent(event: .formSuccessSend)
        sendFormView.updateView(for: .endSendFullForm)
    }
}

// MARK: - SendFormViewDelegate
extension FormVC: SendFormViewDelegate {
    func formVCShouldClose() {
        closeForm()
    }
    
    func formShouldSend(withCaptcha captcha: String) {
        InvAnalytics.shared.sendEvent(event: .formClickSendCaptcha)
        webView.finalLoadData(with: captcha)
    }
    
    func errorShouldShow(withText text: String) {
        showErrorMessage(text)
    }
    
    func requestShouldCancel() {
        closeForm()
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
        InvAnalytics.shared.sendEvent(event: .formClickAddImage)
        imagePicker.present()
    }

    func delete(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        guard let index = eventImages.firstIndex(of: image) else {
            return
        }
        InvAnalytics.shared.sendEvent(event: .formClickDeleteImage)
        eventImages.remove(at: index)
        
        let indexSet = IndexSet(integer: requestForm.data.count)
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
}
