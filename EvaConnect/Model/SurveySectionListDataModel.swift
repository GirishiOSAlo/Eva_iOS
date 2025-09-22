//
//  SurveySectionListDataModel.swift
//  EvaConnect
//
//  Created by Girish Bhuva on 22/09/25.
//  Copyright © 2025 HyperNym. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct SurveySectionListDataModel: Codable {
    let error: Bool?
    let message: String?
    let data: SurveySectionListData?
}

// MARK: - DataClass
struct SurveySectionListData: Codable {
    let sections: [SurveySectionList]?
    let selected: [Int]?
}

// MARK: - Section
struct SurveySectionList: Codable {
    let id: Int?
    let sectionTitle, sectionDescription: String?
    let sectionOrder: Int?
    let createdAt, updatedAt: String?
    let options: [SurveySectionOptionList]?

    enum CodingKeys: String, CodingKey {
        case id
        case sectionTitle = "section_title"
        case sectionDescription = "section_description"
        case sectionOrder = "section_order"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case options
    }
}

// MARK: - Option
struct SurveySectionOptionList: Codable {
    let id: Int?
    let optionTitle: String?
    let description: String?
    let order: Int?
    let optionType: String?
    let profileSurveySectionID: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case optionTitle = "option_title"
        case description, order
        case optionType = "option_type"
        case profileSurveySectionID = "profile_survey_section_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
