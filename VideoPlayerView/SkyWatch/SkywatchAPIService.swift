//
//  SkywatchAPIService.swift
//  VideoPlayerView
//
//  Created by 陳邦亢 on 2023/6/19.
//

import Foundation
import Combine

class SkywatchAPIService {
    //    private var cancellableSet: Set<AnyCancellable> = []
    
    private let APIHOST = "https://service.skywatch24.com/api/v2/"
    
    enum Function: String {
        case FunctionLogin = "validation"
        case FunctionDeviceList = "devices"
//        case FunctionRTMPStream = "devices/{device_id}/rtmpstream"
        case FunctionFLVStream = "devices/{device_id}/flvstream"
        
        //        case FunctionDetail = "mitakeapp_detail"
        //        case FunctionAppCheckVersion = "uatapp_version"
        //        case FunctionDownload = "redirect"
    }
    
    //MARK:  API
    
    // 1.Validation, get token
    //curl -L -s --verbose -X POST -H 'Content-Type: application/x-www-form-urlencoded' --data 'username=Sales@vistatec.com.tw&password=e10adc3949ba59abbe56e057f20f883e&scope=login' 'https://service.skywatch24.com/api/v2/validation'
    
    func validate(username: String, password: String) -> AnyPublisher<Data?, Error> {
        let funID = Function.FunctionLogin
        guard let url = URL(string: APIHOST + funID.rawValue) else {
            return Result.Publisher(nil).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let params = [
            "username": username,
            "password": password,
            "scope": "login"
        ]
        
        let body = params
            .map { key, value in
                return "\(key)=\(value)"
            }
            .joined(separator: "&")
        
        urlRequest.httpBody = body.data(using: .utf8)

        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .eraseToAnyPublisher()
        //            .decode(type: String.self, decoder: JSONDecoder())
        //            .sink(receiveCompletion: { print ("Received completion: \($0).") },
        //                  receiveValue: { self.API_KEY = $0.base64EncodedString() })
        //            .store(in: &cancellableSet)
        
    }
    
    
    
    // 2.Get Devices List
    // curl -L -s --verbose -X GET \
    //-H 'Content-Type: application/x-www-form-urlencoded' \
    //'https://service.skywatch24.com/api/v2/devices?api_key={api_key}'
    
    func getDeviceList(apiKey: String) -> AnyPublisher<Data?, Error>  {
        let funID = Function.FunctionDeviceList
        let urlString = String(format: "%@%@%@", APIHOST, funID.rawValue, "?api_key=\(apiKey)")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL( string: urlString) else {
            return Result.Publisher(nil).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .eraseToAnyPublisher()
    }
    
    // 3. get rtmp stream url
    //curl -L -s --verbose -X GET \
    //-H 'Content-Type: application/x-www-form-urlencoded' \
    //'https://service.skywatch24.com/api/v2/devices/{device_id}/
    //rtmpstream?api_key={api_key}'
    
    func getStreamUrl(apiKey: String, deviceID: String) -> AnyPublisher<Data?, Error>  {
        let funID = Function.FunctionFLVStream.rawValue.replacingOccurrences(of: "{device_id}", with: "\(deviceID)")
        
        let urlString = String(format: "%@%@%@", APIHOST, funID, "?api_key=\(apiKey)")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlString) else {
            return Result.Publisher(nil).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .eraseToAnyPublisher()
    }
}
