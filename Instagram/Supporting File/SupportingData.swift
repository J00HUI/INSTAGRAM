
import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage

// Color //
let MainColor = UIColor(red: 242/255, green: 203/255, blue: 5/255, alpha: 1.0).cgColor
let GrayColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 240/255).cgColor

// Firebase //
let DatabaseReference = Database.database().reference()
let StorageReference = Storage.storage().reference()

//MARK: - Data
class Post{
    
    var Key = String()
    var UserID = String()
    var ContentText = String()
    var ProfileImageURL = String()
    var ContentImageURL = String()
    //var ProfileImageName = String()
    //var ContentImageName = String()
}
//Data_End


