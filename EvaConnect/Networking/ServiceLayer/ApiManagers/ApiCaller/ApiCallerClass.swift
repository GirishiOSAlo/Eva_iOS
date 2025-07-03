//
//  ApiCallerClass.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit
import Alamofire
//import IHProgressHUD

class ApiCallerClass: NSObject {
    static var apiMethodObj = ApiCallerClass()
    static var OS = "iOS"

    //ForgotPassword
    class func forgotPasswordServiceFunc(para:[String:Any],
                                         success:@escaping (Any) -> Void,
                                         failure:@escaping (NSError) -> Void){
        let header = [
            "Content-Type":"application/json"
        ]
        ApiManagerClass.sharedManager.request(EndPoints.forgotPassword, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                //print(response.result.value)
            }
        }
    }
    
    
    //filterAllPost
    class func GetFilterDashboardPostServiceFunc(usertoken:String,
                                                 limit:Int,
                                                 offSet:Int,
                                                 para:[String:Any],
                                                 success:@escaping (Any) -> Void,
                                                 failure:@escaping (NSError) -> Void){
        let header = [
            "Content-type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        let limit = "?limit=\(limit)"
        let offset = "&offset=\(offSet)"
        
        let request = ApiManagerClass.sharedManager.request(EndPoints.searhDashboard+limit+offset,
                                                            method: .post,
                                                            parameters: para,
                                                            encoding: JSONEncoding.default,
                                                            headers: header).responseJSON {
                                                                (response) in
                                                                if  response.result.isSuccess {
                                                                    if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                                                                        let jsonDecoder = JSONDecoder()
                                                                        let resposeData = try! jsonDecoder.decode(DashboardItemRoot.self, from:response.data!)
                                                                        
                                                                        success(resposeData)
                                                                    }
                                                                    else {
                                                                        print(response.result.value ?? "No Connection Or Api Call Faild")
                                                                        
                                                                    }
                                                                }
                                                                if response.result.isFailure {
                                                                    //print(response.result.value)
                                                                }
        }
        print(request)
        
    }
    //filterEvent
      class func GetFilterEventPostServiceFunc(usertoken:String,
                                                   limit:Int,
                                                   offSet:Int,
                                                   para:[String:Any],
                                                   success:@escaping (Any) -> Void,
                                                   failure:@escaping (NSError) -> Void){
          let header = [
              "Content-type":"application/json",
              "Authorization":"Bearer \(usertoken)",
              "OS" : ApiCallerClass.OS
          ]
          let limit = "?limit=\(limit)"
          let offset = "&offset=\(offSet)"
          
          let request = ApiManagerClass.sharedManager.request(EndPoints.searhDashboard+limit+offset,
                                                              method: .post,
                                                              parameters: para,
                                                              encoding: JSONEncoding.default,
                                                              headers: header).responseJSON {
                                                                  (response) in
                                                                  if  response.result.isSuccess {
                                                                      if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                                                                          let jsonDecoder = JSONDecoder()
                                                                          let resposeData = try! jsonDecoder.decode(DashboardItemRoot.self, from:response.data!)
                                                                          
                                                                          success(resposeData)
                                                                      }
                                                                      else {
                                                                          print(response.result.value ?? "No Connection Or Api Call Faild")
                                                                          
                                                                      }
                                                                  }
                                                                  if response.result.isFailure {
                                                                      //print(response.result.value)
                                                                  }
          }
          print(request)
          
      }
    //filter Job
         class func GetFilterJobPostServiceFunc(usertoken:String,
                                                      limit:Int,
                                                      offSet:Int,
                                                      para:[String:Any],
                                                      success:@escaping (Any) -> Void,
                                                      failure:@escaping (NSError) -> Void){
             let header = [
                 "Content-type":"application/json",
                 "Authorization":"Bearer \(usertoken)",
                 "OS" : ApiCallerClass.OS
             ]
             let limit = "?limit=\(limit)"
             let offset = "&offset=\(offSet)"
             
             let request = ApiManagerClass.sharedManager.request(EndPoints.searhDashboard+limit+offset,
                                                                 method: .post,
                                                                 parameters: para,
                                                                 encoding: JSONEncoding.default,
                                                                 headers: header).responseJSON {
                                                                     (response) in
                                                                     if  response.result.isSuccess {
                                                                         if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                                                                             let jsonDecoder = JSONDecoder()
                                                                             let resposeData = try! jsonDecoder.decode(DashboardItemRoot.self, from:response.data!)
                                                                             
                                                                             success(resposeData)
                                                                         }
                                                                         else {
                                                                             print(response.result.value ?? "No Connection Or Api Call Faild")
                                                                             
                                                                         }
                                                                     }
                                                                     if response.result.isFailure {
                                                                         //print(response.result.value)
                                                                     }
             }
             print(request)
             
         }
    //GetFilterDashboard
         class func GetFilterHomePostServiceFunc(usertoken:String,
                                                      limit:Int,
                                                      offSet:Int,
                                                      para:[String:Any],
                                                      success:@escaping (Any) -> Void,
                                                      failure:@escaping (NSError) -> Void){
             let header = [
                 "Content-type":"application/json",
                 "Authorization":"Bearer \(usertoken)",
                 "OS" : ApiCallerClass.OS
             ]
             let limit = "?limit=\(limit)"
             let offset = "&offset=\(offSet)"
          
             
             let request = ApiManagerClass.sharedManager.request(EndPoints.searhDashboard+limit+offset,
                                                                 method: .post,
                                                                 parameters: para,
                                                                 encoding: JSONEncoding.default,
                                                                 headers: header).responseJSON {
                                                                     (response) in
                                                                     if  response.result.isSuccess {
                                                                         if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                                                                             let jsonDecoder = JSONDecoder()
                                                                             let resposeData = try! jsonDecoder.decode(DashboardItemRoot.self, from:response.data!)
                                                                             
                                                                             success(resposeData)
                                                                         }
                                                                         else {
                                                                             print(response.result.value ?? "No Connection Or Api Call Faild")
                                                                             
                                                                         }
                                                                     }
                                                                     if response.result.isFailure {
                                                                         //print(response.result.value)
                                                                     }
             }
             print(request)
             
         }
    //GetFilterDashboard
         class func GetFilterHomeNewsServiceFunc(usertoken:String,
                                                      limit:Int,
                                                      offSet:Int,
                                                      para:[String:Any],
                                                      success:@escaping (Any) -> Void,
                                                      failure:@escaping (NSError) -> Void){
             let header = [
                 "Content-type":"application/json",
                 "Authorization":"Bearer \(usertoken)",
                 "OS" : ApiCallerClass.OS
             ]
             let limit = "?limit=\(limit)"
             let offset = "&offset=\(offSet)"
          
             
             let request = ApiManagerClass.sharedManager.request(EndPoints.searhDashboard+limit+offset,
                                                                 method: .post,
                                                                 parameters: para,
                                                                 encoding: JSONEncoding.default,
                                                                 headers: header).responseJSON {
                                                                     (response) in
                                                                     if  response.result.isSuccess {
                                                                         if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                                                                             let jsonDecoder = JSONDecoder()
                                                                             let resposeData = try! jsonDecoder.decode(DashboardItemRoot.self, from:response.data!)
                                                                             
                                                                             success(resposeData)
                                                                         }
                                                                         else {
                                                                             print(response.result.value ?? "No Connection Or Api Call Faild")
                                                                             
                                                                         }
                                                                     }
                                                                     if response.result.isFailure {
                                                                         //print(response.result.value)
                                                                     }
             }
             print(request)
             
         }
    
    
    //likePost
    class func likePostServiceFunc(usertoken:String,
                                   para:[String:Any],
                                   success:@escaping (Any) -> Void,
                                   failure:@escaping (NSError) -> Void){
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        print("param: ",para)
        let request =  ApiManagerClass.sharedManager.request(EndPoints.likePost, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                
            }
        }
        print(request)
        
    }
    
    //likePost
    class func likeNewsServiceFunc(usertoken:String,
                                   para:[String:Any],
                                   success:@escaping (Any) -> Void,
                                   failure:@escaping (NSError) -> Void){
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        let request =  ApiManagerClass.sharedManager.request(EndPoints.newsLikePost, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                
            }
        }
        print(request)
        
    }
    
    //likeEvent
    class func likeEventsServiceFunc(usertoken:String,
                                   para:[String:Any],
                                   success:@escaping (Any) -> Void,
                                   failure:@escaping (NSError) -> Void){
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        let request =  ApiManagerClass.sharedManager.request(EndPoints.eventLikePost, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                
            }
        }
        print(request)
        
    }
    
    
    //jobLikePost
    class func jobLikePostServiceFunc(usertoken:String,
                                      para:[String:Any],
                                      success:@escaping (Any) -> Void,
                                      failure:@escaping (NSError) -> Void){
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        let request =  ApiManagerClass.sharedManager.request(EndPoints.jobLikePost, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                // print(response.result.value)dx
            }
        }
        print(request)
        
    }
    
    //jobLikePost
    class func eventLikePostServiceFunc(usertoken:String,
                                        para:[String:Any],
                                        success:@escaping (Any) -> Void,
                                        failure:@escaping (NSError) -> Void){
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        let request =  ApiManagerClass.sharedManager.request(EndPoints.eventLikePost, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                // print(response.result.value)
            }
        }
        print(request)
        
    }
    
    //jobLikePost
      class func newsLikePostServiceFunc(usertoken:String,
                                          para:[String:Any],
                                          success:@escaping (Any) -> Void,
                                          failure:@escaping (NSError) -> Void){
          let header = [
              "Content-Type":"application/json",
              "Authorization":"Bearer \(usertoken)",
              "OS" : ApiCallerClass.OS
          ]
          let request =  ApiManagerClass.sharedManager.request(EndPoints.newsLikePost, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
              (response) in
              if  response.result.isSuccess {
                  if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                      let resposeData = response.result.value as! NSDictionary
                      success(resposeData)
                  }
                  else {
                      print(response.result.value ?? "No Connection Or Api Call Faild")
                      
                  }
              }
              if response.result.isFailure{
                  // print(response.result.value)
              }
          }
          print(request)
          
      }
    
    class func saveNewsServiceFunc(usertoken:String,
                                   para:[String:Any],
                                   success:@escaping (Any) -> Void,
                                   failure:@escaping (NSError) -> Void){
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        let request =  ApiManagerClass.sharedManager.request(EndPoints.saveNews, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                
            }
        }
        print(request)
        
    }
    
    
    class func saveEventServiceFunc(usertoken:String,
                                   para:[String:Any],
                                   success:@escaping (Any) -> Void,
                                   failure:@escaping (NSError) -> Void){
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        let request =  ApiManagerClass.sharedManager.request(EndPoints.eventSave, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                
            }
        }
        print(request)
    }
    
    class func reqToJoinFunc(usertoken:String,
                                   para:[String:Any],
                                   success:@escaping (Any) -> Void,
                                   failure:@escaping (NSError) -> Void){
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        let request =  ApiManagerClass.sharedManager.request(EndPoints.eventReqToJoin, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                
            }
        }
        print(request)
    }
    
    class func saveJobServiceFunc(usertoken:String,
                                   para:[String:Any],
                                   success:@escaping (Any) -> Void,
                                   failure:@escaping (NSError) -> Void){
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        let request =  ApiManagerClass.sharedManager.request(EndPoints.jobSave, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                
            }
        }
        print(request)
    }
    
