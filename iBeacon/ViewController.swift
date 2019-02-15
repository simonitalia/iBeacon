//
//  ViewController.swift
//  iBeacon
//
//  Created by Simon Italia on 2/14/19.
//  Copyright © 2019 SDI Group Inc. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
            //Note! This requires the appropriate key to be added into info.plist file to fire
        
        view.backgroundColor = UIColor.gray
        
    }
    
    //Setup app to support iBeacons
    //Note! Following method gets called when user selects allow/disallow app  location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //Check if location access is granted by user
        if status == .authorizedAlways {
            
            //Check if device able to monitor iBeacons
            if CLLocationManager.isMonitoringAvailable(for:
                CLBeaconRegion.self) {
                
                //Execute code if iBeacon detected is in range of device
                if CLLocationManager.isRangingAvailable() {
                    //Start scanning
                    startScanning()
                }
            }
        }
    } //End didChangeAuthorization() method
    
    //Configure what Beacon to scan for and to start scanning (when called)
    func startScanning() {
        
        //Set UUID iBeacon/s
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        
        //Configure iBeacon data
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        //Start scan
        locationManager.startMonitoring(for: beaconRegion)
        
        //Advise scan what Beaocn data to look for
        locationManager.startRangingBeacons(in: beaconRegion)
        
    }
    
    //Actions to take when beacon/s found
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            [unowned self] in
            
            switch distance {
                
            case .unknown:
               self.view.backgroundColor = UIColor.gray
               self.distanceReading.text = "UNKNOWN"
            
            case .far:
                    self.view.backgroundColor = UIColor.blue
                    self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                
            }//End of switch()
        }
    }//End of update()
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if beacons.count > 0 {
            //beacons array object now being created in background by iOS since we configured the iBeacon support methods above
            
            //Search through beacon array and pull out beacon object in index position 0.
            let beacon = beacons[0]
                //In this example project I assume only 1 beacon object is being created/stored in beacons array
            
            //Call update method and pass in proximity property of beacon object to method
            update(distance: beacon.proximity)
            
        } else {
            update(distance: .unknown)
        }

    }//End didRangeBeacons() method

}

