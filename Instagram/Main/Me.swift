import UIKit
import FirebaseCore
import FirebaseAuth

class Me: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//MARK: - Variable
    
    @IBOutlet weak var ChangeProfileButton: UIButton!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    //Variable_End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout //
        ChangeProfileButton.layer.borderWidth = 2
        ChangeProfileButton.layer.borderColor = GrayColor
        ChangeProfileButton.layer.cornerRadius = 5
        
        ProfileImage.layer.cornerRadius = ProfileImage.frame.width / 2
        ProfileImage.clipsToBounds = true
        
    }

//MARK: - Action
    
    // Sign Out //
    @IBAction func SignOut(_ sender: Any) {
        let UserID = Auth.auth().currentUser
        let AlertController = UIAlertController(title: "\(UserID!) 에서 로그아웃하시겠어요?", message: nil, preferredStyle: UIAlertController.Style.alert)
        AlertController.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: {
            action in
            try! Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLogin", sender: self)
        }))
        AlertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        AlertController.view.tintColor = .black
        present(AlertController, animated: true, completion: nil)
    }
    
    // Change Profile Image //
    @IBAction func ChangeProfileImage(_ sender: Any) {
        let ImagePickerController = UIImagePickerController()
        ImagePickerController.delegate = self
        ImagePickerController.allowsEditing = true
        present(ImagePickerController, animated: true, completion: nil)
        
    }
    
//Action_End
    
    
//MARK: - Funcion
    // Change Profile Image //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var SelectedImage = UIImage()
        
        if let EditedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            SelectedImage = EditedImage
        } else if let OriginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            SelectedImage = OriginalImage
        }
        ProfileImage.image = SelectedImage
        self.dismiss(animated: true, completion: nil)
        
    }
//Function_End
    
}
