//
//  MZInviteFromMapViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/2/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import GoogleMaps
import ObjectiveDDP

class MZInviteFromMapViewController: UIViewController {

    @IBOutlet weak var inviteMembersMapView: GMSMapView!
    var locationManager = CLLocationManager()
    //fake locations
    
    var nearbyLists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    
    
    
    var markerDic : [GMSMarker : fake] = [:]
//    let lats = [51.507351 , 51.508362, 51.509376 , 51.517389 , 51.537391]
//    let longs = [-0.127758 , -0.128769 , -0.129771,-0.137784 , -0.147799]
//    let name = ["zyad","zezo","zozz","el7ra2","el fager"]
    
    var lats : [Double] = []
    var longs : [Double] = []
    var name : [String] = []
    var nearbyArray : [String] = []
    var dicForMarker : [GMSMarker:[String : Any]] = [:]
    var current = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        inviteMembersMapView.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Meteor.meteorClient?.addSubscription("users.nearby")
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllNearby), name: NSNotification.Name(rawValue: "nearby_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllNearby), name: NSNotification.Name(rawValue: "nearby_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllNearby), name: NSNotification.Name(rawValue: "nearby_removed"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("users.nearby")
        NotificationCenter.default.removeObserver(self)
        nearbyLists.removeAllObjects()
    }
    @objc func getAllNearby(){
        self.nearbyLists = Meteor.meteorClient?.collections["nearby"] as! M13MutableOrderedDictionary
        print(nearbyLists)
        
        var currentIndex = nearbyLists.object(at: UInt(current))
        let profile = currentIndex["profile"]! as! [String : Any]
        let currentObject = nearbyLists.object(at: UInt(current)) as! [String : Any]
        name.append(profile["firstName"] as! String)
        let location = profile["location"]! as! [String : Any]
        let coordinates : [Double] = location["coordinates"]! as! [Double]
        print(coordinates)
        print(coordinates[0])
        longs.append(coordinates[0])
        lats.append(coordinates[1])
        
        var markers = GMSMarker()
        dicForMarker[markers] = currentObject
        let customMarker = CircularMarkerShape(frame: CGRect(x: 0, y: 0, width: 50, height: 70), image: UIImage(named: "1")!, borderColor: UIColor(red: 0, green: 100, blue: 255, alpha: 1.0))
        markers.position = CLLocationCoordinate2D(latitude: lats[current], longitude: longs[current])
        markers.iconView = customMarker
        markers.map = inviteMembersMapView
        markers.tracksViewChanges = false
        let fp = fake(lat: lats[current], lng: longs[current], name: name[current])
        markerDic[markers] = fp

        current += 1
        
        print(name)
        print(lats)
        print(longs)
    }
    
    
}


extension MZInviteFromMapViewController : CLLocationManagerDelegate{
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        inviteMembersMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
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
        inviteMembersMapView.isMyLocationEnabled = true
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}


extension MZInviteFromMapViewController : GMSMapViewDelegate {
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

        var infoWindow = Bundle.main.loadNibNamed("CustomInfoWindow",owner:self,options:nil)?.first as! CustomInfoWindow
        infoWindow.infoWindowImageView.image = UIImage(named: "1")
        //infoWindow.infoWindowLabel.text =
        infoWindow.infoWindowInviteButton.addTarget(self, action: #selector(inviteButtonPressed), for: .touchUpInside)
        infoWindow.infoWindowProfileWindow.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)

        return infoWindow
    }
    @objc func inviteButtonPressed(){
        print("The Allowing Members11")
    }
    @objc func profileButtonPressed(){
        print("The Allowing Members1")
    }
}

