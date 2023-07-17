//
//  SkywatchCameraInfoListModel.swift
//  VideoPlayerView
//
//  Created by 陳邦亢 on 2023/6/19.
//
import Foundation

// MARK: - SkywatchCameraInfoListModelElement
struct SkywatchCameraDeviceListModelElement: Codable {
    let id, modelID, parent, online: String
    let name, active, type, sharePermission: String
    let deviceType, ibit, mobileViewAvailable, sphereAvailable: String
    let model, armactive, audioID, ownerName: String

    enum CodingKeys: String, CodingKey {
        case id
        case modelID = "model_id"
        case parent, online, name, active, type
        case sharePermission = "share_permission"
        case deviceType = "device_type"
        case ibit
        case mobileViewAvailable = "mobile_view_available"
        case sphereAvailable = "sphere_available"
        case model, armactive
        case audioID = "audio_id"
        case ownerName = "owner_name"
    }
}

typealias SkywatchCameraDeviceListModel = [SkywatchCameraDeviceListModelElement]
