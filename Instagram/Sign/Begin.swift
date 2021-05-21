import UIKit

class Begin: UIViewController {

//MARK: -Variable
    @IBOutlet weak var SignUpButton: UIButton!
//Variable_End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SignUpButton.layer.cornerRadius = 5
    }


}
