//
//  UrlClass.swift
//  EvaConnect
//
//  Created by Metis on 08/01/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

enum EndPoints {
            
//    static let baseURL = "https://aviationconnect.com/api/v1/"  //Live
    static let baseURL = "http://18.168.230.15:2200/api/v2/"  //UAT
    

//     static let baseURL = "https://aviation-connect.loca.lt/api/v1/"
//   static let baseURL = "https://eyxzov-ip-122-179-142-142.tunnelmole.net/api/v1/"


    //MARK: Authentication URL
    static let testPendingUrl = "http://192.168.2.124:8000/eva/user/connection/details/"
    static let loginUrl =  baseURL + "user/login" //Using
    static let linkedinLogin =  baseURL + "user/linkedin/login/"
    static let checkUserEmail = baseURL + "user/account/check"
    static let signUp = baseURL + "user/signup"
    static let forgotPassword = baseURL + "user/forgotpassword"
//    static let getSectors = baseURL + "user/sector" //Using
    static let getSectors = baseURL + "sectorslists" //New
    static let getCategory = baseURL + "categorylists" //New
    static let sendOTP = baseURL + "otpsent"
    static let resendOTP = baseURL + "resendotp" //New
    static let getSubSectors = baseURL + "user/sector/sub" //Using
    static let userDetail = baseURL + "user/details"
    static let userStoreAirportDetail = baseURL + "user/storeairporttransfer"
    static let updateUserDetail = ""
    static let fetchJobTypes = baseURL + "job/type/" //Using
    static let userVerification = baseURL + "user/verification" //Using
    static let sendForgotEmail = baseURL + "user/password/verification" //Using
    static let resetPassword = baseURL + "user/forgotpassword" //Using
    static let deleteAccount = baseURL + "user/details/"
    static let editEmail = baseURL + "user/emailupdate"
    static let settingsOptions = baseURL + "user/adminSettingsView"
     
    //MARK: Dashboard URL
    static let dashboard =  baseURL + "dashboard/android/"
    static let getAllUser = baseURL + "user/"
    static let pendingVerificationEmail = baseURL + "user/pending/verification" //Using
    static let filterUser = baseURL + "user/filter/"
    static let newPost = baseURL + "post"
    static let getALLPost = baseURL + "post/"
    static let addComment = baseURL + "post/comment"
    static let getALLComment = baseURL + "post/comment"
    static let getCommentByFilterId = baseURL + "post/comment/filter" // not Using
    static let getCommentList = baseURL + "post/comment/list"
    static let likePost = baseURL + "post/like"  //Using
    static let jobLikePost = baseURL + "job/like/" //Using
    static let eventLikePost = baseURL + "event/like" //Using
    static let newsLikePost = baseURL + "news/like" //Using
    static let saveNews = baseURL + "news/save" //Using
    static let postDetails = baseURL + "post/details" //Using
    static let getNewsById = baseURL + "news/rss" //Using
    static let getAllMyLikes = baseURL + "user/mylikes/"
    static let showAllCurrentNotification = baseURL + "user/notifications/"
    static let dashboardBanner = baseURL + "event/eventbanners" //New
    static let getAllHomePost = baseURL + "dashboard/post"
    static let getPostList = baseURL + "post/list"
    static let getAllHomeEvent = baseURL + "dashboard/event"
    static let getAllHomeJob = baseURL + "dashboard/job"
    static let getAllHomeNews = baseURL + "dashboard/news"
    static let homeFilterPosts = baseURL + "post/filter/"
    static let homeFilterEvents = baseURL + "event/filter"
    static let homeFilterJobs = baseURL + "job/filter"
    static let searhDashboard = baseURL + "dashboard/search" //Using
//    static let fetchNewsComment = baseURL + "news/comment/filter" //Using
    static let fetchNewsComment = baseURL + "news/comment/list" //Using
    static let addNewsComment = baseURL + "news/comment" //Using
    static let menuNotification = baseURL + "user/stats/"
    static let deletePost = baseURL + "post/details/"
    static let deleteJob = baseURL + "job/details/"
    static let deleteEvent = baseURL + "event/details/"
    static let updatePost = baseURL + "post/details/"
    static let updateEventComment = baseURL + "event/comment/details/"
    static let updateJobComment = baseURL + "job/comment/details/"
    static let updatePostComment = baseURL + "post/comment/details/"
    static let updateNewsComment = baseURL + "news/comment/details/"
    static let getUserNews = baseURL + "news/selection/user" //Using
    