//MARK:- POSTImageBYAlamofireMultipart
    class func declineApplicantServiceFunc(usertoken:String,
                                           jobId:Int,
                                           para:[String:Any],
                                           success:@escaping (Any) -> Void,
                                           failure:@escaping (NSError) -> Void){
        
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        
        print(EndPoints.declineApplicant+"\(jobId)"+"/")
        let request =  ApiManagerClass.sharedManager.request(EndPoints.declineApplicant+"\(jobId)"+"/", method: .patch,parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                // print(response.result.value)
            }
        }
        print(request)
        
    }
    
    
    //Getting Job Applicant
    class func getAllApplicantForJobServiceFunc(usertoken:String,
                                                //limit:Int,
        //offSet:Int,
        para:[String:Any],
        success:@escaping (Any) -> Void,
        failure:@escaping (NSError) -> Void){
        
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        
        let request =  ApiManagerClass.sharedManager.request(EndPoints.getAllJobApplicant, method: .post, parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    
                    let jsonDecoder = JSONDecoder()
                    let resposeData = try! jsonDecoder.decode(JobApplicantsRoot.self, from:response.data!)
                    
                    success(resposeData)
                    
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                // print(response.result.value)
            }
        }
        print(request)
        
    }
    
    /************************************///MARK:-Calendar
    //ShowCalendarByDate
    class func calendarListByDateServiceFunc(usertoken:String,
                                             para:[String:Any],
                                             success:@escaping (Any) -> Void,
                                             failure:@escaping (NSError) -> Void){
        
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        
        let request =  ApiManagerClass.sharedManager.request(EndPoints.getCalendarByDate, method: .post,parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    
                    let jsonDecoder = JSONDecoder()
                    let resposeData = try! jsonDecoder.decode(AllCalendarModelList.self, from:response.data!)
                    
                    success(resposeData)
                    
                } else {
                    
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                }
            }
            
            if response.result.isFailure{
                // print(response.result.value)
            }
        }
        print(request)
        
    }
    //ShowCalendarByMonth
    class func calendarListByMonthServiceFunc(usertoken:String,
                                              para:[String:Any],
                                              success:@escaping (Any) -> Void,
                                              failure:@escaping (NSError) -> Void){
        
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        
        
        let request =  ApiManagerClass.sharedManager.request(EndPoints.getCalendarByMonth, method: .post,parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    
                    let jsonDecoder = JSONDecoder()
                    let resposeData = try! jsonDecoder.decode(AllCalendarModelByMonth.self, from:response.data!)
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                }
            }
            if response.result.isFailure{
                // print(response.result.value)
            }
        }
        print(request)
        
    }
    
    //AddNotesOnCalendar
    class func addNotesServiceFunc(usertoken:String,
                                   para:[String:Any],
                                   success:@escaping (Any) -> Void,
                                   failure:@escaping (NSError) -> Void){
        
        let header = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(usertoken)",
            "OS" : ApiCallerClass.OS
        ]
        
        
        
        let request =  ApiManagerClass.sharedManager.request(EndPoints.createNotes, method: .post,parameters: para, encoding:JSONEncoding.default, headers: header).responseJSON {
            (response) in
            if  response.result.isSuccess {
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    let resposeData = response.result.value as! NSDictionary
                    success(resposeData)
                }
                else {
                    print(response.result.value ?? "No Connection Or Api Call Faild")
                    
                }
            }
            if response.result.isFailure{
                // print(response.result.value)
            }
        }
        print(request)
    }
}
