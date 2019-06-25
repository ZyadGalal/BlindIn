//
//  MZHangoutSetLocationViewController.swift
//  BlindIn
//
//  Created by Moustafa on 6/20/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import ObjectiveDDP
import TextFieldEffects

struct fakePin {
    let lat : Double?
    let lng : Double?
    let name : String?
    let type : String?
}

protocol PassLocationBackward {
    func passData(locID : String)
    func passData(locationsName : String , locationsType : String , locationsAdress : String , locationsLat : String , locationsLng : String , city : String , country : String)
}

//protocol passCompleteLocation {
//    func passData(locationsName : String , locationsType : String , locationsAdress : String , locationsLat : String , locationsLng : String , city : String , country : String)
//}


class MZHangoutSetLocationViewController: UIViewController {

    @IBOutlet weak var setLocationMapView: GMSMapView!
    @IBOutlet weak var locationInfoView: UIView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationTypeLabel: UILabel!
    @IBOutlet weak var completeLocationTitleTextField: HoshiTextField!
    @IBOutlet weak var completeLocationTypeTextField: HoshiTextField!
    @IBOutlet weak var completeLocationAddressTextField: HoshiTextField!
    @IBOutlet weak var centerConstrain: NSLayoutConstraint!
    @IBOutlet weak var backgroundButton: UIButton!
    
    var lists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    
    var manager = CLLocationManager()
    var longPressLat = [Double]()
    var longPressLong = [Double]()
    var longPressRecognizer = UILongPressGestureRecognizer()
    var locationAdress : String = ""
    var locationAdressForPOI: String = ""
    var locationNameForPOI : String = ""
    var locationTypeForPOI : String = ""
    var cityName : String = ""
    var countryName : String = ""
    var geocoderLocation : String = ""
    var geocoderlat : String = ""
    var geocoderlng : String = ""
    var placeDone : String = ""
    var placesClient: GMSPlacesClient!
    var flag = 0
    var current = 0
    var markerDic : [GMSMarker : fakePin] = [:]
    var lats : [Double] = []
    var longs : [Double] = []
    var name : [String] = []
    var type : [String] = []
    var locationIDDelegate : PassLocationBackward!
    
    
    var dicForMarker : [GMSMarker:[String : Any]] = [:]
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
        placesClient = GMSPlacesClient.shared()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("places.all")
        NotificationCenter.default.addObserver(self, selector: #selector(MZHangoutSetLocationViewController.getAllPlaces), name: NSNotification.Name(rawValue: "places_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZHangoutSetLocationViewController.getAllPlaces), name: NSNotification.Name(rawValue: "places_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZHangoutSetLocationViewController.getAllPlaces), name: NSNotification.Name(rawValue: "places_removed"), object: nil)
    }
    
