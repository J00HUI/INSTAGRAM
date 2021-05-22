import UIKit

class Home: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//MARK: - Variable
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var PostStruct = [Post]()
//Variable_End

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get DB //
        DatabaseReference.child("Post").observe(.childAdded, with: { snapshot in
            
            if let PostDictionary = snapshot.value as? [String : AnyObject]{
                
                let PostData = Post()
                PostData.Key = snapshot.key
                PostData.ProfileImageURL = PostDictionary["ProfileImageURL"] as! String
                PostData.ContentImageURL = PostDictionary["ContentImageURL"] as! String
                PostData.ContentText = PostDictionary["ContentText"] as! String
                PostData.UserID = PostDictionary["UserID"] as! String
                
                self.PostStruct.insert(PostData, at: 0)
                
                DispatchQueue.main.async {
                    self.CollectionView.reloadData()
                }
            }
            
        })
        
        // Local Post for Testing //
//        let firstPost = Post()
//        firstPost.ProfileImageName = "ProfileImage_1"
//        firstPost.ContentImageName = "ContentImage_1"
//        firstPost.ContentText = "Hi :D"
//        firstPost.UserID = "yoo.xx"
//
//        PostStruct.append(firstPost)
//
//        let secondPost = Post()
//        secondPost.ProfileImageName = "ProfileImage_2"
//        secondPost.ContentImageName = "ContentImage_2"
//        secondPost.ContentText = "Hi :)"
//        secondPost.UserID = "seonho_kim"
//
//        PostStruct.append(secondPost)
//
//        let thirdPost = Post()
//        thirdPost.ProfileImageName = "ProfileImage_3"
//        thirdPost.ContentImageName = "ContentImage_3"
//        thirdPost.ContentText = "Butter"
//        thirdPost.UserID = "BTS"
//
//        PostStruct.append(thirdPost)
        

    }
    
//MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PostStruct.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 600)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        // Post Data //
        let postdata = PostStruct[indexPath.row]
        cell.ContentText.text = postdata.ContentText
        cell.UserID.text = postdata.UserID
        cell.UserID2.text = postdata.UserID
        
        let ProfileImageAddress = postdata.ProfileImageURL
        let ProfileImageURL = URL(string: ProfileImageAddress)
        
        URLSession.shared.dataTask(with: ProfileImageURL!){ (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    cell.ProfileImage.image = UIImage(data: data!)
                }
            }
        }.resume()
        
        let ContentImageURLAddress = postdata.ContentImageURL
        let ContentImageURL = URL(string: ContentImageURLAddress)
        
        URLSession.shared.dataTask(with: ContentImageURL!){ (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    cell.ContentImage.image = UIImage(data: data!)
                }
            }
        }.resume()
//        cell.ProfileImage.image = UIImage(named: postdata.ProfileImageName)
//        cell.ContentImage.image = UIImage(named: postdata.ContentImageName)
        
        
        // Layout //
        cell.ProfileImage.layer.cornerRadius = cell.ProfileImage.frame.width / 2
        cell.ProfileImage.clipsToBounds = true //* 뷰를 기준으로 자름
        cell.ContentImage.layer.masksToBounds = true//* 레이어를 기준으로 자름
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
//Collection View_End

}
