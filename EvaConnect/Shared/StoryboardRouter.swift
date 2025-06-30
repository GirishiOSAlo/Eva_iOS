//
//  StoryboardRouter.swift
//  EvaConnect
//
//  Created by usama on 19/05/2020.
//  Copyright © 2020 HyperNym. All rights reserved.
//

import UIKit

enum StoryboardRouter {
    
    static func loginByLinkedin() -> LoginByLinkedinVC {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: LoginByLinkedinVC.self)!
    }
    static func login() -> LoginVC {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: LoginVC.self)!
    }
    
    static func signUpVC() -> SignUpVC_Step1 {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: SignUpVC_Step1.self)!
    }
    
    static func forgotPasswordVC() -> ForgotYourPasswordVC {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: ForgotYourPasswordVC.self)!
    }
    
    static func verifyCode() -> SignUpVerifyEmailVC {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: SignUpVerifyEmailVC.self)!
    }
    
    static func signUpAboutInfo() -> SignUpAboutInfoVC {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: SignUpAboutInfoVC.self)!
    }
    
    static func signUpPassword() -> SignUpPasswordVC {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: SignUpPasswordVC.self)!
    }
    
    static func settings() -> SettingsVC {
        UIStoryboard(storyboard: .settings).instantiateViewController(withClass: SettingsVC.self)!
    }
    
    static func userSettings() -> UserSettingsVC {
        UIStoryboard(storyboard: .settings).instantiateViewController(withClass: UserSettingsVC.self)!
    }
    
    static func editPasswordVC() -> EditPasswordVC {
        UIStoryboard(storyboard: .settings).instantiateViewController(withClass: EditPasswordVC.self)!
    }
    
    static func help() -> HelpVC {
        UIStoryboard(storyboard: .settings).instantiateViewController(withClass: HelpVC.self)!
    }
    
    static func account() -> PrivatePublicAccVC {
        UIStoryboard(storyboard: .settings).instantiateViewController(withClass: PrivatePublicAccVC.self)!
    }
    
    static func userNotificationSettings() -> UserNotificationSettingsVC {
        UIStoryboard(storyboard: .settings).instantiateViewController(withClass: UserNotificationSettingsVC.self)!
    }
    
    static func signUp() -> SignUpVC_Step1 {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: SignUpVC_Step1.self)!
    }
    
    static func chat() -> ChatVC {
          UIStoryboard(storyboard: .chat).instantiateViewController(withClass: ChatVC.self)!
      }
    
    static func chatList() -> ChatListVC {
           UIStoryboard(storyboard: .chat).instantiateViewController(withClass: ChatListVC.self)!
       }
    
//    static func createEvent() -> CreateEventVC {
//        UIStoryboard(storyboard: .meeting).instantiateViewController(withClass: CreateEventVC.self)!
//    }
    
    static func createNote() -> CreateNoteVC {
        UIStoryboard(storyboard: .meeting).instantiateViewController(withClass: CreateNoteVC.self)!
    }
    
    static func signUp3() -> SignUpVC_Step3 {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: SignUpVC_Step3.self)!
    }
    
    static func signUpLocationDOB() -> SignUpLocationDOBVC {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: SignUpLocationDOBVC.self)!
    }
    
    static func newsSources() -> NewsSourceVC {
        UIStoryboard(storyboard: .authentication).instantiateViewController(withClass: NewsSourceVC.self)!
    }
    
    static func tabbar() -> TabBar {
        TabBar()
    }
    
    static func createMeeting() -> CreateMeetingVC {
        UIStoryboard(storyboard: .meeting).instantiateViewController(withClass: CreateMeetingVC.self)!
    }
    
    static func calendar() -> CalendarVC {
        UIStoryboard(storyboard: .home).instantiateViewController(withClass: CalendarVC.self)!
    }
    
    static func interestedList() -> InterestedListVC {
        UIStoryboard(storyboard: .home).instantiateViewController(withClass: InterestedListVC.self)!
    }
    