    static let deleteNewsComment = baseURL + "news/comment/details/"
    static let deletePostComment = baseURL + "post/comment/details/"
    static let deleteEventComment = baseURL + "event/comment/details/"
    static let deleteJobComment = baseURL + "job/comment/details/"
    static let sendDevice = baseURL + "user/DeviceToken" //Using
    
    static let resumeList = baseURL + "user/uploadresumelist" //New
    static let resumeUpload = baseURL + "user/uploadresume" //New
    static let deleteResume = baseURL + "user/deleteresume/" //New
    
    
    //MARK: Search
    static let globalSearch = baseURL + "search"
    static let getRecentSearch = baseURL + "recentsearch"
    static let globalSearchResults = baseURL + "search/results"
//    static let companyList = baseURL + "user/companylist"
    static let companyList = baseURL + "companylists" //New
    

    //MARK: Connection
    static let getFilterConnection = baseURL + "user/network/connection/filter" //Using
    static let getFilterConnectionNew = baseURL + "user/connection/filter"
    static let addConnection = baseURL + "user/connection" //Using
    static let updateConnection = baseURL + "user/connection/details/" //Using
    static let deleteConnection = baseURL + "user/connection/delete"
    static let blockConnection = baseURL + "user/connection/block" //Using
    static let getRecommendedConnections = baseURL + "user/network/connection/recommendations" //Using
    static let pendingConnections = baseURL + "user/pending/connection" 
    static let connectionStatus = baseURL + "user/connection/status"
    static let blockUser = baseURL + "user/connection/block/user" //Using
    static let getSuggestedConnections = baseURL + "user/friendsuggestions"
    static let cancelRequest = baseURL + "user/network/connection/cancelrequest"
    
    static let followersData = baseURL + "user/connection/followers" //New
    static let userFollowUnfollow = baseURL + "user/connection/followunfollowuser" //New
    static let userAcceptReject = baseURL + "user/connection/acceptreject" //New
    
    
    //MARK: News
    static let newsCommentLike = baseURL + "news/comment/like" //using
    static let dashboardShareNews = baseURL + "news/share"
    static let newsDetails = baseURL + "news/details"
    //static let relatedNewsDetails = baseURL + "news/relatednews"
    static let relatedNewsDetails = baseURL + "news/related"
    static let trendingNewsDetails = baseURL + "news/trending"
    
    //MARK: Post
    static let postCommentLike = baseURL + "post/comment/like" //using
    static let createReport = baseURL + "post/create-report" //"create_complain"
    
    //MARK: Job
    static let getJobList = baseURL + "job/list" //New
    static let getMyJobListing = baseURL + "job/show/"
    static let companyJobs = baseURL + "job/filter"
    static let postJobAd = baseURL + "job"
    static let showJobDetailById = baseURL + "job/show/details/"
    static let jobDetails = baseURL + "job/details/"
    static let getAllJobApplicant = baseURL + "job/application/filter" //Using
    static let applyForJob = baseURL + "job/application" //Using
    static let declineApplicant = baseURL + "job/application/details/"
    static let getApplicantDetail = baseURL + "job/application/details/"
    static let postJobComment = baseURL + "job/comment/"
    static let getJobComment = baseURL + "job/comment/filter/"
    static let jobSave = baseURL + "job/save"
    static let shareJob = baseURL + "job/share"
    
    //MARK: Event
    static let createEvent = baseURL + "event/"
    static let getEventCommentByFilterId = baseURL + "event/comment/filter/" //Using
    static let getEventPost = baseURL + "event/details/"
    static let addEventComment = baseURL + "event/comment/" //Using
    static let eventDetail = baseURL + "event/details" //Using
    static let eventDropDwnList = baseURL + "meetings/delegatesList"
    static let eventAttendeeStatusUpdate = baseURL + "event/attendee/detail/" //Using
    static let eventIntrested = baseURL + "event/interested/"
    static let eventIntrestedStatus = baseURL + "event/interested/status/"
    static let eventSave = baseURL + "event/save"
    static let eventReqToJoin = baseURL + "event/requesttojoin"
    static let eventShare = baseURL + "event/share"
    static let addAttendee = baseURL + "event/attendee/" //Using
    static let gallerylist = baseURL + "event/gallerylist"
    static let invitedByYou = baseURL + "event/invitedbyyou"
    static let agendaList = baseURL + "event/agendalist"
    static let agenda = baseURL + "event/agendatype"
    
