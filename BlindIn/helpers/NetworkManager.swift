//
//  NetworkManager.swift
//  Mashfa
//
//  Created by zyad on 8/14/18.
//  Copyright © 2018 Zyad Galal. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class NetworkManager {
    
    //shared instance
    static let shared = NetworkManager()
    static var isConnectedToInternet : Bool = false
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkReachabilityObserver() {
        
        reachabilityManager?.listener = { status in
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                NetworkManager.isConnectedToInternet = false
                print(NetworkManager.isConnectedToInternet)
            case .unknown :
                print("It is unknown whether the network is reachable")
                NetworkManager.isConnectedToInternet = false
                print(NetworkManager.isConnectedToInternet)
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                NetworkManager.isConnectedToInternet = true
                print(NetworkManager.isConnectedToInternet)
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                NetworkManager.isConnectedToInternet = true
                print(NetworkManager.isConnectedToInternet)
            }
        }
        
        // start listening
        reachabilityManager?.startListening()
    }
}
