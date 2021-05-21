import UIKit
import FirebaseCore
import FirebaseAuth

class SignUp: UIViewController {

//MARK: - Variable
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    //Variable_End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gesture //
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard(_:)))
        view.addGestureRecognizer(TapGesture)

        // Layout //
        NextButton.layer.cornerRadius = 5
       
        EmailTextField.layer.borderWidth = 2
        EmailTextField.layer.borderColor = GrayColor
        EmailTextField.layer.cornerRadius = 5
        
        PasswordTextField.layer.borderWidth = 2
        PasswordTextField.layer.borderColor = GrayColor
        PasswordTextField.layer.cornerRadius = 5
    }
    
//MARK: - Action
    @IBAction func SignUp(_ sender: Any) {
        if EmailTextField.text == "" || EmailTextField.text == "이메일 주소" {
            let AlertController = UIAlertController(title: "Instagram", message: "이메일 주소를 입력해 주세요", preferredStyle: UIAlertController.Style.alert)
            AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            self.present(AlertController, animated: true, completion: nil)
        } else if PasswordTextField.text == "" || PasswordTextField.text == "비밀번호" {
            let AlertController = UIAlertController(title: "Instagram", message: "비밀번호를 입력해 주세요", preferredStyle: UIAlertController.Style.alert)
            AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            self.present(AlertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!, completion: {
                user, error in if error != nil {
                    if let ErrorCode = FirebaseAuth.AuthErrorCode(rawValue: (error?._code)!) {
                        switch ErrorCode {
                        case .invalidEmail:
                            let AlertController = UIAlertController(title: "Instagram", message: "이메일을 입력해 주세요", preferredStyle: UIAlertController.Style.alert)
                            AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
                            self.present(AlertController, animated: true, completion: nil)
                            
                        case .weakPassword:
                            let AlertController = UIAlertController(title: "Instagram", message: "비밀번호는 6자 이상 입력해 주세요", preferredStyle: UIAlertController.Style.alert)
                            AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
                            self.present(AlertController, animated: true, completion: nil)
                            
                        case.emailAlreadyInUse:
                            let AlertController = UIAlertController(title: "Instagram", message: "이미 사용중인 이메일입니다", preferredStyle: UIAlertController.Style.alert)
                            AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
                            self.present(AlertController, animated: true, completion: nil)
                            
                        default:
                            print("Sign Up Error : \(error!)")
                        }
                    }
                    
                } else { //오류가 없다면
                    let AlertController = UIAlertController(title: "Instagram", message: "환영합니다", preferredStyle: UIAlertController.Style.alert)
                    AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                        action in self.SignUp()
                    }))
                    self.present(AlertController, animated: true, completion: nil)
                }
            })
            
        }
        
    }
//Action_End
    
//MARK: - Function
    
    // SignUp //
    func SignUp(){
        
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PasswordTextField.text!, completion: {
            user, error in
            
            let st = self.EmailTextField.text!
            let index = st.firstIndex(of: "@")
            let UserID = st[st.startIndex..<index!]
            let UserData : [String : String] = ["UserID" : String(UserID), "UserName" : String(UserID), "ProfileImageURL" : "https://firebasestorage.googleapis.com/v0/b/instagram-1066b.appspot.com/o/ProfileImage%403x.png?alt=media&token=49eb2bc2-db5c-477e-8a91-c427bd48e4ba"]
            let UserEmail = Auth.auth().currentUser?.uid
            DatabaseReference.child("User").child(UserEmail!).updateChildValues(UserData)
            
            self.performSegue(withIdentifier: "toMain", sender: self)
        })
    }
    
    // Keyboard //
    @objc func DismissKeyboard(_ sender: AnyObject){
        view.endEditing(true)
    }
//Function_End
    
    
}
