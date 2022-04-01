//
//  LoginViewController.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import UIKit

class LoginViewController: UIViewController {
    private var pageType: AuthPage = .login
    private var cdStack: CoreDataStack?
    private var viewModel: AuthVMGuideline?
    
    private let scrollingView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bouncesZoom = false
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    
    private let stackViewParent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.layoutMargins.top = 10
        stackView.layoutMargins.right = 8
        stackView.layoutMargins.left = 8
        return stackView
    }()
    
    private let stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.layoutMargins.top = 10
        stackView.layoutMargins.right = 0
        return stackView
    }()
    
    private let stackAuthForm: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.layoutMargins.left = 0
        stackView.layoutMargins.right = 0
        return stackView
    }()
    
    private let stackButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.layoutMargins.left = 0
        stackView.layoutMargins.right = 0
        return stackView
    }()
    
    private let lblUserName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "Username: "
        return label
    }()
    
    private let lblPassword: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .clear
        label.textColor = .black
        label.text = "Password: "
        return label
    }()
    
    private let txtUserName: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .default
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.textColor = .black
        return textField
    }()
    
    private let txtPassword: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.keyboardType = .default
        textField.backgroundColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.textColor = .black
        return textField
    }()
    
    private let btnMasking: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "passShow"), for: .normal)
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private let btnRegister: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .cyan
        return button
    }()
    
    private let btnLogin: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .cyan
        return button
    }()
    
    private let btnLginGuest: UIButton = {
        let button = UIButton()
        button.setTitle("Login as Guest", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .cyan
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = ListColor.abuTanggung
        self.navigationItem.title = pageType.rawValue
        setupOutlet()
        setupConstraints()
        setupAtion()
        setUIType()
        if let getCDStack = cdStack {
            viewModel = AuthViewModel(useCase: UserDataSource(cdStack: getCDStack))
            bind()
        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(page type: AuthPage, coredata cdStack: CoreDataStack) {
        self.init(nibName: nil, bundle: nil)
        self.pageType = type
        self.cdStack = cdStack
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setupOutlet() {
        self.view.addSubview(scrollingView)
        self.scrollingView.addSubview(lblUserName)
        self.scrollingView.addSubview(lblPassword)
        self.scrollingView.addSubview(txtUserName)
        self.scrollingView.addSubview(txtPassword)
        self.scrollingView.addSubview(stackAuthForm)
        self.scrollingView.addSubview(stackButton)
        self.scrollingView.addSubview(stackViewParent)
        self.scrollingView.addSubview(stackViewContent)
        self.scrollingView.addSubview(btnMasking)
        
        let stackAuthUsername: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 5
            stackView.layoutMargins.left = 0
            stackView.layoutMargins.right = 0
            return stackView
        }()
        self.scrollingView.addSubview(stackAuthUsername)
        stackAuthUsername.addArrangedSubview(lblUserName)
        stackAuthUsername.addArrangedSubview(txtUserName)
        
        let stackAuthPassword: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 5
            stackView.layoutMargins.left = 0
            stackView.layoutMargins.right = 0
            return stackView
        }()
        let stackPasswordtextBox: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = 0
            return stackView
        }()
        self.scrollingView.addSubview(stackAuthPassword)
        self.scrollingView.addSubview(stackPasswordtextBox)
        stackPasswordtextBox.addArrangedSubview(txtPassword)
        stackPasswordtextBox.addArrangedSubview(btnMasking)
        stackAuthPassword.addArrangedSubview(lblPassword)
        stackAuthPassword.addArrangedSubview(stackPasswordtextBox)
        
        stackAuthForm.addArrangedSubview(stackAuthUsername)
        stackAuthForm.addArrangedSubview(stackAuthPassword)
        
        stackButton.addArrangedSubview(btnRegister)
        stackButton.addArrangedSubview(btnLogin)
        stackButton.addArrangedSubview(btnLginGuest)
        
        stackViewContent.addArrangedSubview(stackAuthForm)
        stackViewContent.addArrangedSubview(stackButton)
        stackViewParent.addArrangedSubview(stackViewContent)
    }
    
    private func setupConstraints() {
        let views: [String: Any] = ["scrollingView": scrollingView, "stackViewParent": stackViewParent, "lblUserName": lblUserName, "lblPassword": lblPassword, "txtUserName": txtUserName, "txtPassword": txtPassword, "btnMasking": btnMasking, "stackAuthForm": stackAuthForm, "stackButton": stackButton, "stackViewContent": stackViewContent]
        let matrix: [String: Any] = [:]
        var contraints: [NSLayoutConstraint] = []
        
        // MARK: scrollingView constraints
        scrollingView.translatesAutoresizingMaskIntoConstraints = false
        let vScrollingView = "V:|-[scrollingView]-|"
        let hScrollingView = "H:|-[scrollingView]-|"
        contraints += NSLayoutConstraint.constraints(withVisualFormat: vScrollingView, options: .alignAllLeading, metrics: matrix, views: views)
        contraints += NSLayoutConstraint.constraints(withVisualFormat: hScrollingView, options: .alignAllTop, metrics: matrix, views: views)
        
        // MARK: stackViewContent constraints
        stackViewParent.translatesAutoresizingMaskIntoConstraints = false
        let vStackViewContent = "V:|-0-[stackViewParent]-0-|"
        let hStackViewContent = "H:|-0-[stackViewParent]-0-|"
        contraints += NSLayoutConstraint.constraints(withVisualFormat: vStackViewContent, options: .alignAllLeading, metrics: matrix, views: views)
        contraints += NSLayoutConstraint.constraints(withVisualFormat: hStackViewContent, options: .alignAllTop, metrics: matrix, views: views)
        contraints += [NSLayoutConstraint(item: stackViewParent, attribute: .width, relatedBy: .equal, toItem: scrollingView, attribute: .width, multiplier: 1, constant: 0)]
        contraints += [NSLayoutConstraint(item: stackViewParent, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)]
        
        // MARK: lblPassword constraints
        lblPassword.translatesAutoresizingMaskIntoConstraints = false
        
        contraints += [NSLayoutConstraint(item: lblPassword, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 2/5, constant: 0)]
        
        // MARK: lblUserName constraints
        lblUserName.translatesAutoresizingMaskIntoConstraints = false
        contraints += [NSLayoutConstraint(item: lblUserName, attribute: .width, relatedBy: .equal, toItem: lblPassword, attribute: .width, multiplier: 1, constant: 0)]
        
        // MARK: btnMasking constraints
        btnMasking.translatesAutoresizingMaskIntoConstraints = false
        contraints += [NSLayoutConstraint(item: btnMasking, attribute: .width, relatedBy: .equal, toItem: txtPassword, attribute: .width, multiplier: 1.3/9, constant: 0)]
        
        // MARK: stackAuthForm constraints
        stackAuthForm.translatesAutoresizingMaskIntoConstraints = false
        contraints += [NSLayoutConstraint(item: stackAuthForm, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 2/9, constant: 0)]
        
        // MARK: stackButton constraints
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        contraints += [NSLayoutConstraint(item: stackButton, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.5/9, constant: 0)]
        
        NSLayoutConstraint.activate(contraints)
    }
    
    private func setupAtion() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        btnRegister.addTarget(self, action: #selector(toRegister(_:)), for: .touchDown)
        btnMasking.addTarget(self, action: #selector(maskingPassword(_:)), for: .touchDown)
        btnLogin.addTarget(self, action: #selector(doLogin(_:)), for: .touchDown)
        btnLginGuest.addTarget(self, action: #selector(guestLogin(_:)), for: .touchDown)
    }
    
    private func setUIType() {
        if pageType == .register {
            btnLogin.isHidden = true
            btnLginGuest.isHidden = true
        }
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.stackViewParent.frame.origin.y == 0{
                self.stackViewParent.frame.origin.y -= 100
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.stackViewParent.frame.origin.y != 0{
                self.stackViewParent.frame.origin.y = 0
            }
        }
    }
    
    @objc private func toRegister(_ sender: UIButton) {
        if pageType == .login {
            guard let getCDStack = cdStack else {
                return
            }
            let loginPage = LoginViewController(page: .register, coredata: getCDStack)
            let nav = UINavigationController(rootViewController: loginPage)
            
            present(nav, animated: true, completion: nil)
        } else {
            guard let getUserName = txtUserName.text, let getPassword = txtPassword.text, getUserName != "", getPassword != "" else {
                
                let alert = UIAlertController(title: "Error", message: "username dan password tidak boleh kosong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            viewModel?.createUser(user: UserInfo(name: getUserName, pass: getPassword, isGuest: false))
        }
        
    }
    
    @objc private func maskingPassword(_ sender: UIButton) {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
    }
    
    @objc private func doLogin(_ sender: UIButton) {
        guard let getUserName = txtUserName.text, let getPassword = txtPassword.text, getUserName != "", getPassword != "" else {
            
            let alert = UIAlertController(title: "Error", message: "username dan password tidak boleh kosong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        viewModel?.loginUser(user:  UserInfo(name: getUserName, pass: getPassword, isGuest: false))
        
    }
    @objc private func guestLogin(_ sender: UIButton) {
        viewModel?.loginUser(user:  UserInfo(name: "guest", pass: "guest", isGuest: true))
    }
    
}

extension LoginViewController {
    private func bind() {
        viewModel?.loginResponse = { [weak self] _ in
            DispatchQueue.main.async {
                
                guard let superSelf = self, let getCoreData = superSelf.cdStack else {
                    return
                }
                
                let homeVC = HomeViewController(coredata: getCoreData)
                
                let nav = UINavigationController(rootViewController: homeVC)
                UIApplication.shared.windows.first?.rootViewController = nav
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
        viewModel?.authResponse = { [weak self] _ in
            DispatchQueue.main.async {
                guard let superSelf = self else {
                    return
                }
                
                if superSelf.pageType == .register {
                    let alert = UIAlertController(title: "Register", message: "Register Berhasil", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { _ in
                        superSelf.dismiss(animated: true, completion: nil)
                    }))
                    superSelf.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        viewModel?.errorReponse = { [weak self] error in
            DispatchQueue.main.async {
                guard let superSelf = self else {
                    return
                }
                print("Auth error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                superSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
}
