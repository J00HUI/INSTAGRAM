import UIKit
import FirebaseCore
import FirebaseAuth

class Intro: UIViewController {

//MARK: - Variable
    @IBOutlet weak var BeginView: UIView!
    @IBOutlet weak var TabView: UIView!
//Variable_End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Supporting View //
        let beginVC = self.storyboard?.instantiateViewController(identifier: "BeginView") as! Begin
        beginVC.view.frame = BeginView.bounds
        BeginView.addSubview(beginVC.view)
        addChild(beginVC)
        beginVC.didMove(toParent: self)
        
        let tabVC = self.storyboard?.instantiateViewController(identifier: "TabView") as! TabBar
        tabVC.view.frame = TabView.bounds
        TabView.addSubview(tabVC.view)
        addChild(tabVC)
        tabVC.didMove(toParent: self)
        
        // Sign In //
        if(Auth.auth().currentUser) != nil {
            BeginView.isHidden = true
        }
        
    }
}
