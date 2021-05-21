import UIKit
import FirebaseCore
import FirebaseAuth

class Forgot: UIViewController {

//MARK: - Variable
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    //Variable_End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gesture //
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard(_:)))
        view.addGestureRecognizer(TapGesture)
        
        // Layout //
        EmailTextField.layer.cornerRadius = 5
        EmailTextField.layer.borderWidth = 2
        EmailTextField.layer.borderColor = CGColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        NextButton.layer.cornerRadius = 5

    }
    
//MARK: - Function
    @objc func DismissKeyboard(_ sender:AnyObject){
        view.endEditing(true)
    }
//Function_End
    
//MARK: - Action
    @IBAction func Next(_ sender: Any) {
        if EmailTextField.text == "" || EmailTextField.text == "사용자 이름 또는 이메일" {
            let AlertController = UIAlertController(title: "Instagram", message: "이메일을 입력해 주세요", preferredStyle: UIAlertController.Style.alert)
            AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            self.present(AlertController, animated: true, completion: nil)
        } else {
            Auth.auth().sendPasswordReset(withEmail: EmailTextField.text!, completion: {
                error in
                var Message = ""
                if error != nil {
                    Message = (error?.localizedDescription)!
                } else {
                    Message = "계정에 다시 로그인할 수 있는 링크가 포함된 이메일을 " + self.EmailTextField.text! + "주소로 보내드렸습니다."
                    self.EmailTextField.text = ""
                }
                
                let AlertController = UIAlertController(title: "이메일 링크를 전송했습니다", message: Message, preferredStyle: UIAlertController.Style.alert)
                AlertController.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
                self.present(AlertController, animated: true, completion: nil)
            })
        }
        
    }
    
//Action_End
    
}
