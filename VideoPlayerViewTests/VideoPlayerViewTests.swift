//
//  VideoPlayerViewTests.swift
//  VideoPlayerViewTests
//
//  Created by 陳邦亢 on 2023/6/9.
//

import XCTest
import Combine
@testable import VideoPlayerView

final class VideoPlayerViewTests: XCTestCase {

    var username: String = "Sales@vistatec.com.tw"
    var password: String = "123456"
    private var apiKey: String = ""
    var deviceID: [String] = []
    var streamUrls: [String] = []
    
    let apiService: SkywatchAPIService = SkywatchAPIService()
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetAPIKey() throws {
        let expectation = XCTestExpectation(description: "APIKey Request")

        apiService.validate(username: "Sales@vistatec.com.tw", password: "123456".MD5)
            .sink(receiveCompletion: { _ in }, receiveValue: { data in
                let key: String = String(data: data ?? Data(), encoding: .utf8) ?? ""
                print("key= \(key)")
                XCTAssertEqual(key.count, 32)
                
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testGetDeviceID() throws {
        let expectation = XCTestExpectation(description: "DeviceID Request")
        
        apiService.validate(username: username, password: password.MD5)
            .flatMap { data -> AnyPublisher<Data?, Error> in
                
                self.apiKey = String(data: data ?? Data(), encoding: .utf8) ?? ""
                
                return self.apiService.getDeviceList(apiKey: self.apiKey)
            }
            .compactMap{ $0 }
            .decode(type: SkywatchCameraDeviceListModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in }, receiveValue: { deviceList in
                deviceList.forEach {
                    self.deviceID.append($0.id)
                }
                
                self.streamUrls = Array.init(repeating: "", count: deviceList.count)
                
                XCTAssertEqual(self.deviceID[0], "61152")
                
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetRTMPURL() throws {
        let expectation = XCTestExpectation(description: "DeviceID Request")
        
        apiService.validate(username: username, password: password.MD5)
            .flatMap { data -> AnyPublisher<Data?, Error> in
                
                self.apiKey = String(data: data ?? Data(), encoding: .utf8) ?? ""
                
                return self.apiService.getDeviceList(apiKey: self.apiKey)
            }
            .compactMap{ $0 }
            .decode(type: SkywatchCameraDeviceListModel.self, decoder: JSONDecoder())
            .flatMap { deviceList -> AnyPublisher<Data?, Error> in
                deviceList.forEach {
                    self.deviceID.append($0.id)
                }
                
                self.streamUrls = Array.init(repeating: "", count: deviceList.count)
                
                return self.apiService.getStreamUrl(apiKey: self.apiKey, deviceID: self.deviceID[0])
            }
            .compactMap{ $0 }
            .sink(receiveCompletion: { _ in }, receiveValue: { data in
                self.streamUrls[0] = String(data: data, encoding: .utf8) ?? ""
                
                XCTAssertTrue(self.streamUrls[0].contains("rtmp://"))
                
                expectation.fulfill()
                
            })
            .store(in: &cancellables)
                
        wait(for: [expectation], timeout: 5.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
