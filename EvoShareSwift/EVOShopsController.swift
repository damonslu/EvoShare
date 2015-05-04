//
//  EVOShopsController.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 1/23/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class EVOShopsController : UIViewController, ConnectionManagerDelegate,MKMapViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var currentLocation : CLLocationCoordinate2D?
    @IBOutlet weak var evoMap: MKMapView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var categories : [[String:AnyObject]] = [["ID":"NoValue","NM":"NoValue"]] {
        didSet {
            println("some shit changes \(categories.count)")
            self.evoMap.removeAnnotations(self.evoMap.annotations)
            categoryPicker.reloadAllComponents()
            self.requestVendors(self.evoMap.centerCoordinate.latitude,longitude: self.evoMap.centerCoordinate.longitude)
        }
    }
    
    var vendors : [[String:AnyObject]] = [["NoID":"NoValue","NoName":"NoValue"]] {
        didSet {
            var evoAnnotatoins = self.evoMap.annotations as! [MKPointAnnotation]
            for vendor in vendors {
                var lat = vendor["LAT"] as! Double
                var long = vendor["LON"] as! Double
                
                var dropPin = MKPointAnnotation()
                var coord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,long)
                dropPin.coordinate = coord
                var textName = vendor["NME"] as! String
                dropPin.title = textName
                
                evoAnnotatoins.append(dropPin)
            }
        self.evoMap.addAnnotations(evoAnnotatoins)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.evoMap.delegate = self
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    
        ConnectionManager.sharedInstance.delegate = self
        let iconImg = UIImage(named: "menu")
        let menuBtn = UIBarButtonItem(image: iconImg, style: UIBarButtonItemStyle.Plain, target: self, action: "toogle:")
        self.navigationItem.setRightBarButtonItem(menuBtn, animated: true)
    }
    
    func requestCategories() {
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as! String
        let promoListRequest = ["UID":EVOUidSingleton.sharedInstance.userID(),"LOC":countryCode, "DBG":true] as [String:AnyObject]
        let params = ["RQS":promoListRequest, "M": 213] as [String:AnyObject]
        
        var err: NSError?
        let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
        let stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
        
        ConnectionManager.sharedInstance.socket.writeString(stringJSON)
    }
    
    func requestVendors(latitide:Double,longitude:Double) {
        let categoryObject = categories[categoryPicker.selectedRowInComponent(0)] as [String:AnyObject]
        let categoryId : Int? = categoryObject["ID"] as? Int
        let promoListRequest = ["UID":EVOUidSingleton.sharedInstance.userID(),"CTY":"", "CAT":"\(categoryId!)", "LAT" : "\(latitide)", "LON":"\(longitude)"] as Dictionary<String,AnyObject>
        let params = ["RQS":promoListRequest, "M": 212] as Dictionary<String,AnyObject>
        
        var err: NSError?
        let finalJSONData = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: &err)
        let stringJSON : String = NSString(data: finalJSONData!, encoding: NSUTF8StringEncoding)!
        
        ConnectionManager.sharedInstance.socket.writeString(stringJSON)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue : CLLocationCoordinate2D = manager.location.coordinate;
        let span2 = MKCoordinateSpanMake(1.0, 1.0)
        let long = locValue.longitude;
        let lat = locValue.latitude;
        self.evoMap.setRegion(MKCoordinateRegionMake(locValue, span2), animated: true)
        println(long);
        println(lat);
        let loadlocation = CLLocationCoordinate2D(
            latitude: lat, longitude: long
            
        )
        
        self.evoMap.centerCoordinate = loadlocation
        self.currentLocation = loadlocation
        self.requestCategories()
        locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    func toogle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
}

extension EVOShopsController : UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }

}

extension EVOShopsController : UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let categorieDict : [String:AnyObject] = self.categories[row] as [String:AnyObject]
        let categorieName = categorieDict["NM"] as! String
        return categorieName
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.evoMap.removeAnnotations(self.evoMap.annotations)
        self.requestVendors(self.evoMap.centerCoordinate.latitude,longitude: self.evoMap.centerCoordinate.longitude)
    }
}

extension EVOShopsController : ConnectionManagerDelegate {
    func connectionManagerDidRecieveObject(responseObject: AnyObject) {
        let recievedArray = responseObject as! [[String:AnyObject]]
        if !recievedArray.isEmpty {
            let arrayObject = recievedArray[0] as [String:AnyObject]
            if (arrayObject["NME"] != nil) {
                self.vendors = recievedArray
            } else {
                self.categories = recievedArray
                self.categoryPicker.selectRow(0, inComponent: 0, animated: false)
            }
        } else {
            println("There is no vendors near you")
        }
    }
}

extension EVOShopsController : MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            return nil
        }
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
            anView.image = UIImage(named:"dollar.png")
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView.annotation = annotation
        }
        return anView
    }
    func mapViewDidFinishLoadingMap(mapView: MKMapView!) {
        //
    }
}