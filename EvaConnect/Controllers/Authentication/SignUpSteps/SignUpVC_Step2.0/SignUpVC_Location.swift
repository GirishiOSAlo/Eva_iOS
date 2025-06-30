//
//  SignUpVC_Location.swift
//  EvaConnect
//
//  Created by Metis on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import CoreLocation

class SignUpVC_Location: BaseForAuthentication {
    
    //MARK: OUTLETS
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var backBtnTop: UIButton!
    @IBOutlet weak var goNext: UIButton!
    @IBOutlet weak var alreadyRegisterBtn: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    
    //MARK:- Variables
    let locationManager = CLLocationManager()
    
    var signUpDetails: SignUpDetails?
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setLayOut()
        locationManager.requestAlwaysAuthorization()
        // For use when the app is open
        //locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? SignUpVC_Step2, let signUpDetails = sender as? SignUpDetails {
//            destination.signUpDetails = signUpDetails
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopLocationManager()
    }
    
    @IBAction func next(_ sender: Any) {
        if !countryTxt.text.isNilOrEmpty && !cityTxt.text.isNilOrEmpty {
            appendLocationInfo()
            performSegue(withIdentifier: Constants.Segues.signUp2, sender: signUpDetails)
        }
        else {
            makeAlert(titleMsg: "Background Location Access  Disabled", messageData: "We need your location")
        }
    }
}

//MARK: SetLayOut
extension SignUpVC_Location {
    
    func setLayOut() {
        
        backBtnTop.addTarget(self, action: #selector(goBackByViewController), for: .touchUpInside)
        self.giveButtonCorner(actionBtn: goNext,backColor:Constants.AppColorLiteral.signUpNew)
        alreadyRegisterBtn.addTarget(self, action: #selector(GOTOFunctionLoginVCObj), for: .touchUpInside)
        
        countryTxt.layer.cornerRadius = countryTxt.frame.height / 2
        countryTxt.layer.borderWidth = 1.0
        countryTxt.layer.borderColor = UIColor.black.cgColor
        
        cityTxt.layer.cornerRadius = cityTxt.frame.height / 2
        cityTxt.layer.borderWidth = 1.0
        cityTxt.layer.borderColor = UIColor.black.cgColor
        
    }
    
    func appendLocationInfo() {
        
        signUpDetails?.city = cityTxt.text
        signUpDetails?.country = countryTxt.text
    }
}

//MARK: Location Delegate + GEOCoder

extension SignUpVC_Location: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let geocoder = CLGeocoder()
            showActivity()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                // Process Response
                
                if let error = error {
                    print("Unable to Reverse Geocode Location (\(error))")
                } else {
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        self.hideActivity()
                        self.countryTxt.text = placemark.country!
                        self.cityTxt.text = placemark.locality!
                        self.stopLocationManager()
                        //self.country = placemark.country!
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied){
            showLocationDisabledpopUp()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // print the error to see what went wrong
        print("didFailwithError\(error)")
        // stop location manager if failed
        stopLocationManager()
    }
    
    func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func showLocationDisabledpopUp() {
        let alertController = UIAlertController(title: "Background Location Access  Disabled", message: "We need your location", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Setting", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
