import UIKit
import MapKit

class TopTenViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var Top_Ten_Score: UITableView!
    
    
    private var myUserDef = MyUserDefaults()
    var highScores = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        highScores = myUserDef.retriveUserDefualts()
        Top_Ten_Score.delegate = self
        Top_Ten_Score.dataSource = self
    }

    
    @IBAction func back_btn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
    
extension TopTenViewController : CLLocationManagerDelegate
{
    func createPinPointOnMap(location: Location,title: String){
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        mkAnnotation.title = title
        mapView.addAnnotation(mkAnnotation)
    }
    
    func createRegion(location:Location){
        let mRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude,longitude: location.longitude),latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mRegion, animated: true)
    }
    
}


extension TopTenViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.Top_Ten_Score.dequeueReusableCell(withIdentifier: "HighScoreRow", for: indexPath)
            as? HighScoreTableViewCell


        cell?.index_btn.text = "\(indexPath.row + 1))"
        cell?.name_btn.text = self.highScores[indexPath.row].name
        cell?.date_btn.text = self.highScores[indexPath.row].date
        cell?.score_btn.text = "\(self.highScores[indexPath.row].score)"

        createPinPointOnMap(location: self.highScores[indexPath.row].location, title: self.highScores[indexPath.row].date)

        if (cell == nil){
            cell = HighScoreTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "HighScoreRow")
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createRegion(location: self.highScores[indexPath.row].location )
    }
    
}

