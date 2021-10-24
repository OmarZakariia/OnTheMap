//
//  ClientUdacity.swift
//  OnTheMap
//
//  Created by Omar Zakaria on 04/10/2021.
//

import Foundation



//
//
//    var url: URL {
//        return URL(string: stringValue)!
//    }
//
//}
class ClientUdacity : NSObject {
    
    struct Auth {
        static var sessionId: String? = nil
        
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    
    static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case SignUpUdacity
        case LoginUdacity
        case getStudentLocations
        case addLocation
        case updateLocation
        case getLoggedinUserProfile
        
        
        var stringValue : String{
            switch self {
            case .SignUpUdacity:
                return "https://auth.udacity.com/sign-up"
            case .LoginUdacity:
                return Endpoints.base + "/session"
            case .getStudentLocations:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .addLocation:
                return Endpoints.base + "/StudentLocation"
            case .updateLocation:
                return Endpoints.base + "/StudentLocation/" + Auth.objectId
            case .getLoggedinUserProfile:
                return Endpoints.base + "/users/" + Auth.key
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }

    
    override init() {
        super.init()
    }
    class func shared() -> ClientUdacity{
        struct Singleton {
            static var shared = ClientUdacity()
        }
        return Singleton.shared
    }
    

    // MARK: - Class Functions

    
    class func login(email : String, password: String, completion:@escaping (Bool, Error?)-> Void){
        let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        HelperFunctions.taskForPostRequest(url: Endpoints.LoginUdacity.url, type: "Udacity", responseType: LoginResponse.self, body: body, httpMethod: "POST") { response , error in
            if let response = response {
                
                    Auth.sessionId = response.session.id
                    Auth.key = response.account.key
                    fetchLoggedInUser(completion: { (success, error) in
                        if success {
                            print("Logged in user's profile fetched.")
                        }
                    })
                    completion(true, nil)
                
                } else {
                    
                    completion(false, nil)
                    print("\(error) error fetched from login in client udacity")
                    
                    
                    
                }
            }
        }
            
    class func fetchLoggedInUser(completion:@escaping(Bool, Error?)->Void){
        HelperFunctions.taskForGetRequest(url: Endpoints.getLoggedinUserProfile.url, type: "Udacity", responseType: UserProfile.self) { response , error  in
            if let response = response {
                print("First Name : \(response.firstName) and Last Name : \(response.lastName)")
                print("\(response) THIS IS THE RESPONSE FROM FETCHLOGGEDINUSER")
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                print("Error fetching logged in user \(error)")
                completion(false, error)
            }
        }
    }
    

    
    class func logout(completion: @escaping()->Void){
        var request = URLRequest(url: Endpoints.LoginUdacity.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
//                print("Error logging out.")
                
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    // MARK: - Functions regarding location
    class func getStudentLocation(completion: @escaping([StudentInfo]?,
    Error?)->Void){
        HelperFunctions.taskForGetRequest(url: Endpoints.getStudentLocations.url, type: "Parse", responseType: StudentLocation.self) { response , error in
            if let response = response {
                completion(response.results, nil)
//                print("\(response.results) this is the response from response.results")
            } else {
                completion([], error)
            }
        }
        
    }
    
    class func addStudentLocation(info: StudentInfo, completion:@escaping(Bool, Error?)->Void){
        let body = "{\"uniqueKey\": \"\(info.uniqueKey ?? "")\", \"firstName\": \"\(info.firstName)\", \"lastName\": \"\(info.lastName)\",\"mapString\": \"\(info.mapString ?? "")\", \"mediaURL\": \"\(info.mediaURL ?? "")\",\"latitude\": \(info.latitude ?? 0.0), \"longitude\": \(info.longitude ?? 0.0)}"

        HelperFunctions.taskForPostRequest(url: Endpoints.addLocation.url, type: "Parse", responseType: PostLocationResponse.self, body: body, httpMethod: "POST")
        { response , error in
            if let response = response, response.createdAt != nil {
                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
            }
            completion(false, error)
        }
        
           
        
    }
    
    class func updateStudentLocation(info : StudentInfo, completion:@escaping(Bool, Error?)-> Void){
        let body = "{\"uniqueKey\": \"\(info.uniqueKey ?? "")\", \"firstName\": \"\(info.firstName)\", \"lastName\": \"\(info.lastName)\",\"mapString\": \"\(info.mapString ?? "")\", \"mediaURL\": \"\(info.mediaURL ?? "")\",\"latitude\": \(info.latitude ?? 0.0), \"longitude\": \(info.longitude ?? 0.0)}"
        HelperFunctions.taskForPostRequest(url: Endpoints.updateLocation.url, type: "Parse", responseType: UpdateLocationResponse.self, body: body, httpMethod: "PUT") { response , error in
            if let response = response, response.updatedAt != nil {
                completion(true, nil)
            }
            completion(false, error)
        }
        
    }
    

}

