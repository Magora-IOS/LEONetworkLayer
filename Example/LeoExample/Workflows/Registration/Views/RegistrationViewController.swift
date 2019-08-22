

import UIKit
import RxSwift

class RegistrationViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    lazy var backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onBackButtonTap))
    
    private var userNameField: UITextField!
    private var emailField: UITextField!
    private var zipField: UITextField!
    
    private var disposeBag = DisposeBag()
    
    private let viewModel: RegistrationViewModel
    
    // MARK: lifecycle
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupRx()
    }
    
    private func setupViews() {
        self.title = ""
        self.titleLabel.text = L10n.Authetication.Registration.title
        self.messageLabel.text = L10n.Authetication.Registration.message
        self.errorLabel.text = ""
        
        self.userNameField = addTextField(placeHolder: L10n.Authetication.Message.enterName, type: .namePhonePad)
        self.emailField = addTextField(placeHolder: L10n.Authetication.Message.enterEmail, type: .emailAddress)
        self.zipField = addTextField(placeHolder: L10n.Authetication.Message.enterZip, type: .numbersAndPunctuation)
        self.navigationItem.rightBarButtonItem = self.backButton
        
        self.nextButton.addTarget(self, action: #selector(nextButtonTap(_:)), for: .touchUpInside)
        self.loadingIndicator.transform = CGAffineTransform(scaleX: 2, y: 2) 
    }
    
    private func addTextField(placeHolder: String, type: UIKeyboardType = .default) -> UITextField {
        var textField: UITextField
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50));
        textField.keyboardType = type
        textField.placeholder = placeHolder
        textField.textAlignment = .center
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.keyboardAppearance = .dark
        textField.clearButtonMode = .whileEditing
        
        let heightConstraint = textField.heightAnchor.constraint(equalToConstant: 50)
        textField.addConstraints([heightConstraint])
        
        self.stackView.addArrangedSubview(textField)
        return textField
    }
    
    @objc func onBackButtonTap() {
        self.viewModel.exit()
    }
    
    @objc func nextButtonTap(_ sender: UIButton) {
        self.viewModel.name  = userNameField.text
        self.viewModel.email = emailField.text
        self.viewModel.zip = zipField.text
        self.viewModel.sendData()
    }
    
    func setupRx() {
        self.viewModel.state.subscribe(onNext: {
            [unowned self] state in
            //loading
            if case .loading = state {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
            
            //error
            if case .dataError(let message) = state {
                self.errorLabel.text = message
            } else {
                self.errorLabel.text = ""
            }
            
        }).disposed(by: self.disposeBag)
    }
}


