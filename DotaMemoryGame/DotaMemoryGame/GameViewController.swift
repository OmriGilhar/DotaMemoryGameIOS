import UIKit
import CoreLocation

class GameViewController: UIViewController {

    @IBOutlet weak var game_timer: UILabel!
    @IBOutlet weak var game_moves_counter: UILabel!
    @IBOutlet var game_card_btn: [UIButton]!

    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var isUpdatingLocation: Bool = false
    private var lastLocationError: Error?
    private var isPermission: Bool = false
    
    private var game = Game()
    private var game_first_clicked_card: UIButton? = nil
    private var clickCounter = 0
    private var checkWinPairs = 0
    private var myUserDef = MyUserDefaults()
    private var highScores = [Player]()
    private var finalScore: Int  = 0
    @IBOutlet weak var startGame: UIStackView!
    
    public var receivedData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        game.setSuccessCounter(successCounter: 0)
        checkWinPairs = 0
        game.setTimer(on: true, timerLabel: game_timer)
        for card in game_card_btn{
            card.setImage(game.getBackCard(), for:.normal)
            card.isEnabled = true
        }
        game_moves_counter.text = "\(game.getSuccessCounter())"

        startGame.isHidden = true
        game.initGame(cards: game.game_images)
     
    }
    
    func gameOver(card: UIButton){
        if(checkWinPairs == 8)
        {
            game.setTimer(on: false , timerLabel: game_timer)
            print(game.getScore() - finalScore)
            let scoreNewIndex = checkifHighScore(score: game.getScore() + finalScore)
            if scoreNewIndex {
                isPermission = findLocation()
                startLocationManager()
                if(isPermission){
                    createAlertForUserName()
                }
            }else{
                self.performSegue(withIdentifier: "MainViewController", sender: self)
            }
            
            game.setSuccessCounter(successCounter: 0)
        }
    }
    
    func disableOrUnableGameBoard(on : Bool){
        
            for element in self.game_card_btn
            {
                    element.isUserInteractionEnabled = on
            }
    }
    
    func startLocationManager() {
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if isUpdatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            isUpdatingLocation = false
        }
    }
    
    func findLocation() -> Bool//premisions
    {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return true
        }
        if authStatus == .denied || authStatus == .restricted {
            reportLocationServicesDenied()
            return false
        }
        return true
    }
    
    func  reportLocationServicesDenied() {
        let alert = UIAlertController(title: "Opps! location services are disabled.", message: "Pleas go to Settings > Privacy to enable location services for this app.",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func createAlertForUserName() {
        //get name from user throgh alertController
        let alert = UIAlertController(title: "Congratulation! ",
                                      message: " You won!",
                                      preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Continue", style: .default, handler: { (action) -> Void in
            
            let name = alert.textFields![0].text
            self.saveNewHighScore(name: name!)
            self.performSegue(withIdentifier: "MainViewController", sender: self)

        })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Enter your name"
            textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func checkifHighScore(score: Int) -> Bool {
        highScores = myUserDef.retriveUserDefualts()
        if highScores.count == 10{
            highScores.sort(by: {$0.score > $1.score})
            for highScore in highScores {
                if(highScore.score < score){
                    return true
                }
            }
        }
        else if highScores.count < 10{
            return true
        }
        return false
    }
    
    func saveNewHighScore(name: String) {

        //save new high score and update userDefaults
        let userLocation: Location = Location(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        if(userLocation.longitude != 0 && userLocation.latitude != 0) {
        let highScore = Player(score: game.getScore() - finalScore, playerName: name, gameLocation:  userLocation )
            var highScoreList = myUserDef.retriveUserDefualts()
            if (highScoreList.count == 10) {
                //remove the last player with the loweset score
                highScoreList.remove(at: highScoreList.count - 1)
            }
            highScoreList.append(highScore)//add new high score
            highScoreList.sort(by: {$0.score > $1.score})//sort by score amount
            myUserDef.storeUserDefaults(highScores: highScoreList)
        }
        else {
            print("Location is nil")
        }
    }
    

    
    @IBAction func game_card_click(_ sender: UIButton)
    {
        finalScore = finalScore + 1
        if(clickCounter == 1)
        {
            if(game_first_clicked_card == sender)
            {
                return;
            }
            sender.setImage(game.getBoardByIndex(index: sender.tag), for: .normal)
            game.openCard(card: sender)
            
            if(game.getBoardByIndex(index: sender.tag) == game.getBoardByIndex(index: game_first_clicked_card!.tag))//board[game_first_clicked_card!.tag])
            {
                sender.isEnabled = false
                game_first_clicked_card?.isEnabled = false
                clickCounter = 0
                checkWinPairs += 1
                game.setScore(score: 10)
            }
            else
            {

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.game.closeCard(card: sender)
                    self.game.closeCard(card: self.game_first_clicked_card!)
                }
                clickCounter = 0

            }
            game.addMove()
            game_moves_counter.text = "\(game.getSuccessCounter())"
            gameOver(card: sender)
        }
        else
        {
            sender.setImage(game.getBoardByIndex(index: sender.tag), for: .normal)
            game.openCard(card: sender)
            clickCounter = 1
            game_first_clicked_card = sender
            
        }
    }
}


extension GameViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR!! locationManager-didFailedWithError: \(error)")
        if(error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations.last!
        stopLocationManager()
        print("GOT IT! locationManager-didUpdateLocation: \(String(describing: location))")
    }
}


