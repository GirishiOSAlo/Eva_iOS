//
//  GooglePlaceManager.swift
//  EvaConnect
//
//  Created by Metis on 07/07/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
//import GooglePlaces
class GooglePlaceManager {
//    static let shared = GooglePlaceManager()
//    var placesClient: GMSPlacesClient!
//    func callForPlaces()->(String, String){
//        var nameLbl = "No current place"
//        var addressLbl = ""
//        placesClient = GMSPlacesClient.shared()
//        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
//              if let error = error {
//                print("Current Place error: \(error.localizedDescription)")
//                return
//              }
//
//             if let placeLikelihoodList = placeLikelihoodList {
//                let place = placeLikelihoodList.likelihoods.first?.place
//                if let place = place {
//                    nameLbl = place.name ?? ""
//                  addressLbl = place.formattedAddress?.components(separatedBy: ", ")
//                    .joined(separator: "\n") as! String
//
//                }
//              }
//            })
//        return (nameLbl,addressLbl)
//          }
}
//extension  GooglePlaceManager: GMSAutocompleteViewControllerDelegate {
//  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//    // Get the place name from 'GMSAutocompleteViewController'
//    // Then display the name in textField
//    textField.text = place.name
//// Dismiss the GMSAutocompleteViewController when something is selected
//    dismiss(animated: true, completion: nil)
//  }
//func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//    // Handle the error
//    print("Error: ", error.localizedDescription)
//  }
//func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//    // Dismiss when the user canceled the action
//    dismiss(animated: true, completion: nil)
//  }
//}
