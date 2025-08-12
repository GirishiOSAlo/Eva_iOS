import Foundation

// MARK: - NewEventDetailsModel
struct NewEventDetailsModel: Codable {
    let error: Bool?
    let message: String?
    let data: [NewEventDetailsData]?
}



// MARK: - Datum
struct NewEventDetailsData: Codable {
    let id: Int?
    let content, createdDatetime, modifiedDatetime: String?
    let city: String?
    let country, address, endDate, startTime: String?
    let endTime, name: String?
    let featuredImage: String?
    let startDate: String?
    let registrationLink: String?
    let eventEndDatetime, eventStartDatetime: String?
    let agenda, status: Int?
    let os, createdDate: String?
    let createdByID, modifiedByID, userID, isPrivate: Int?
    let tempImage: String?
    let comments: [String]?
    let isNewsSave, isEventLike: Int?
    let createdByUser: String?
    let attendeesCount, isJoined: Int?
    let isinvited: Int?
    let evaEventsAttendees: [EvaEventsAttendee]?
    let conferenceagenda: [ConferenceAgenda]?
    let exhibitorslists, speakerslists, mediapartnerslists, delegatelists: [List]?
    let sponsorslists: [List]?
    let eventNetworking: [EventNetworking]?
    let delegatemeetings: [Delegatemeeting]?
    let eventHotels: [EventHotel]?
    let eventVenu: [EventVenu]?
    let floorPlan: String?
    let user: NewEventDetailsUser?
    let invitedByYou: [String]?
    let interestedUsersCount: String?
    let interestedUsers: [NewEventInterestedUser]?
    let eventAttendeesStatus: String?

    enum CodingKeys: String, CodingKey {
        case id, content
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
        case city, country, address
        case eventAttendeesStatus = "attendeesstatus"
        case endDate = "end_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case name
        case featuredImage = "featured_image"
        case startDate = "start_date"
        case registrationLink = "registration_link"
        case eventEndDatetime = "event_end_datetime"
        case eventStartDatetime = "event_start_datetime"
        case agenda, status, os
        case createdDate = "created_date"
        case createdByID = "created_by_id"
        case modifiedByID = "modified_by_id"
        case userID = "user_id"
        case isPrivate = "is_private"
        case tempImage = "temp_image"
        case comments, isNewsSave, isEventLike
        case createdByUser = "created_by_user"
        case attendeesCount = "attendees_count"
        case isJoined = "is_joined"
        case isinvited = "Isinvited"
        case evaEventsAttendees = "eva_events_attendees"
        case conferenceagenda, exhibitorslists, speakerslists, mediapartnerslists, delegatelists, sponsorslists, eventNetworking, delegatemeetings, eventHotels, eventVenu
        case floorPlan = "floor_plan"
        case user
        case invitedByYou = "invited_by_you"
        case interestedUsersCount = "interested_users_count"
        case interestedUsers = "interested_users"
    }
    
    
}

// MARK: - User
struct NewEventDetailsUser: Codable {
    let id: Int?
    let firstName, lastName, email, isConnected: String?
    let isReceiver: ReceiverID?
    let connectionID, bioData, uniqueCode: String?
    let dateOfBirth, status: String?
    let userImage: String?
    let createdByID: String?
    let isLinkedin: Int?
    let facebookImageURL: String?
    let isFacebook: Int?
    let companyName, workAviation, type, otherSector: String?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case connectionID = "connection_id"
        case bioData = "bio_data"
        case uniqueCode = "unique_code"
        case dateOfBirth = "date_of_birth"
        case status
        case userImage = "user_image"
        case createdByID = "created_by_id"
        case isLinkedin = "is_linkedin"
        case facebookImageURL = "facebook_image_url"
        case isFacebook = "is_facebook"
        case companyName = "company_name"
        case workAviation = "work_aviation"
        case type
        case otherSector = "other_sector"
        case language
    }
}

// MARK: - Exhibitorslist
struct Exhibitorslist: Codable {
    let id, assignedBy, eventID, meetingStatus: Int?
    let userID, userStatus, userType: Int?
    let exhibitorName, firstName: String?
    let lastName: String?
    let description, logo: String?
    let phoneNumber: Int?
    let email, countryCode, city, country: String?
    let url: String?
    let jobTitle: String?
    let companyID: Int?
    let companyName: String?
    let telephoneNumber: Int?
    let speakerLinkedin, sponsorGraphic: String?
    let sponsorName: String?
    let linkedin: String?
    let status: Int?
    let mailStatus, createdAt, updatedAt: String?
    let deletedAt: String?
    let designation: String?
    let profile: String?

