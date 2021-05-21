import UIKit

class Home: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//MARK: - Variable
    var PostStruct = [Post]()
//Variable_End

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Local Post for Testing //
        let firstPost = Post()
        firstPost.ProfileImageName = "ProfileImage_1"
        firstPost.ContentImageName = "ContentImage_1"
        firstPost.ContentText = "Hi :D"
        firstPost.UserID = "yoo.xx"
        
        PostStruct.append(firstPost)
        
        let secondPost = Post()
        secondPost.ProfileImageName = "ProfileImage_2"
        secondPost.ContentImageName = "ContentImage_2"
        secondPost.ContentText = "Hi :)"
        secondPost.UserID = "seonho_kim"
        
        PostStruct.append(secondPost)
        
        let thirdPost = Post()
        thirdPost.ProfileImageName = "ProfileImage_3"
        thirdPost.ContentImageName = "ContentImage_3"
        thirdPost.ContentText = "Butter"
        thirdPost.UserID = "BTS"
        
        PostStruct.append(thirdPost)
        

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
        cell.ProfileImage.image = UIImage(named: postdata.ProfileImageName)
        cell.ContentImage.image = UIImage(named: postdata.ContentImageName)
        cell.ContentText.text = postdata.ContentText
        cell.UserID.text = postdata.UserID
        cell.UserID2.text = postdata.UserID
        
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
