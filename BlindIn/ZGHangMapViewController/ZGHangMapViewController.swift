//
//  ZGHangMapViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import GoogleMaps
import ObjectiveDDP
import Kingfisher

struct Marker {
    var hangoutId : String?
    var title : String?
    var description : String?
    var image : String?
}
class ZGHangMapViewController: UIViewController {
    
    
    @IBOutlet weak var hangDescriptionLabel: UILabel!
    @IBOutlet weak var hangTitleLabel: UILabel!
    @IBOutlet weak var hangImageView: UIImageView!
    @IBOutlet var hangContainerView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var lastChoosenMaker = GMSMarker()
    var hangouts = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var places = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var markerDictionary : [GMSMarker : Marker] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.delegate = self
        
        
        Meteor.meteorClient?.addSubscription("hangouts.public")
        NotificationCenter.default.addObserver(self, selector: #selector(updateMarkers), name:NSNotification.Name(rawValue: "public-hangouts_added") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMarkers), name: NSNotification.Name(rawValue: "public-hangouts_changed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMarkers), name: NSNotification.Name(rawValue: "public-hangouts_removed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMarkers), name:NSNotification.Name(rawValue: "places_added") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMarkers), name: NSNotification.Name(rawValue: "places_changed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMarkers), name: NSNotification.Name(rawValue: "places_removed") , object: nil)
    }
    @objc func updateMarkers (){
        mapView.clear()
        if Meteor.meteorClient?.collections["public-hangouts"] != nil{
            hangouts = Meteor.meteorClient?.collections["public-hangouts"] as! M13MutableOrderedDictionary
        }
        if Meteor.meteorClient?.collections["places"] != nil{
            places = Meteor.meteorClient?.collections["places"] as! M13MutableOrderedDictionary
        }
        setMarkers()
    }
    func setMarkers(){
        if Meteor.meteorClient?.collections["places"] != nil && Meteor.meteorClient?.collections["public-hangouts"] != nil{
            for index in 0 ..< hangouts.count{
                let hangout = hangouts.object(at: UInt(index))
                var lat = 0.0
                var lng = 0.0
                for i in 0 ..< self.places.count{
                    let place = self.places.object(at: UInt(i))
                    if hangout["location"] as? String == place["_id"] as? String{
                        let location = place["location"] as! [String : Any]
                        let coordinates = location["coordinates"] as! [Any]
                        lng = coordinates[0] as! Double
                        lat = coordinates[1] as! Double
                    }
                }
                let markerObject = Marker(hangoutId: hangout["_id"] as? String, title: hangout["title"] as? String, description: hangout["description"] as? String, image: hangout["image"] as? String)
                let customMarker = CustomMarkerShape(frame: CGRect(x: 0, y: 0, width: 50, height: 70), image: hangout["image"] as! String, borderColor: UIColor(red: 0, green: 100/255, blue: 255/255, alpha: 1.0))
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                marker.iconView = customMarker
                marker.map = mapView
                
                markerDictionary[marker] = markerObject
            }
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        mapView.delegate = nil
        Meteor.meteorClient?.removeSubscription("hangouts.public")
        NotificationCenter.default.removeObserver(self)
    }
    func updateCurrentLocation (lat : Double , lng : Double){
        Meteor.meteorClient?.callMethodName("users.methods.update-location", parameters: [["lat":"\(lat)","lng" : "\(lng)"]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response!)
            }
        })
    }
    @IBAction func openHangoutProfileViewClicked(_ sender: Any) {
        let willDisplayHangoutId = markerDictionary[lastChoosenMaker]?.hangoutId!
        let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfileViewController") as! ZGHangoutProfileViewController
        vc.hangoutId = willDisplayHangoutId!
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension ZGHangMapViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        hangContainerView.isHidden = false
        hangImageView.kf.setImage(with: URL(string: (markerDictionary[marker]?.image)!)!)
        hangTitleLabel.text = "\((markerDictionary[marker]?.title!)!)"
        hangDescriptionLabel.text = (markerDictionary[marker]?.description!)!
        lastChoosenMaker = marker
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
        self.updateCurrentLocation(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
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