    enum CodingKeys: String, CodingKey {
        case id
        case assignedBy = "assigned_by"
        case eventID = "event_id"
        case meetingStatus = "meeting_status"
        case userID = "user_id"
        case userStatus = "user_status"
        case userType = "user_type"
        case exhibitorName = "exhibitor_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case description, logo
        case phoneNumber = "phone_number"
        case email
        case countryCode = "country_code"
        case city, country, url
        case jobTitle = "job_title"
        case companyID = "company_id"
        case companyName = "company_name"
        case telephoneNumber = "telephone_number"
        case speakerLinkedin = "speaker_linkedin"
        case sponsorGraphic = "sponsor_graphic"
        case sponsorName = "sponsor_name"
        case linkedin, status
        case mailStatus = "mail_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case designation, profile
    }
}


// MARK: - List
struct List: Codable {
    let id, assignedBy, eventID, meetingStatus: Int?
    let userID, userStatus, userType: Int?
    let exhibitorName, firstName: String?
    let lastName, description: String?
    let logo: String?
    let phoneNumber: Int?
    let email: String?
    let countryCode: String?
    let city: String?
    let country: String?
    let url, jobTitle: String?
    let companyName: String?
    let telephoneNumber: String?
    let companyID: Int?
    let speakerLinkedin, sponsorGraphic: String?
    let sponsorName: String?
    let linkedin: String?
    let status: Int?
    let mailStatus: String?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    let designation: String?
    let profile: String?
    //let userUser: EvaEventsAttendeeUser?

    enum CodingKeys: String, CodingKey {
        case id
        case assignedBy = "assigned_by"
        case eventID = "event_id"
        case meetingStatus = "meeting_status"
        case userID = "user_id"
        case userStatus = "user_status"
        case userType = "user_type"
        case exhibitorName = "exhibitor_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case description, logo
        case phoneNumber = "phone_number"
        case email
        case countryCode = "country_code"
        case city, country, url
        case jobTitle = "job_title"
        case companyID = "company_id"
        case companyName = "company_name"
        case telephoneNumber = "telephone_number"
        case speakerLinkedin = "speaker_linkedin"
        case sponsorGraphic = "sponsor_graphic"
        case sponsorName = "sponsor_name"
        case linkedin, status
        case mailStatus = "mail_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        //case userUser = "user_user"
        case designation, profile
    }
}

// MARK: - EventHotel
struct EventHotel: Codable {
    let hotel: Int?
    let hotelname, country, city, address: String?
    let website: String?
    let description: String?
    let image: String?
}

// MARK: - EventNetworking
struct EventNetworking: Codable {
    let id: Int?
    let networkingeventName, location: String?
    let theme: String?
    let date, startTime: String?
    let endTime: String?
    let description, notes: String?
    let userInput: String?
    let eventID: Int?
//    let deletedAt: String?
//    let createdAt, updatedAt: String?
//    let evaEvent: EvaEvent?
    let evaUserNetworkingMappings: [EvaUserNetworkingMapping]?

    enum CodingKeys: String, CodingKey {
        case id
        case networkingeventName = "networkingevent_name"
        case location, theme, date
        case startTime = "start_time"
        case endTime = "end_time"
        case description, notes
        case userInput = "user_input"
        case eventID = "event_id"
//        case deletedAt = "deleted_at"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case evaEvent = "eva_event"
        case evaUserNetworkingMappings = "eva_user_networking_mappings"
    }
}

// MARK: - EvaUserNetworkingMapping
struct EvaUserNetworkingMapping: Codable {
    let id, eventNetworkingID, userID, status: Int?
    let deletedAt: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case eventNetworkingID = "event_networking_id"
        case userID = "user_id"
        case status
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - EventVenu
struct EventVenu: Codable {
    let id, eventID: Int?
    let floorplanImage: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case floorplanImage = "floorplan_image"
    }
}

