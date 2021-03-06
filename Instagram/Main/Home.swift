import UIKit
import FirebaseCore
import FirebaseAuth

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
                
                let UserEmail = Auth.auth().currentUser?.uid
                
                let PostData = Post()
                PostData.Key = snapshot.key
                PostData.ProfileImageURL = PostDictionary["ProfileImageURL"] as! String
                PostData.ContentImageURL = PostDictionary["ContentImageURL"] as! String
                PostData.ContentText = PostDictionary["ContentText"] as! String
                PostData.UserID = PostDictionary["UserID"] as! String
                PostData.CheckLike = PostDictionary["Like"]?["\(UserEmail!)"] as? Bool ?? Bool()
                let LikeNumber = PostDictionary["Like"] as? [String : AnyObject] ?? [String : AnyObject]()
                PostData.LikeNumber = LikeNumber.count
                print("LikeNumber :" + "\(LikeNumber.count)")
                
                self.PostStruct.insert(PostData, at: 0)
                
                DispatchQueue.main.async {
                    self.CollectionView.reloadData()
                }
            }
            
        })
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
        
        // Layout //
        cell.ProfileImage.layer.cornerRadius = cell.ProfileImage.frame.width / 2
        cell.ProfileImage.clipsToBounds = true //* ?????? ???????????? ??????
        cell.ContentImage.layer.masksToBounds = true//* ???????????? ???????????? ??????
        
        // Time //
        CalculateTime(PostTime: Int(postdata.Key)!, TimeLabel: cell.TimeLabel)
        
        // Like //
        if postdata.CheckLike == true {
            cell.LikeButton.setImage(UIImage(named: "LikeFill"), for: .normal)
        }else {
            cell.LikeButton.setImage(UIImage(named: "LikeEmpty"), for: .normal)
        }
        cell.LikeButton.setTitle(" "+String(postdata.LikeNumber), for: .normal)
        cell.LikeNumberButton.setTitle("????????? " + String(postdata.LikeNumber) + "???", for: .normal)
        
        // Touch Like Button //
        cell.LikeButton.tag = indexPath.row
        cell.LikeButton.addTarget(self, action: #selector(Like(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    // Like //
    @objc func Like(sender:UIButton){
        let UserEmail = Auth.auth().currentUser?.uid
        
        if PostStruct[sender.tag].CheckLike == true {
            PostStruct[sender.tag].LikeNumber -= 1
            sender.setImage(UIImage(named: "LikeEmpty"), for: .normal)
            sender.setTitle("  " + String(PostStruct[sender.tag].LikeNumber), for: .normal) //MARK: - ?????? ??????
            PostStruct[sender.tag].CheckLike = false
            
            DatabaseReference.child("Post").child("\(PostStruct[sender.tag].Key)").child("Like").child(String(UserEmail!)).removeValue()
        } else {
            PostStruct[sender.tag].LikeNumber += 1
            sender.setImage(UIImage(named: "LikeFill"), for: .normal)
            sender.setTitle("  " + String(PostStruct[sender.tag].LikeNumber), for: .normal) //MARK: - ?????? ??????
            PostStruct[sender.tag].CheckLike = true
            
            DatabaseReference.child("Post").child("\(PostStruct[sender.tag].Key)").child("Like").updateChildValues(["\(UserEmail!)" : true])
        }
        
    }
    
    func CalculateTime(PostTime:Int, TimeLabel:UILabel){
        let CurrentTime = Date().timeIntervalSince1970
        let timeInterval = Int(CurrentTime) - PostTime
        
        let Minute = 60
        let Hour = Minute * 60
        let Day = Hour * 24
        let Week = Day * 7
        let Month = Week * 30
        let Year = Month * 12
        
        if timeInterval < Minute {
            TimeLabel.text = "\(timeInterval)" + "??? ???"
        } else if timeInterval < Hour {
            TimeLabel.text = "\(timeInterval/Minute)" + "??? ???"
        } else if timeInterval < Day {
            TimeLabel.text = "\(timeInterval/Hour)" + "?????? ???"
        } else if timeInterval < Week {
            TimeLabel.text = "\(timeInterval/Day)" + "??? ???"
        } else if timeInterval < Month {
            TimeLabel.text = "\(timeInterval/Week)" + "??? ???"
        } else if timeInterval < Year {
            TimeLabel.text = "\(timeInterval/Month)" + "??? ???"
        } else {
            TimeLabel.text = "\(timeInterval/Year)" + "??? ???"
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }

    
//Collection View_End

}

