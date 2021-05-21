import UIKit
import FirebaseCore
import FirebaseAuth

class Login: UIViewController {

//MARK: - Varible
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
//Variable_End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gesture //
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard(_:)))
        view.addGestureRecognizer(TapGesture)
        
        // Layout //
        LoginButton.layer.cornerRadius = 5
        
        EmailTextField.layer.cornerRadius = 5
        EmailTextField.layer.borderWidth = 2
        EmailTextField.layer.borderColor = CGColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        PasswordTextField.layer.cornerRadius = 5
        PasswordTextField.layer.borderWidth = 2
        PasswordTextField.layer.borderColor = CGColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
    }
    
//MARK: - Action
    @IBAction func Login(_ sender: Any) {
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PasswordTextField.text!, completion: {
            user, error in if error != nil {
                if let ErrorCode = FirebaseAuth.AuthErrorCode(rawValue: (error?._code)!){
                    switch ErrorCode {
                    case .invalidEmail:
                        let AlertController = UIAlertController(title: "Instagram", message: "이메일을 입력해 주세요", preferredStyle: UIAlertController.Style.alert)
                        AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
                        self.present(AlertController, animated: true, completion: nil)
                        
                    case .wrongPassword:
                        let AlertController = UIAlertController(title: "Instagram", message: "잘못된 비밀번호입니다", preferredStyle: UIAlertController.Style.alert)
                        AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
                        self.present(AlertController, animated: true, completion: nil)
                        
                    case .userNotFound:
                        let AlertController = UIAlertController(title: "Instagram", message: "등록되지 않은 사용자입니다", preferredStyle: UIAlertController.Style.alert)
                        AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
                        self.present(AlertController, animated: true, completion: nil)
                        
                    default:
                        print("Sign in Error: \(error!)")
                    }
                }
            } else { //오류가 없다면
                let AlertController = UIAlertController(title: "Instagram", message: "다시 오셨네요, 반갑습니다", preferredStyle: UIAlertController.Style.alert)
                AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                    action in self.performSegue(withIdentifier: "toMain", sender: self)
                }))
                self.present(AlertController, animated: true, completion: nil)
                
            }
        })
    }
//Action_End
    
//MARK: - Function
    @objc func DismissKeyboard(_ sender: AnyObject){
        view.endEditing(true)
    }
    
//Function_End
    
    
}