// MARK: - Delegatemeeting
struct Delegatemeeting: Codable {
    let startDay, startTime, endTime, location: String?
    let meetingNotes, locationName: String?
    let rescheduleReason: String?
    let meetingDetails, meetingWith, withColleagues: String?
    let requestedByID, requestedToID: Int?
    
    enum CodingKeys: String, CodingKey {
        case startDay = "start_day"
        case startTime = "start_time"
        case endTime = "end_time"
        case location
        case meetingNotes = "meeting_notes"
        case locationName = "location_name"
        case rescheduleReason = "reschedule_reason"
        case meetingDetails = "meeting_details"
        case meetingWith = "meeting_with"
        case withColleagues = "with_colleagues"
        case requestedByID = "requested_by_id"
        case requestedToID = "requested_to_id"
    }
}

// MARK: - InterestedUser
struct NewEventInterestedUser: Codable {
    let id: Int?
    let userImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userImageURL = "user_image_url"
    }
}

// MARK: - User
struct NewEventDetailsInterestedUser: Codable {
    let id: Int?
    let firstName, lastName, email, isConnected: String?
    let isReceiver: ReceiverID?
    let connectionID, bioData, uniqueCode: String?
    let dateOfBirth, status: String?
    let userImage: String?
    let createdByID: String?
    let isLinkedin: Int?
    let facebookImageURL: String?
    let isFacebook: Int?
    let companyName, workAviation, type, otherSector: String?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case isConnected = "is_connected"
        case isReceiver = "is_receiver"
        case connectionID = "connection_id"
        case bioData = "bio_data"
        case uniqueCode = "unique_code"
        case dateOfBirth = "date_of_birth"
        case status
        case userImage = "user_image"
        case createdByID = "created_by_id"
        case isLinkedin = "is_linkedin"
        case facebookImageURL = "facebook_image_url"
        case isFacebook = "is_facebook"
        case companyName = "company_name"
        case workAviation = "work_aviation"
        case type
        case otherSector = "other_sector"
        case language
    }
}

// MARK: - Conference Agenda
struct ConferenceAgenda: Codable {
    let id: Int?
    let name, date, timeFrom, timeTo: String?
    let sponsorname: String?

    enum CodingKeys: String, CodingKey {
        case id, name, date
        case timeFrom = "time_from"
        case timeTo = "time_to"
        case sponsorname
    }
}

// MARK: - EvaEventsAttendee
struct EvaEventsAttendee: Codable {
    let id: Int?
    let createdDatetime: String?
    let modifiedDatetime: String?
    let status: Int?
    let os: String?
    let createdDate: String?
    let attendanceStatus, createdByID: String?
    let eventID: Int?
    let modifiedByID: String?
    let userID: Int?
    let attendingDate: String?
    let evaEventsAttendeeUser: EvaEventsAttendeeUser?