//    static func eventView() -> EventViewVC {
//          UIStoryboard(storyboard: .meeting).instantiateViewController(withClass: EventViewVC.self)!
//      }
    
    static func profile() -> ProfileVC {
          UIStoryboard(storyboard: .profile).instantiateViewController(withClass: ProfileVC.self)!
    }
    
    static func newProfile() -> UserProfileVC {
          UIStoryboard(storyboard: .profile).instantiateViewController(withClass: UserProfileVC.self)!
    }

    static func editProfile() -> EditProfileVC {
        UIStoryboard(storyboard: .profile).instantiateViewController(withClass: EditProfileVC.self)!
    }
    
    static func editUserProfile() -> EditUserProfileVC {
        UIStoryboard(storyboard: .profile).instantiateViewController(withClass: EditUserProfileVC.self)!
    }
    
    static func editProfilePicture() -> EditProfilePictureVC {
        UIStoryboard(storyboard: .profile).instantiateViewController(withClass: EditProfilePictureVC.self)!
    }
    
    static func editJobTitle() -> EditJobTitleVC {
        UIStoryboard(storyboard: .profile).instantiateViewController(withClass: EditJobTitleVC.self)!
    }
    
    static func jobVC() -> EditJobUserVC {
        UIStoryboard(storyboard: .home).instantiateViewController(withClass: EditJobUserVC.self)!
    }
    
    static func userJobListing() -> UserJobListingVC {
        UIStoryboard(storyboard: .jobs).instantiateViewController(withClass: UserJobListingVC.self)!
    }
    
    static func userApplyJob() -> UserApplyJobVC {
        UIStoryboard(storyboard: .jobs).instantiateViewController(withClass: UserApplyJobVC.self)!
    }
    
    static func jobApplyVC() -> JobApplyVC {
         UIStoryboard(storyboard: .home).instantiateViewController(withClass: JobApplyVC.self)!
     }
    
    static func homeVC() -> HomeVC {
        UIStoryboard(storyboard: .home).instantiateViewController(withClass: HomeVC.self)!
    }
    
    static func searchVC() -> SearchVC {
        UIStoryboard(storyboard: .home).instantiateViewController(withClass: SearchVC.self)!
    }
    
    static func oldSearchVC() -> SearchHome {
        UIStoryboard(storyboard: .home).instantiateViewController(withClass: SearchHome.self)!
    }
    
    static func textPostDetailVC() -> TextPostDetailVC {
        UIStoryboard(storyboard: .home).instantiateViewController(withClass: TextPostDetailVC.self)!
    }
    
    static func urlComment() -> UrlCommentVC {
        UIStoryboard(storyboard: .home).instantiateViewController(withClass: UrlCommentVC.self)!
    }
    
    static func otherComment() -> OtherCommentVC {
          UIStoryboard(storyboard: .home).instantiateViewController(withClass: OtherCommentVC.self)!
    }
    
    static func newsVC() -> NewsCommentVC {
           UIStoryboard(storyboard: .home).instantiateViewController(withClass: NewsCommentVC.self)!
    }
    
    static func newsPopupVC() -> NewsCommentPopupVC {
           UIStoryboard(storyboard: .home).instantiateViewController(withClass: NewsCommentPopupVC.self)!
    }
    
    static func openURLVC() -> OpenUrlVC {
           UIStoryboard(storyboard: .home).instantiateViewController(withClass: OpenUrlVC.self)!
    }
    
    static func openNewsDetail() -> NewsDetailVC {
           UIStoryboard(storyboard: .home).instantiateViewController(withClass: NewsDetailVC.self)!
    }
    
//    static func eventCommentVC() -> EventCommentVC {
//        UIStoryboard(storyboard: .home).instantiateViewController(withClass: EventCommentVC.self)!
//    }
    
//    static func recommendedVC() -> RecommededVC {
//        UIStoryboard(storyboard: .connection).instantiateViewController(withClass: RecommededVC.self)!
//    }
    
    static func connectionVC() -> ConnectionVC {
        UIStoryboard(storyboard: .connection).instantiateViewController(withClass: ConnectionVC.self)!
    }
    
    static func forwardChatVC() -> ForwardChatVC {
        UIStoryboard(storyboard: .connection).instantiateViewController(withClass: ForwardChatVC.self)!
    }
    
    
    
    // MARK: Jobs

    static func postedJobDetail() -> PostedJobDetailVC {
        UIStoryboard(storyboard: .jobs).instantiateViewController(withClass: PostedJobDetailVC.self)!
    }
    
    static func companyJobList() -> CompanyJobListVC {
        UIStoryboard(storyboard: .jobs).instantiateViewController(withClass: CompanyJobListVC.self)!
    }
    
    static func jobList() -> MyJobListVC {
        UIStoryboard(storyboard: .jobs).instantiateViewController(withClass: MyJobListVC.self)!
    }
    
    static func createEditJobPost() -> CreateEditPostedJobVC {
        UIStoryboard(storyboard: .jobs).instantiateViewController(withClass: CreateEditPostedJobVC.self)!
    }
    
    static func applicantList() -> ApplicantListVC {
        UIStoryboard(storyboard: .jobs).instantiateViewController(withClass: ApplicantListVC.self)!
    }
    
    static func inviteConnections() -> InviteConnectionVC {
        UIStoryboard(storyboard: .meeting).instantiateViewController(withClass: InviteConnectionVC.self)!
    }
    
    static func intrested() -> IntrestedVC {
        UIStoryboard(storyboard: .meeting).instantiateViewController(withClass: IntrestedVC.self)!
    }
    
    static func meetingView() -> MeetingViewVC {
        UIStoryboard(storyboard: .meeting).instantiateViewController(withClass: MeetingViewVC.self)!
    }
    
    static func sharePostVC() -> SharePostVC {
        UIStoryboard(storyboard: .share).instantiateViewController(withClass: SharePostVC.self)!
    }
    
    // MARK: Posts
    static func postVC() -> PostVC {
        UIStoryboard(storyboard: .post).instantiateViewController(withClass: PostVC.self)!
    }
    
    // MARK: Media
    static func mediaPlayerVC() -> MediaPlayerVC {
        UIStoryboard(storyboard: .home).instantiateViewController(withClass: MediaPlayerVC.self)!
    }
    
    // MARK: Events Details
    static func othersProfileVC() -> OthersProfileVC {
        UIStoryboard(storyboard: .profile).instantiateViewController(withClass: OthersProfileVC.self)!
    }
    static func eventDelegateProfileVC() -> EventDelegateProfileVC {
        UIStoryboard(storyboard: .home).instantiateViewController(withClass: EventDelegateProfileVC.self)!
    }
    
    
}
