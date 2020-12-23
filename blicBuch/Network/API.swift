//
//  API.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5/9/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import RxSwift
import Alamofire
import SwiftyJSON

class API: NSObject {
    var refreshingToken = false
    var refreshing = false
    var downloadingFilesRequest = [DownloadRequest]()
    var refreshTokenLastTimeUpdate = Date()
    static let shared = API();
    var disposeBag = DisposeBag()
    
    func request(router:Router, parameters:[String:AnyObject]?, completion:@escaping ((ApiResponse) -> Void)) -> DataRequest{
        let headers = [String : String]()
        let request = managerInstance.request(router.fullUrl(), method: router.httpMethod, parameters: router.httpMethod == .get ? nil : parameters, encoding: JSONEncoding.default, headers: headers)
        print(router.fullUrl().absoluteString + " called")
        request.responseJSON { (response) in
            self.handleResponse(response: response, router: router, parameters: router.httpMethod == .post ? parameters : nil, completion: { (results) in
                completion(results)
                
            })
        }
        request.resume()
        return request
    }
    
    
    func customBodyRequest(router:Router, parameters:Data?, completion:@escaping ((ApiResponse) -> Void)) -> DataRequest{
        let sdsds = router.fullUrl()
        var urlRequest = URLRequest(url: sdsds)
        urlRequest.httpMethod = router.httpMethod.rawValue
        urlRequest.httpBody = parameters
        
        let request = managerInstance.request(urlRequest)
        request.responseJSON { (response) in
            self.handleResponse(response: response, router: router, parameters: nil, completion: { (results) in
                completion(results)
            })
        }
        request.resume()
        return request
    }
    
    func downloadFile(router:Router,
                      parameters:[String:AnyObject]?,
                      completion: @escaping (ApiResponse) -> Void ,
                      percentage:@escaping (Double) -> Void) -> DownloadRequest{
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
        let fileURL = documentsURL.appendingPathComponent("Attachments/temp")
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let headers = [String:String]()
        let dlRequest = download(router.fullUrl(), method: router.httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers, to: destination)
        print("Called: " + (dlRequest.request?.url?.absoluteString ?? ""))
        dlRequest.downloadProgress { (progress) in
            DispatchQueue.main.async {
                percentage(progress.fractionCompleted)
            }
        }
        dlRequest.responseJSON { (response) in
            DispatchQueue.main.async {
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200:
                        switch response.result {
                        case .success(let responseData):
                            let jsonResponseData:JSON = JSON(responseData);
                            completion(ApiResponse.Success(jsonResponseData))
                            print(jsonResponseData)
                            return
                        case .failure(_):
                            completion(ApiResponse.Success(nil))
                            return
                        }
                        
                    case 400, 422:
                        switch response.result {
                        case .success(let responseData):
                            let jsonResponseData:JSON = JSON(responseData);
                            completion(ApiResponse.Failure(.BadRequest(ErrorModel(jsonResponseData))))
                            return
                        case .failure(_):
                            completion(ApiResponse.Failure(.BadRequest(nil)))
                            return
                        }
                    case 401:
                        completion(ApiResponse.Failure(.NotAuthorized(nil)))
                        return
                    case 500, 405:
                        switch response.result {
                        case .success(let responseData):
                            let jsonResponseData:JSON = JSON(responseData);
                            completion(ApiResponse.Failure(.BadRequest(ErrorModel(jsonResponseData))))
                            return
                        case .failure(_):
                            completion(ApiResponse.Failure(.BadRequest(nil)))
                            return
                        }
                    default:
                        completion(ApiResponse.Failure(.OtherError(nil)))
                    }
                }else{
                    completion(ApiResponse.Failure(.NoInternet(ErrorModel(title:"Something went wrong. Check your internet connection and, if problem persists, contact the system adnimistrator"))))
                }
            }
        }
        return dlRequest
    }
    func cancelAllRequests(){
        managerInstance.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    private let managerInstance: SessionManager = {
        let configuration = URLSessionConfiguration.default
        let serverTrustPolicies: [String: ServerTrustPolicy] = [ "www.vsukanica.com": .disableEvaluation, "http://www.vsukanica.com": .disableEvaluation, "vsukanica.com": .disableEvaluation, "https://www.vsukanica.com": .disableEvaluation]
        configuration.timeoutIntervalForRequest = 220
        configuration.timeoutIntervalForResource = 220
        let manager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                if let trust = challenge.protectionSpace.serverTrust {
                    credential = URLCredential(trust: trust)
                }
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
        manager.startRequestsImmediately = false
        
        return manager
    }()
}

extension API{
    