    @objc func getAllPlaces(){
        self.lists = Meteor.meteorClient?.collections["places"] as! M13MutableOrderedDictionary
        print(lists)
    
        
            var currentIndex = lists.object(at: UInt(current))
            name.append(currentIndex["title"] as! String)
            type.append(currentIndex["placeType"] as! String)
            let location = currentIndex["location"]! as! [String : Any]
        
            let currentObject = lists.object(at: UInt(current)) as! [String : Any]
    
        let coordinates : [Double] = location["coordinates"] as! [Double]
            print(coordinates)
            print(coordinates[0])
            longs.append(coordinates[0])
            lats.append(coordinates[1])
        
            var markers = GMSMarker()
            dicForMarker[markers] = currentObject
            let customMarker = CircularMarkerShape(frame: CGRect(x: 0, y: 0, width: 50, height: 70), image: UIImage(named: "1")!, borderColor: UIColor(red: 0, green: 100, blue: 255, alpha: 1.0))
            //let markers = GMSMarker()
            markers.position = CLLocationCoordinate2D(latitude: lats[current], longitude: longs[current])
            markers.iconView = customMarker
            markers.map = setLocationMapView
            markers.tracksViewChanges = false
            let ff = fakePin(lat: lats[current], lng: longs[current], name: name[current] ,type:type[current])
            markerDic[markers] = ff
            current += 1
        
        print(name)
        print(type)
        print(longs)
        print(lats)
        print(dicForMarker)
        
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
                            
                            print("GEOCODE: Formatted Address: \(lines[0])")
                            self.locationAdressForPOI = lines[0]
                            self.geocoderLocation = lines[0]
                            self.cityName = place.administrativeArea!
                            self.countryName = place.country!
                            self.geocoderlat = String(lat)
                            self.geocoderlng = String(lng)
                        }
                    } else {
                        print("GEOCODE: nil first in places")
                    }
                } else {
                    print("GEOCODE: nil in places")
                }
            }
        }
    }
    
    @objc func tapButton(){
        print("Done Pressed")
        if (flag == 1){
            
            centerConstrain.constant = 0
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()
                self.backgroundButton.alpha = 0.5
            })
            
            completeLocationAddressTextField.text = geocoderLocation
            locationIDDelegate.passData(locationsName: completeLocationTitleTextField.text! , locationsType: completeLocationTypeTextField.text!, locationsAdress: geocoderLocation, locationsLat: geocoderlat, locationsLng: geocoderlng, city: cityName, country: countryName)
            
        }
        else if (flag == 2){
            
            centerConstrain.constant = 0
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()
                self.backgroundButton.alpha = 0.5
            })
            completeLocationTitleTextField.text = locationNameForPOI
            completeLocationTypeTextField.text = locationTypeForPOI
            completeLocationAddressTextField.text = locationAdressForPOI
            
            locationIDDelegate.passData(locationsName: locationNameForPOI , locationsType: locationTypeForPOI, locationsAdress: locationAdressForPOI, locationsLat: geocoderlat, locationsLng: geocoderlng, city: cityName, country: countryName)

            
        }
        else {
            print(placeDone)
            print("******************")
            locationIDDelegate.passData(locID: placeDone)
            print("******************")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //--------------GET RANDOM LOCATION
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        flag = 1
        print("Long Press Done")
        longPressLat.removeAll()
        longPressLong.removeAll()
        let newMarker = GMSMarker(position: setLocationMapView.projection.coordinate(for: sender.location(in: setLocationMapView)))
        self.longPressLat.append(newMarker.position.latitude)
        self.longPressLong.append(newMarker.position.longitude)
        print("lat \(longPressLat[0]) + long \(longPressLong[0])")
        newMarker.map = setLocationMapView
        getLocationName(lat: longPressLat[0], lng: longPressLong[0])
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        
        if completeLocationTitleTextField.text != "" && completeLocationTypeTextField.text != "" && completeLocationAddressTextField.text != "" {
        centerConstrain.constant = -1000
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        })
            self.navigationController?.popViewController(animated: true)
        }
        else{
            print("Fill")
        }
    }
    @IBAction func backgroundButtonPressed(_ sender: Any) {
        centerConstrain.constant = -1000
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        })
    }
    
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("Loading Image")
                self.locationImageView.image = photo;
                //       self.attributionTextView.attributedText = photoMetadata.attributions;
            }
        })
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
    
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        
        flag = 2
        print("You tapped \(name) \n : \(placeID) \n :\(location.latitude) \n : \(location.longitude)")
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.types.rawValue))!
        
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
            (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.locationNameLabel.text = place.name
                self.locationTypeLabel.text = place.types![0]
                self.locationNameForPOI = place.name!
                self.locationTypeForPOI = place.types![0]
                self.getLocationName(lat: location.latitude, lng: location.longitude)
                
              self.loadFirstPhotoForPlace(placeID: place.placeID!)
                self.locationInfoView.isHidden = false
                self.locationNameLabel.text = place.name
                self.locationTypeLabel.text = place.types![0]
                
                
                print("The type selected place is: \(self.locationTypeForPOI)")
                print("The selected place is: \(place.name!)")
            }
        })
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let markar = markerDic[marker] {
            print("HI")
            let markerClicked = dicForMarker[marker]
            print(markerClicked!["_id"]!)
            locationInfoView.isHidden = false
            locationImageView.image = UIImage(named: "1")
            locationNameLabel.text = ((markerDic[marker]?.name!)!)
            locationTypeLabel.text = ((markerDic[marker]?.type!)!)
            placeDone = markerClicked!["_id"]! as! String
        }
        else {
                print("Default Marker")
        }
        return false
    }
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if locationInfoView.isHidden == false{
            locationInfoView.alpha = 0
            //locationInfoView.isHidden = true
        }
    }
}