    enum CodingKeys: String, CodingKey {
        case id
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
        case status, os
        case createdDate = "created_date"
        case attendanceStatus = "attendance_status"
        case createdByID = "created_by_id"
        case eventID = "event_id"
        case modifiedByID = "modified_by_id"
        case userID = "user_id"
        case attendingDate = "attending_date"
        case evaEventsAttendeeUser = "user_user"
    }
}
// MARK: - UserUser
struct EvaEventsAttendeeUser: Codable {
    let id: Int?
    let firstName: String?
    let lastName, username: String?
    let email: String?
    let linkedinURL: String?
    let telephoneNumber: String?
    let emailVerifiedAt: String?
    let isSuperuser: Bool?
    let uniqueCode, cnic: String?
    let dateOfBirth, userImage: String?
    let gender, delegatePaEmail, countryCode: String?
    let description, sponsorTypeID, sponsorURL, postcode: String?
    let address, os, phoneNumber: String?
    let type: Int?
    let resetPasswordTokenGenerateDay, resetPasswordTokenExpiryDay: String?
    let isStaff, isActive, isDefaultMenu: Bool?
    let lastLogin, dateJoined: String?
    let modifiedDatetime, sort: String?
    let status, verificationPin: Int?
    let createdByID, modifiedByID: Int?
    let bioData, companyName: String?
    let categoryID: Int?
    let logo, companyURL: String?
    let designation: String?
    let field: String?
    let sectorID, companyID: Int?
    let otherSector: String?
    let workAviation: Int?
    let city: String?
    let country: String?
    let region: String?
    let isFacebook, isLinkedin: Int?
    let facebookImageURL, linkedinImageURL: String?
    let isNotifications: Int?
    let lastOnlineDatetime: String?
    let isOnline: Bool?
    let language: String?
    let isPublic: Int?
    let userImageURL: String?
    let createdAt, updatedAt, deletedAt, deviceToken: String?
    let deviceType, delegateJobTitle, delegateLinkedin, delegateURL: String?
    let delegatePaName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case username, email
        case linkedinURL = "linkedin_url"
        case telephoneNumber = "telephone_number"
        case emailVerifiedAt = "email_verified_at"
        case isSuperuser = "is_superuser"
        case uniqueCode = "unique_code"
        case cnic
        case dateOfBirth = "date_of_birth"
        case userImage = "user_image"
        case gender
        case phoneNumber = "phone_number"
        case delegatePaEmail = "delegate_pa_email"
        case countryCode = "country_code"
        case description
        case sponsorTypeID = "sponsor_type_id"
        case sponsorURL = "sponsor_url"
        case postcode, address, os, type
        case resetPasswordTokenGenerateDay = "reset_password_token_generate_day"
        case resetPasswordTokenExpiryDay = "reset_password_token_expiry_day"
        case isStaff = "is_staff"
        case isActive = "is_active"
        case isDefaultMenu = "is_default_menu"
        case lastLogin = "last_login"
        case dateJoined = "date_joined"
        case modifiedDatetime = "modified_datetime"
        case sort, status
        case verificationPin = "verification_pin"
        case createdByID = "created_by_id"
        case modifiedByID = "modified_by_id"
        case bioData = "bio_data"
        case companyName = "company_name"
        case companyID = "company_id"
        case categoryID = "category_id"
        case logo
        case companyURL = "company_url"
        case designation, field
        case sectorID = "sector_id"
        case otherSector = "other_sector"
        case workAviation = "work_aviation"
        case city, country, region
        case isFacebook = "is_facebook"
        case isLinkedin = "is_linkedin"
        case facebookImageURL = "facebook_image_url"
        case linkedinImageURL = "linkedin_image_url"
        case isNotifications = "is_notifications"
        case lastOnlineDatetime = "last_online_datetime"
        case isOnline = "is_online"
        case language
        case isPublic = "is_public"
        case userImageURL = "user_image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case delegateJobTitle = "delegate_job_title"
        case delegateLinkedin = "delegate_linkedin"
        case delegateURL = "delegate_url"
        case delegatePaName = "delegate_pa_name"
    }
}

// MARK: - EvaEvent
struct EvaEvent: Codable {
    let id: Int?
    let createdDatetime, modifiedDatetime: String?
    let status: Int?
    let os: String?
    let createdDate, content, airportTransfer, city: String?
    let country, zipcode, address: String?
    let address2: String?
    let timeZone, timeZoneValue, endDate, startTime: String?
    let endTime: String?
    let createdByID, modifiedByID, userID: Int?
    let name, eventLogo, featuredImage, startDate: String?
    let isPrivate: Int?
    let isBanner: Bool?
    let bannerImageOrder: Int?
    let registrationLink: String?
    let eventEndDatetime, eventStartDatetime, meetingDurationDays, eventMeetingStartTime: String?
    let eventMeetingEndTime, eventType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
        case status, os
        case createdDate = "created_date"
        case content
        case airportTransfer = "airport_transfer"
        case city, country, zipcode, address, address2
        case timeZone = "time_zone"
        case timeZoneValue = "time_zone_value"
        case endDate = "end_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case createdByID = "created_by_id"
        case modifiedByID = "modified_by_id"
        case userID = "user_id"
        case name
        case eventLogo = "event_logo"
        case featuredImage = "featured_image"
        case startDate = "start_date"
        case isPrivate = "is_private"
        case isBanner = "is_banner"
        case bannerImageOrder = "banner_image_order"
        case registrationLink = "registration_link"
        case eventEndDatetime = "event_end_datetime"
        case eventStartDatetime = "event_start_datetime"
        case meetingDurationDays = "meeting_duration_days"
        case eventMeetingStartTime = "event_meeting_start_time"
        case eventMeetingEndTime = "event_meeting_end_time"
        case eventType = "event_type"
    }
}
