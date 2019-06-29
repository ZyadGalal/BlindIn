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
import Kingfisher

struct fake {
    var lat : Double?
    var lng : Double?
    var name : String?
}
class MZInviteFromMapViewController: UIViewController {

    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var popUpImageView: UIImageView!
    @IBOutlet weak var popUpNameLabel: UILabel!
    @IBOutlet weak var inviteMembersMapView: GMSMapView!
    var locationManager = CLLocationManager()
    //fake locations
    
    @IBOutlet weak var centerConstrain: NSLayoutConstraint!
    var nearbyLists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    
    var markerDic : [GMSMarker : fake] = [:]
    
    var lats : [Double] = []
    var longs : [Double] = []
    var name : [String] = []
    var nearbyArray : [String] = []
    var idsArray : [String] = []
    var dicForMarker : [GMSMarker:[String : Any]] = [:]
    var current = 0
    var currentMarkerID : String = ""
    
    var invitedIDsArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        inviteMembersMapView.delegate = self
        
        
        
        Meteor.meteorClient?.addSubscription("users.nearby")
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllNearby), name: NSNotification.Name(rawValue: "nearby_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllNearby), name: NSNotification.Name(rawValue: "nearby_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllNearby), name: NSNotification.Name(rawValue: "nearby_removed"), object: nil)
        
        
    }

    
    @IBAction func backgroundButtonClicked(_ sender: Any) {
        centerConstrain.constant = -1000
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        })
    }
    @IBAction func inviteButtonClicked(_ sender: Any) {
        
        centerConstrain.constant = -1000
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        })
        
        idsArray.append(currentMarkerID)
        print(idsArray)
    }
    @IBAction func profileButtonClicked(_ sender: Any) {
        idsArray.removeAll()
        print("profile")
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
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
        let customMarker = CircularMarkerShape(frame: CGRect(x: 0, y: 0, width: 50, height: 70), image: profile["image"] as! String, borderColor: UIColor(red: 61/255, green: 101/255, blue: 255/255, alpha: 1.0))
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        centerConstrain.constant = 0
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0.5
        })
        let markerClicked = dicForMarker[marker]
        print(markerClicked!["_id"]!)
        currentMarkerID = markerClicked!["_id"]! as! String
        let profile  = markerClicked!["profile"]! as! [String : Any]
        print("**********")
        print(profile["image"] as! String)
        print("**********")
        
        popUpImageView.kf.indicatorType = .activity
        popUpImageView.kf.setImage(with: URL(string: profile["image"] as! String))
        popUpNameLabel.text = ((markerDic[marker]?.name!)!)
        
        return false
    }
}
