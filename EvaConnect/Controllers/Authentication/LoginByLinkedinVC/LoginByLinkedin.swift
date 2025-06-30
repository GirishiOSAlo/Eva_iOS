//
//  LoginByLinkedin.swift
//  EvaConnect
//
//  Created by Metis on 12/04/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

protocol LoginByLinkedinDelegate: NSObject {
    func redirectLinkedinInfoToCreateAccount(_ details: SignUpDetails?)
}

class LoginByLinkedinVC: BaseForAuthentication {
    
    @IBOutlet weak var myWebKit: WKWebView!
    @IBOutlet weak var backBtn: UIButton!
    
    let linkedInKye = "77bx4v2e0qv4yv"
    let linkedInSecret = "7Wez2dGZP5leqzcb"
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    let responseType = "code"
    let redirectURL = "https://www.google.com"//.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)
    let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
    let scope = "r_liteprofile%20r_emailaddress" //%20w_member_social
    
    var linkedInProfile: LinkedInProfileModel?
    var linkedInEmail: String?
    var delegate: LoginByLinkedinDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayOut()
        startAuthorization()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if let destination = segue.destination as? SignUpVC_Step1, let signUpDetails = sender as? SignUpDetails {
//            destination.signUpDetails = signUpDetails
//        }
//    }
}
extension LoginByLinkedinVC {
    
    func setLayOut() {
        myWebKit.navigationDelegate = self
        backBtn.addTarget(self, action: #selector(goBackByViewController), for: .touchUpInside)
    }
}
extension LoginByLinkedinVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                self.myWebKit.isHidden = true
                showActivity()
             }
        }
        decisionHandler(.allow)
    }
    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let linkedinCode = requestURLString[range.upperBound...]
                    if let range = linkedinCode.range(of: "&state=") {
                        let linkedinCodeFinal = linkedinCode[..<range.lowerBound]
                        handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
                    }
                }
            }
        }
    }
    
    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }
    
    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"
        
        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI + "&client_id=" + LinkedInConstants.CLIENT_ID + "&client_secret=" + LinkedInConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: LinkedInConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                
                let accessToken = results?["access_token"] as! String
                print("accessToken is: \(accessToken)")
                let expiresIn = results?["expires_in"] as! Int
                print("expires in: \(expiresIn)")
                // Get user's id, first name, last name, profile pic url
                self.fetchLinkedInUserProfile(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    func fetchLinkedInUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                
                let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: data!)
                self.linkedInProfile = linkedInProfileModel

                // LinkedIn Profile Picture URL
                let linkedinProfilePic: String!
         
                if let pictureUrls = linkedInProfileModel?.profilePicture.displayImage.elements[2].identifiers[0].identifier {
                    linkedinProfilePic = pictureUrls
                } else {
                    linkedinProfilePic = "Not exists"
                }
                print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")
                // Get user's email address
                self.fetchLinkedInEmailAddress(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    func fetchLinkedInEmailAddress(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: data!)
                // LinkedIn Email
                
                if let linkedInEmail = linkedInEmailModel {
                    
                    self.linkedInEmail = linkedInEmail.elements[0].elementHandle.emailAddress
                    self.checkIfUserExists()

                }
            }
        }
        
        task.resume()
        
    }
}

extension LoginByLinkedinVC {
   
    func startAuthorization() {
        // Create the authorization URL string.
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKye)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        print(authorizationURL)
        let request = URLRequest(url: URL(string: authorizationURL)!)
        myWebKit.load(request as URLRequest)
    }
}

struct LinkedInConstants {
    
    static let CLIENT_ID = "77bx4v2e0qv4yv"
    static let CLIENT_SECRET = "7Wez2dGZP5leqzcb"
    static let REDIRECT_URI = "https://www.google.com"
    static let SCOPE = "r_liteprofile%20r_emailaddress%20w_member_social" //Get lite profile info and e-mail address
    static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
}

extension LoginByLinkedinVC {
    
    private func signUpDetailsInfo() -> SignUpDetails? {
        
        if let linkedInProfile = linkedInProfile, let email = linkedInEmail {
            
            return SignUpDetails(firstName: linkedInProfile.firstName.localized.enUS,
                                 lastName: linkedInProfile.lastName.localized.enUS,
                                 email: email, password: nil,
                                 userType: nil,
                                 sector: nil,
                                 workAviationType: nil,
                                 city: nil,
                                 country: nil,
                                 userImage: nil,
                                 userImageURI: linkedInProfile.profilePicture.displayImage.elements[2].identifiers[0].identifier,
                                 socialMedia: .linkedin)
        }
        
        return nil
    }
    
    func checkIfUserExists() {
        
        let parameters: Parameters = ["email": linkedInEmail!]
        
        showActivity()
        
        NetworkManagerr.request(EndPoints.checkUserEmail, method: .post, parameters: parameters) { (response) in
            let jsonDecoder = JSONDecoder()
            let userCheck = try! jsonDecoder.decode(UserCheckRoot.self, from:response.data!)
            self.hideActivity()
            if userCheck.error, userCheck.message == "Record Not Found." {
                
                self.dismiss(animated: true) {
                    self.delegate?.redirectLinkedinInfoToCreateAccount(self.signUpDetailsInfo())
                }
                //self.performSegue(withIdentifier: Constants.Segues.signUp1, sender: self.signUpDetailsInfo())
                
            } else {
                
                LoginManagerr.login(email: self.linkedInEmail!, socialMedia: .linkedin) { loginModel, message  in
                    
                    if let _ = loginModel {
                       // self.dashboardViewController()
                        self.gotoDashboard()

                    } else {
                        
                        self.presentAlert("Success", message!, nil)
                    }
                }
            }
        }
    }
}
