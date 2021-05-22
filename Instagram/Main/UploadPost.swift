import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class UploadPost: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

//MARK: - Variable
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    
    var ProfileImageURL = String()
    var UserID = String()
//Variable_End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Select ContentImage //
        let ImagePickerController = UIImagePickerController()
        ImagePickerController.delegate = self
        ImagePickerController.allowsEditing = true
        present(ImagePickerController, animated: true, completion: nil)
        
    }

//MAK: - Function
    
    // Get User Data //
    func retrieveUserInformation(){
        let UserEmail = Auth.auth().currentUser?.uid
        DatabaseReference.child("User").child("\(UserEmail!)").observeSingleEvent(of: .value, with: { snapshot in
            if let UserDictionary = snapshot.value as? [String : AnyObject] {
                self.ProfileImageURL = UserDictionary["ProfileImageURL"] as! String
                self.UserID = UserDictionary["UserID"] as! String
            }
        })
        
    }
    
    // Select ContentImage //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var SelectedImage = UIImage()
        if let EditedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            SelectedImage = EditedImage
        } else if let OriginalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            SelectedImage = OriginalImage
        }
        self.imageView.image = SelectedImage
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Post Alert //
    func PostAlert(){
        let AlertController = UIAlertController(title: "Instagram", message: "짝짝짝\n성공적으로 업로드하였습니다", preferredStyle: .alert)
        AlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(AlertController, animated: true, completion: nil)
    }
    
//Function_End
//MARK: - Action
    @IBAction func Upload(_ sender: Any) {
        
        retrieveUserInformation()
        
        // Upload Stroage Content Image && Upload Post //
        let CurrentDate = Date()
        let TimeInterval = CurrentDate.timeIntervalSince1970
        let IntDate = Int(TimeInterval)
        let ImageData = self.imageView.image?.jpegData(compressionQuality: 1.0)
        let AutoID = DatabaseReference.childByAutoId().key
        let StorageRef = StorageReference.child("Contents").child("\(AutoID!)" + ".jpg")
        StorageRef.putData(ImageData!, metadata: nil)
        { (MetaData, error) in
            
            if error == nil {
                StorageRef.downloadURL {(url, error) in
                    guard let DownLoadURL = url else {
                        print("error")
                        return
                    }
                    let PostData: [String:Any] = ["ProfileImageURL" : self.ProfileImageURL, "UserID" : self.UserID, "ContentImageURL" : "\(DownLoadURL)", "ContentText" : self.contentTextView.text ?? ""]
                    DatabaseReference.child("Post").child("\(IntDate)").updateChildValues(PostData)
                }
            }
            self.PostAlert()
        }
    }
//Action_End
    

}
