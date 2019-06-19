//
//  ZGHangMapViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import GoogleMaps
struct fake {
    let lat : Double?
    let lng : Double?
    let name : String?
}
class ZGHangMapViewController: UIViewController {
    
    
    @IBOutlet weak var hangDescriptionLabel: UILabel!
    @IBOutlet weak var hangTitleLabel: UILabel!
    @IBOutlet weak var hangImageView: UIImageView!
    @IBOutlet var hangContainerView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    //fake ex
    var markerDic : [GMSMarker : fake] = [:]
    let lats = [51.507351 , 51.508362, 51.509376 , 51.517389 , 51.537391]
    let longs = [-0.127758 , -0.128769 , -0.129771,-0.137784 , -0.147799]
    let name = ["zyad","zezo","zozz","el7ra2","el fager"]
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.delegate = self
        
        
        
        for lat in 0..<lats.count{
            print(lat)
            setFakeMarkers(lat: lats[lat], lng: longs[lat], name: name[lat])
        }
    }

    
    @IBAction func openHangoutProfileViewClicked(_ sender: Any) {
        let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfileViewController") as! ZGHangoutProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func setFakeMarkers(lat : Double , lng : Double , name : String)
    {
        let customMarker = CustomMarkerShape(frame: CGRect(x: 0, y: 0, width: 50, height: 70), image: UIImage(named: "1")!, borderColor: UIColor(red: 0, green: 100, blue: 255, alpha: 1.0))
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        marker.iconView = customMarker
        marker.map = mapView
        marker.tracksViewChanges = false
        
        let ff = fake(lat: lat, lng: lng, name: name)
        markerDic[marker] = ff
    }
}
extension ZGHangMapViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        hangContainerView.isHidden = false
        hangImageView.image = UIImage(named: "1")
        hangTitleLabel.text = "\((markerDic[marker]?.name!)!)"
        hangDescriptionLabel.text = "bfvnrfvjnsdfjkvnsdjnvsdrjklnvjklsdnvrnvlrnvjklsnvjklnvdklvndrklvnrklvnrlnjvnerljgkt"
        return false
    }
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if hangContainerView.isHidden == false{
            hangContainerView.isHidden = true
        }
    }
}
extension ZGHangMapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        // 8
        locationManager.stopUpdatingLocation()
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
