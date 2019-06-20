//
//  MZHangoutSetLocationViewController.swift
//  BlindIn
//
//  Created by Moustafa on 6/20/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MZHangoutSetLocationViewController: UIViewController {

    @IBOutlet weak var setLocationMapView: GMSMapView!
    @IBOutlet weak var locationInfoView: UIView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationTypeLabel: UILabel!
    
    var manager = CLLocationManager()
    var lat = [Double]()
    var long = [Double]()
    var longPressRecognizer = UILongPressGestureRecognizer()
    var locationAdress : String = ""
    var geocoderLocation : String = ""
    //let placesClient = GMSPlacesClient()
    var flag = 0
    var markerDic : [GMSMarker : fake] = [:]
    let lats = [37.33487913960151 , 51.508362, 51.509376 , 51.517389 , 51.537391]
    let longs = [-122.03009214252234 , -0.128769 , -0.129771,-0.137784 , -0.147799]
    let name = ["zyad","zezo","zozz","el7ra2","el fager"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIBarButtonItem(title: "Done", style: .plain, target: self, action:#selector(tapButton))
        btn.tintColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        self.navigationItem.setRightBarButton(btn, animated: false)
        
        manager.delegate = self
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.desiredAccuracy = 50
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delegate = self
        setLocationMapView.addGestureRecognizer(longPressRecognizer)
        setLocationMapView.isMyLocationEnabled = true
        setLocationMapView.settings.compassButton = true
        setLocationMapView.delegate = self
        
        // Do any additional setup after loading the view.
        
        for lat in 0..<lats.count{
            setFakeMarkers(lat: lats[lat], lng: longs[lat], name: name[lat])
        }
        // Do any additional setup after loading the view.
    }
    
    func setFakeMarkers(lat : Double , lng : Double , name : String)
    {
        let customMarker = CircularMarkerShape(frame: CGRect(x: 0, y: 0, width: 50, height: 70), image: UIImage(named: "1")!, borderColor: UIColor(red: 0, green: 100, blue: 255, alpha: 1.0))
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        marker.iconView = customMarker
        marker.map = setLocationMapView
        marker.tracksViewChanges = false
        
        let ff = fake(lat: lat, lng: lng, name: name)
        markerDic[marker] = ff
    }
    
    
    func getLocationName (lat : Double , lng : Double)
    {
        let geocoder = GMSGeocoder()
        let position = CLLocationCoordinate2DMake(lat, lng)
        
        geocoder.reverseGeocodeCoordinate(position) { response, error in
            
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                if let places = response?.results() {
                    if let place = places.first {
                        if let lines = place.lines {
                            //lines[0] move to next view controller
                            print("GEOCODE: Formatted Address: \(lines[0])")
                            self.geocoderLocation = lines[0]
                            //self.locationTextField.text = lines[0]
                        }
                    } else {
                        print("GEOCODE: nil first in places")
                        //self.locationTextField.text = "غير معروف"
                    }
                } else {
                    print("GEOCODE: nil in places")
                    //self.locationTextField.text = "غير معروف"
                }
            }
        }
    }
    
    @objc func tapButton(){
        print("Done Pressed")
        if (flag == 1){
            let vc = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "MZHangoutCompleteLocationInfoViewController") as! MZHangoutCompleteLocationInfoViewController
            vc.location = geocoderLocation
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            print("FK")
        }
    }
    
    //--------------GET RANDOM LOCATION
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        flag = 1
        
        print("Long Press Done")
        lat.removeAll()
        long.removeAll()
        let newMarker = GMSMarker(position: setLocationMapView.projection.coordinate(for: sender.location(in: setLocationMapView)))
        self.lat.append(newMarker.position.latitude)
        self.long.append(newMarker.position.longitude)
        print("lat \(lat[0]) + long \(long[0])")
        newMarker.map = setLocationMapView
        getLocationName(lat: lat[0], lng: long[0])
    }


}

extension MZHangoutSetLocationViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//-----------GET UESR LOACTION
extension MZHangoutSetLocationViewController : CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 10.0)
        self.setLocationMapView?.animate(to: camera)
        self.manager.stopUpdatingLocation()
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        manager.startUpdatingLocation()
        
        //5
        setLocationMapView.isMyLocationEnabled = true
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}

extension MZHangoutSetLocationViewController : GMSMapViewDelegate {
    
    
    //    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
    //
    //        print("You tapped \(name) \n : \(placeID) \n : \(GMSPlaceField.all) \n :\(location.latitude) \n : \(location.longitude)")
    //
    //        // Specify the place data types to return.
    //        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.types.rawValue))!
    //
    //        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
    //            (place: GMSPlace?, error: Error?) in
    //            if let error = error {
    //                print("An error occurred: \(error.localizedDescription)")
    //                return
    //            }
    //            if let place = place {
    //                self.lblPlace.text = place.name
    //                self.lblType.text = place.types?[0]
    //                print("The selected place is: \(place.name)")
    //            }
    //        })
    //    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("HI")
        locationInfoView.isHidden = false
        locationImageView.image = UIImage(named: "1")
        locationNameLabel.text = "\((markerDic[marker]?.name!)!)"
        locationTypeLabel.text = "Resturant"
        return false
    }
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if locationInfoView.isHidden == false{
            locationInfoView.isHidden = true
        }
    }
}


