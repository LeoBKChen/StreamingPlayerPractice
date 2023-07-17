//
//  SkywatchAPIHelper.swift
//  VideoPlayerView
//
//  Created by 陳邦亢 on 2023/6/19.
//

import Foundation
import CryptoKit
import Combine
import SwiftUI

extension String {
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

enum MyError: Error {
    case someError
}

class SkywatchAPIHelper: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []

    var username: String = "Sales@vistatec.com.tw"
    var password: String = "123456"
    private var apiKey: String = ""
    var deviceID: [String] = []
//    @Published
    @Published var streamUrls: [String] = []
    
    let apiService: SkywatchAPIService = SkywatchAPIService()
    
    func getAPIKey() {
        apiService.validate(username: username, password: password.MD5)
            .sink(receiveCompletion: { _ in }, receiveValue: { data in
                self.apiKey = String(data: data ?? Data(), encoding: .utf8) ?? ""
            })
            .store(in: &cancellables)
    }
    
    func getDeviceID() -> AnyPublisher<SkywatchCameraDeviceListModel, Error>{
        
        if (apiKey.count != 0) {
            return apiService.getDeviceList(apiKey: apiKey)
                .compactMap{ $0 }
                .decode(type: SkywatchCameraDeviceListModel.self, decoder: JSONDecoder())
                .flatMap({ deviceList -> AnyPublisher<SkywatchCameraDeviceListModel, Error> in
                    deviceList.forEach {
                        self.deviceID.append($0.id)
                    }
                    
                    self.streamUrls = Array(repeating: "", count: deviceList.count)
                    return Just(deviceList)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                })
                .eraseToAnyPublisher()
//                .compactMap{ $0 }
//                .decode(type: SkywatchCameraDeviceListModel.self, decoder: JSONDecoder())
//                .sink(receiveCompletion: { _ in }, receiveValue: { deviceList in
//                    deviceList.forEach {
//                        self.deviceID.append($0.id)
//                    }
//                })
                
                
        }
        else {
            return apiService.validate(username: username, password: password.MD5)
                .compactMap{ $0 }
                .flatMap { data -> AnyPublisher<Data?, Error> in
                    
                    self.apiKey = String(data: data, encoding: .utf8) ?? ""
                    
                    return self.apiService.getDeviceList(apiKey: self.apiKey)
                }
                .compactMap{ $0 }
                .decode(type: SkywatchCameraDeviceListModel.self, decoder: JSONDecoder())
                .flatMap({ deviceList -> AnyPublisher<SkywatchCameraDeviceListModel, Error> in
                    deviceList.forEach {
                        self.deviceID.append($0.id)
                    }
                    self.streamUrls = Array(repeating: "", count: deviceList.count)

                    return Just(deviceList)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                })
                .eraseToAnyPublisher()
            
        }
    }
    
    func getStreamUrl(deviceIDIndex: Int) {
        
        if (self.deviceID.count < deviceIDIndex) {
            getDeviceID()
                .flatMap { deviceList -> AnyPublisher<Data?, Error> in
                    
                    return self.apiService.getStreamUrl(apiKey: self.apiKey, deviceID: self.deviceID[deviceIDIndex])
                    
                }
                .compactMap{ $0 }
                .sink(receiveCompletion: { _ in }, receiveValue: { data in
                    self.streamUrls[deviceIDIndex] = String(data: data, encoding: .utf8) ?? ""
                })
                .store(in: &cancellables)
        
        }
        else {
            apiService.getStreamUrl(apiKey: self.apiKey, deviceID: self.deviceID[deviceIDIndex])
                .compactMap{ $0 }
                .sink(receiveCompletion: { _ in }, receiveValue: { data in
                    self.streamUrls[deviceIDIndex] = String(data: data, encoding: .utf8) ?? ""
                })
                .store(in: &cancellables)
        }
    }
    
    func getAllStreamUrl() {
        if (self.deviceID.count == 0) {
            getDeviceID()
                .flatMap { deviceList -> AnyPublisher<Data?, Error> in
                    
                    let urlRequests = deviceList.map { device -> AnyPublisher<Data?, Error> in
                        
                        return self.apiService.getStreamUrl(apiKey: self.apiKey, deviceID: device.id)
                    }
                    
                    return Publishers.MergeMany(urlRequests).eraseToAnyPublisher()
                }
                .compactMap{ $0 }
                .collect()
                .sink(receiveCompletion: { _ in }, receiveValue: { datas in
                    for i in 0..<datas.count {
                        self.streamUrls[i] = String(data: datas[i], encoding: .utf8) ?? ""
                    }
                })
                .store(in: &cancellables)
        
        }
        else {
            let urlRequests = self.deviceID.map { id -> AnyPublisher<Data?, Error> in
                
                return self.apiService.getStreamUrl(apiKey: self.apiKey, deviceID: id)
            }
            
            Publishers.MergeMany(urlRequests)
                .compactMap{ $0 }
                .collect()
                .sink(receiveCompletion: { _ in }, receiveValue: { datas in
                    for i in 0..<datas.count {
                        self.streamUrls[i] = String(data: datas[i], encoding: .utf8) ?? ""
                    }
                })
                .store(in: &cancellables)
        }
    }
}
