//
//  SkyWatchUserInfoModel.swift
//  VideoPlayerView
//
//  Created by 陳邦亢 on 2023/6/19.
//

import Foundation

// MARK: - SkyWatchUserInfo
struct SkywatchUserInfoModel: Codable {
    let id, username, contactName, email: String
    let phoneNumber, language, emailNotification, armed: String
    let autoArm, armPeriod, tzOffset, startDate: String
    let debug: String

    enum CodingKeys: String, CodingKey {
        case id, username
        case contactName = "contact_name"
        case email
        case phoneNumber = "phone_number"
        case language
        case emailNotification = "email_notification"
        case armed
        case autoArm = "auto_arm"
        case armPeriod = "arm_period"
        case tzOffset = "tz_offset"
        case startDate = "start_date"
        case debug
    }
}
