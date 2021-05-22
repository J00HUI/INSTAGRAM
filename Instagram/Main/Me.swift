import UIKit
import FirebaseCore
import FirebaseAuth

class Me: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//MARK: - Variable
    
    @IBOutlet weak var ChangeProfileButton: UIButton!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var UserIDLabel: UILabel!
    @IBOutlet weak var UserNameTextView: UITextView!
    
    //Variable_End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout //
        ChangeProfileButton.layer.borderWidth = 2
        ChangeProfileButton.layer.borderColor = GrayColor
        ChangeProfileButton.layer.cornerRadius = 5
        
        ProfileImage.layer.cornerRadius = ProfileImage.frame.width / 2
        ProfileImage.clipsToBounds = true
        
        // DB에서 받아오기 //
        let UserEmail = Auth.auth().currentUser?.uid
        DatabaseReference.child("User").child("\(UserEmail!)").observeSingleEvent(of: .value, with: { snapshot in
            if let UserDictionary = snapshot.value as? [String : AnyObject] {
                
                let ProfileImageURLAddress = UserDictionary["ProfileImageURL"] as! String
                let ProfileImageURL = URL(string: ProfileImageURLAddress)
                
                //*URL로 부터 다운로드
                URLSession.shared.dataTask(with: ProfileImageURL!){
                    (data, response, error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.ProfileImage.image = UIImage(data: data!)
                        }
                    }
                }.resume()
                
                let userName = UserDictionary["UserName"] as! String
                let userID = UserDictionary["UserID"] as! String
                self.UserIDLabel.text = userID
                self.UserNameTextView.text = userName
            }
        })
        
    }

//MARK: - Action
    
    // Sign Out //
    @IBAction func SignOut(_ sender: Any) {
        let AlertController = UIAlertController(title: UserIDLabel.text! + " 에서 로그아웃하시겠어요?", message: nil, preferredStyle: UIAlertController.Style.alert)
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
        
        // Change DB Profile Image //
        let UserEmail = Auth.auth().currentUser?.uid
        let AutoID = DatabaseReference.childByAutoId().key
        let ImageData = SelectedImage.jpegData(compressionQuality: 0.1)
        let StorageRef = StorageReference.child("ProfileImage").child("\(AutoID!)" + ".jpg")
        StorageRef.putData(ImageData!, metadata: nil, completion: {
            (Metadata, error) in
            if error == nil {
                StorageRef.downloadURL(completion: {
                    (url, error) in
                    guard let DownloadURL = url else {
                        print("profile change error : \(error!)")
                        return
                    }
                    DatabaseReference.child("User").child("\(UserEmail!)").updateChildValues(["ProfileImageURL" : "\(DownloadURL)"])
                })
            }
        })
    
        self.dismiss(animated: true, completion: nil)
        
    }
//Function_End
    
}
