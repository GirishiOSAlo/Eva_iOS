//
//  UrlClass.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

enum EndPoints {
            
    static let baseURL = "http://168.63.140.202:8003/eva/"

//£
    //MARK:- Authentication URL
    
    static let loginUrl =  baseURL + "user/login/"
    static let linkedinLogin =  baseURL + "user/linkedin/login/"
    static let checkUserEmail = baseURL + "user/account/check/"
    static let signUp = baseURL + "user/signup/"
    static let forgotPassword = baseURL + "user/forgotpassword/"
    static let getAllSector = baseURL + "user/sector/"
    static let getUserDetail = baseURL + "user/details/"
    static let updateUserDetail = ""
    
    
    //MARK:- Dashboard URL
    
    static let dashboard = "dashboard/android/"
    static let getAllUser = "user/"
    static let filterUser = "user/filter/"
    static let newPost = "post/"
    static let getALLPost = "post/"
    static let addComment = "post/comment/"
    static let getALLComment = "post/comment/"
    static let getCommentByFilterId = "post/comment/filter/"
    static let likePost = "post/like/"
    static let jobLikePost = "job/like/"
    static let eventLikePost = "event/like/"
    static let getPostDetailById = "post/details/"
    static let getAllMyLikes = "user/mylikes/"
    static let getAllMyNotification = "user/notifications/filter/"
    static let showAllCurrentNotification = "user/notifications/"

    //MARK:-Connection
    
    static let getFilterConnection = "user/network/connection/filter/"
    static let addConnection = "user/connection/"
    static let updateConnection = "user/connection/details/"
    static let deleteConnection = "user/connection/delete/"
    
    //MARK:-Job
    
    static let getMyJobListing = "job/show/"
    static let getCompanyJobListing = "job/filter/"
    static let postJobAd = "job/"
    static let showJobDetailById = "job/show/details/"
    static let getJobDetailById = "job/details/"
    static let getAllJobApplicant = "job/application/filter/"
    static let applyForJob = "job/application/"
    static let declineApplicant = "job/application/details/"
    
    
    //MARK:-Event
    
    static let getEventCommentByFilterId = "event/comment/filter/"
    static let getEventPost = "event/details/"
    static let addEventComment = "event/comment/"
    static let attendingEvent = "event/attendee/"
    static let updateAttendingEvent = "event/attendee/detail/"
    
    //MARK:- Calendar
    
    static let getCalendarByDate = "user/calendar/day/"
    static let getCalendarByMonth = "user/calendar/day/"
    static let postNewEvent = "event/"
    static let createNotes = "user/notes/"
    
}