    private func getUserAgent() -> String {
//        let userAgent: String = {
//            if let info = Bundle.main.infoDictionary {
//                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
//                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
//                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
//                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
//
//                let osNameVersion: String = {
//                    let version = ProcessInfo.processInfo.operatingSystemVersion
//                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
//
//                    let osName: String = {
//                        #if os(iOS)
//                        return "iOSClientId"
//                        #elseif os(watchOS)
//                        return "watchOSiOSClient"
//                        #elseif os(tvOS)
//                        return "tvOSiOSClient"
//                        #elseif os(macOS)
//                        return "OS X"
//                        #elseif os(Linux)
//                        return "Linux"
//                        #else
//                        return "Unknown"
//                        #endif
//                    }()
//
//                    return "\(osName) \(versionString)"
//                }()
//
//                let alamofireVersion: String = {
//                    guard
//                        let afInfo = Bundle(for: SessionManager.self).infoDictionary,
//                        let build = afInfo["CFBundleShortVersionString"]
//                        else { return "Unknown" }
//
//                    return "Alamofire/\(build)"
//                }()
//
//                return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(alamofireVersion)"
//            }
//
//            return "Alamofire"
//        }()
        return "iOS"
    }
    
    private func handleResponse(response: DataResponse<Any>,router:Router, parameters:[String:AnyObject]?,   completion:@escaping ((ApiResponse) -> Void)) {
        if let statusCode = response.response?.statusCode {
            if let body = response.request?.httpBody{
                if let string = String(bytes: body, encoding: .utf8) {
                    print(string)
                }
            }
            switch statusCode {
            case 200, 204:
                switch response.result {
                case .success(let responseData):
                    let jsonResponseData:JSON = JSON(responseData);
                    completion(ApiResponse.Success(jsonResponseData))
                    return
                case .failure(_):
                    completion(ApiResponse.Success(nil))
                    return
                }
            case 401:
                print("401")
                /*if  router.fullUrl() == Router.refreshToken.fullUrl() {
                    completion(ApiResponse.Failure(.NotAuthorized(nil)))
                    return
                }
                if !refreshing && refreshTokenLastTimeUpdate.timeIntervalSinceNow < -5 {
                    refreshing = true
                    refreshTokenLastTimeUpdate = Date()
                    LoginService.refresh().subscribe(onNext: {[weak self] (success) in
                        self?.refreshing = false
                        self?.managerInstance.session.getAllTasks(completionHandler: { (tasks) in
                            tasks.forEach({ (task) in
                                if task.progress.isPaused {
                                    task.resume()
                                }
                            })
                        })
                        _ = self?.request(router: router, parameters: parameters, completion: { (response) in
                            completion(response)
                        })
                        }, onError: {[weak self] (error) in
                            self?.refreshing = false
                            self?.managerInstance.session.getAllTasks(completionHandler: { (tasks) in
                                tasks.forEach({ (task) in
                                    task.cancel()
                                })
                            })
                            if let delegate = UIApplication.shared.delegate as? AppDelegate{
                                delegate.logout(withError: error)
                            }
                    }).disposed(by: self.disposeBag)
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
                        _ = self?.request(router: router, parameters: parameters, completion: { (response) in
                            completion(response)
                        })
                    }
                }*/
            case 403:
                print("403")/*)if let delegate = UIApplication.shared.delegate as? AppDelegate{
                    let error = ApiError.NotAuthorized(ErrorModel(title: "You dont have permissions to access application"))
                    delegate.logout(withError: error)
                }
                return*/
            case 409:
                switch response.result {
                case .success(let responseData):
                    let jsonResponseData:JSON = JSON(responseData);
                    let errorModel = ErrorModel(jsonResponseData)
                    completion(ApiResponse.Failure(.UpdateAvailable(errorModel)))
                    return
                case .failure(_):
                    let errorModel = ErrorModel(title: "There is new version available, Please go to the store and update your application.")
                    completion(ApiResponse.Failure(.UpdateAvailable(errorModel)))
                    return
                }
            case 410:
                completion(ApiResponse.Failure(.ApiGenericError(code: statusCode)))
                return
            case 400, 402...422:
                switch response.result {
                case .success(let responseData):
                    let jsonResponseData:JSON = JSON(responseData);
                    let errorModel = ErrorModel(jsonResponseData)
                    completion(ApiResponse.Failure(.BadRequest(errorModel)))
                    return
                case .failure(_):
                    completion(ApiResponse.Failure(.BadRequest(nil)))
                    return
                }
            
            case 500:
                switch response.result {
                case .success(let responseData):
                    let jsonResponseData:JSON = JSON(responseData);
                    completion(ApiResponse.Failure(.BadRequest(ErrorModel(jsonResponseData))))
                    return
                case .failure(_):
                    completion(ApiResponse.Failure(.BadRequest(nil)))
                    return
                }
            default:
                switch response.result {
                case .success(let responseData):
                    let jsonResponseData:JSON = JSON(responseData);
                    let errorModel = ErrorModel(jsonResponseData)
                    completion(ApiResponse.Failure(.BadRequest(errorModel)))
                    return
                case .failure(_):
                    if statusCode == 504 {
                        completion(ApiResponse.Failure(.BadRequest(ErrorModel("Looks like the server is taking to long to respond, please try again."))))
                    }else{
                        completion(ApiResponse.Failure(.BadRequest(ErrorModel("Something went wrong."))))
                    }
                    return
                }
                //                completion(ApiResponse.Failure(.OtherError(nil)))
            }
        }else{
            completion(ApiResponse.Failure(.NoInternet(ErrorModel(title:"Something went wrong. Check your internet connection and, if problem persists, contact the system adnimistrator"))))
        }
    }
}
