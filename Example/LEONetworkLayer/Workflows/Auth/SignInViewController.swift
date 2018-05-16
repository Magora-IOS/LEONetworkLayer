import UIKit




class SignInViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    //MARK: - Properties
    var viewModel: SignInViewModel!
    
    
    @IBAction func submitAction(_ sender: Any) {
        self.viewModel.signIn(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "")
    }
}
