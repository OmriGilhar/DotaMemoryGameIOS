import UIKit

class MainViewController: UIViewController {
    
    private var newProgramVar: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func main_easyMode_btn_click(_ sender: Any) {
        newProgramVar = "EasyMode"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayGame"{
            let destinationVC = segue.destination as! GameViewController
            destinationVC.receivedData = newProgramVar
        }else{
            _ = segue.destination as! TopTenViewController
        }
    }
}