    static let eventDelegateList = baseURL + "delegates/delegateslist"
    static let eventProfileDelegateList = baseURL + "delegates/viewprofile"
    static let eventFilter = baseURL + "delegates/delegatesfilter"
    static let eventConferenceAgenda = baseURL + "event/confrenceagendalists"
    static let eventNetworkList = baseURL + "event/networkingeventlist"
    
    //MARK: Notes
    static let createNote = baseURL + "user/notes"
    static let noteDetails = baseURL + "user/notes/details"
    
    //MARK: Calendar
    
    static let getCalendarByDate = baseURL + "user/calendar/day/" //Using
    static let getCalendarByMonth = baseURL + "user/calendar/day/" //Using
    static let postNewEvent = baseURL + "event/"
    static let createNotes = baseURL + "user/notes/"
    
    static let interviewOfferDetails = baseURL + "job/invitation/"
    static let uploadMedia = baseURL + "chat/"
    static let getInterivewDetails = baseURL + "job/invitation/details/"
    static let postAcceptedInterview = baseURL + "job/interview/"
    static let calenderEventList = baseURL + "calendareventlist"
    
    
    static let newsSources = baseURL + "news/sources" //Using
    static let postNewsSources = baseURL + "news/selection" //Using
    static let deleteNewsSources = baseURL + "news/selection/" //Using
    static let dashboardShare = baseURL + "dashboard/share/"
    static let dashboardSharePost = baseURL + "post/share" //Using
    static let addPushNotificationSettings = baseURL + "user/push/notifications" //Using


    //MARK: Meetings 

    static let createMeetings = baseURL + "meetings"
    static let editProfile = baseURL + "getUserSelectedNews\(myUserDefaults.userId)/"  //LoggedUserDetails.shared.user!.id ?? 0)/" //Using
    static let changePassword = baseURL + "user/changepassword" //Using
    static let meetingDetail = baseURL + "meetings/details"
    static let meetingAttendeeStatusUpdate = baseURL + "meeting/attendee/" //Using
    static let rescheduleCancelMeeting = baseURL + "meetings/rescheduleorcancel"
    static let cancelMeetingPopup = baseURL + "meetings/cancelpopup" 
    static let shareMeet = baseURL + "meetings/share"
    static let acceptMeetingPopup = baseURL + "meetings/accept"
    static let createGMeet = baseURL + "createmeeting"
    
    
    static let reactions = baseURL + "reactions"
    
    
    // MARK: Profile
    static let EmpList = baseURL + "employeeslist"
    
    
    // MARK: Help
    static let help = baseURL + "user/helpcreate"
    
    // MARK: Account Public or Private
    static let privacyMode = baseURL + "user/details/switchPrivacyMode"
    
    
    // MARK: Notifications
    static let notifications = baseURL + "user/notifications/filter"
    static let userActivity = baseURL + "user/activity/"
    static let notificationCount = baseURL + "user/stats/" //Using
    static let readAllNotifications = baseURL + "user/notifications/details" //Using
    static let oneSingal = "https://onesignal.com/api/v1/notifications" //Using
    
    
    // MARK: Chat
    static let createMsg = baseURL + "messages"
    static let chatList = baseURL + "messages/allmessages"
    static let messageList = baseURL + "messages/list"
    static let readAllMessages = baseURL + "messages/readmessage" //Using
    static let deleteMessage = baseURL + "messages/deletemessage"
    static let forwardMessage = baseURL + "messages/forwardmessage"
    
    // MARK: Cities
    static let countryApiKey = "R0wzZTBVSEhOQ1YwZk5vVlZ6ZzFsYUJxbUlHVUVuQ1NrdjFRcVRZRA=="
    static let cities = "https://api.countrystatecity.in/v1/countries/[ciso]/cities"
    
    static let termsconditions = "https://aviationconnect.com/terms-conditions"
    static let cookiesPolicy = "https://aviationconnect.com/cookies-policy"
    static let privacyPolicy = "https://aviationconnect.com/privacy-policy"
}
