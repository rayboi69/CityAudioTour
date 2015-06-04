import Foundation
import UIKit
import SwiftyJSON
//import JSONJoy

public class CATAzureService
{
    public init(){}
    
    private let apiURL = "http://cityaudiotourweb.azurewebsites.net/api"
    private var response:NSURLResponse?
    private var error:NSError?

    public func GetPopularAttractions() -> [Attraction] {
        let finalURL = apiURL + "/attraction/popular/"

        var popular = GetAttractionsHelper(finalURL)
        
        return popular
    }
    
    public func GetAttractions() -> [Attraction] {
        let finalURL = apiURL + "/attraction/"
        
        var attractions = GetAttractionsHelper(finalURL)
        
        return attractions
    }
    
    public func GetAttractionsHelper(finalURL: String) -> [Attraction]
    {
        var attractions = [Attraction]()

        let url = NSURL(string:finalURL)
        let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)

        if data != nil {
            var HTTPResponse = response as! NSHTTPURLResponse
            if HTTPResponse.statusCode == 200 {
                let content = JSON(data: data!)
                let attractionsArray = content.arrayValue
            
                for attraction in attractionsArray {
                    
                    var attractionId = attraction["AttractionID"].intValue
                    var name = attraction["Name"].stringValue
                    var latitude = attraction["Latitude"].doubleValue
                    var longitude = attraction["Longitude"].doubleValue
                    var categoryId = attraction["CategoryID"].intValue
                    var tagIds = attraction["TagIDs"].arrayValue
                    
                    var tempAttraction = Attraction()
                    tempAttraction.AttractionName = name
                    tempAttraction.Latitude = latitude
                    tempAttraction.Longitude = longitude
                    tempAttraction.AttractionID = attractionId
                    tempAttraction.CategoryID = categoryId
                    if let tagsIDArray = attraction["TagIDs"].arrayObject as? [Int] {
                        tempAttraction.TagIDs = tagsIDArray
                    }
                    
                    attractions.append(tempAttraction)
                }
                
                for attraction in attractions {
                    GetAttraction(attraction.AttractionID, MainThread: NSOperationQueue(), handler:
                        {(response:NSURLResponse!,data:NSData!,error:NSError!)-> Void in
                            if data != nil {
                                let json = JSON(data:data!)
                                
                                var address = json["Address"].stringValue
                                var city = json["City"].stringValue
                                var state = json["StateAbbreviation"].stringValue
                                var zip = json["ZipCode"].stringValue
                                var attractionImages = json["AttractionImages"].arrayValue
                                
                                var images = [String]()
                                
                                for imageItem in attractionImages {
                                    
                                    var url = imageItem["URL"].stringValue
                                    images.append(url)
                                }
                                
                                attraction.setAddress(address, city: city, state: state, ZIP: zip)
                                attraction.AttractionName = json["Name"].stringValue
                                attraction.Detail = json["Details"].stringValue
                                attraction.Content = json["TextContent"].stringValue
                                attraction.ImagesURLs = images
                            }
                    })
                }
                
            }else {
                //do something here. (Add more error code here)
            }
        }

        return attractions;
    }
    
    internal func GetCategoryList() -> [Category] {
        let finalURL = apiURL + "/category"
        let url = NSURL(string:finalURL)
        let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)

        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)

        var categories = [Category]()
        
        if data != nil {
            var HTTPResponse = response as! NSHTTPURLResponse
            if HTTPResponse.statusCode == 200 {
                
                let content = JSON(data: data!)
                let categoryArray = content.arrayValue
            
                for category in categoryArray {
                    var id = category["CategoryID"].intValue
                    var name = category["Name"].stringValue
                    
                    var tempCategory = Category()
                    tempCategory.CategoryID = id
                    tempCategory.Name = name
                
                    categories.append(tempCategory)
                }
            }else{
                //do something here. (Add more error code here)
            }
        }
        return categories
    }
    
    internal func GetTagList() -> [Tag] {
        let finalURL = apiURL + "/tag"
        let url = NSURL(string:finalURL)
        let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        var tags = [Tag]()

        if data != nil {
            var HTTPResponse = response as! NSHTTPURLResponse
            if HTTPResponse.statusCode == 200 {
                let content = JSON(data: data!)
                let tagArray = content.arrayValue
            
                for tag in tagArray {
                    var id = tag["TagID"].intValue
                    var name = tag["Name"].stringValue
                
                    var temptag = Tag()
                    temptag.TagID = id
                    temptag.Name = name
                
                    tags.append(temptag)
                }
            }else{
                //do something here. (Add more error code here)
            }
        }
        return tags
    }
    
    internal func GetRoutes() -> [Route] {
        let finalURL = apiURL + "/route"
        let url = NSURL(string: finalURL)
        let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        var routes = [Route]()
        
        if data != nil {
            var HTTPResponse = response as! NSHTTPURLResponse
            if HTTPResponse.statusCode == 200 {
                let content = JSON(data: data!)
                let routeArray = content.arrayValue
            
                for route in routeArray {
                    var tempRoute = Route()
                    tempRoute.RouteID = route["RouteID"].intValue
                    tempRoute.Name = route["Name"].stringValue
                    if let attractionIDArray = route["AttractionIDs"].arrayObject as? [Int] {
                        tempRoute.AttractionIDs = attractionIDArray
                    }
                    if let tagsIDArray = route["Tags"].arrayObject as? [Int] {
                        tempRoute.TagsIDs = tagsIDArray
                    }
                    if let categoriesIDArray = route["Categories"].arrayObject as? [Int] {
                        tempRoute.TagsIDs = categoriesIDArray
                    }
                
                    routes.append(tempRoute)
                }
            }else{
                //do something here. (Add more error code here)
            }
        }
        return routes
    }
    
    
    internal func GetAttractionImagebyId(attractionId : Int) -> [AttractionImage]
    {
        var attractionImages = [AttractionImage]()
        var finalURL = apiURL + "/attraction/" + String(attractionId) + "/images"
        
        let url = NSURL(string:finalURL)
        let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)

        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        if data != nil {
            var HTTPResponse = response as! NSHTTPURLResponse
            if HTTPResponse.statusCode == 200 {
                let content = JSON(data: data!)
                let attractionsArray = content.arrayValue
            
                for attraction in attractionsArray {
                
                    var attractionImageId = attraction["AttractionID"].intValue
                    var attractionId = attraction["AttractionImageID"].intValue
                    var url = attraction["URL"].stringValue
                
                    var tempAttraction = AttractionImage()
                    tempAttraction.setAttractionID(attractionId)
                    tempAttraction.setAttractionImageID(attractionImageId)
                    tempAttraction.setURL(url)
                
                    attractionImages.append(tempAttraction)
                }
            }else{
                //do something here. (Add more error code here)
            }
        }
        return attractionImages;
    }
    
    func GetAttraction(AttractionID:Int, MainThread:NSOperationQueue, handler:(response:NSURLResponse!,data:NSData!,error:NSError!) -> Void){
        
        var finalURL = apiURL + "/attraction/" + String(AttractionID)
        let url = NSURL(string:finalURL)
        
        var requestMessage : NSURLRequest = NSURLRequest(URL: url!)
        
        connectToDB(requestMessage, MainThreadQueue: MainThread, handler: handler)
    }
    
    func GetAttractionContentByID(AttractionID:Int, MainThread:NSOperationQueue, handler:(response:NSURLResponse!,data:NSData!,error:NSError!) -> Void){

        let finalURL = apiURL + "/attraction/" + String(AttractionID) + "/contents"
        let url = NSURL(string:finalURL)
        
        var request = NSURLRequest(URL: url!)
        connectToDB(request, MainThreadQueue: MainThread, handler: handler)
        
    }

    private func connectToDB(request:NSURLRequest,MainThreadQueue:NSOperationQueue,handler:(response:NSURLResponse!,data:NSData!,error:NSError!) -> Void){
        NSURLConnection.sendAsynchronousRequest(request, queue: MainThreadQueue, completionHandler: handler)
    }
    
   /* //Authentication Services
    func AuthenticateUser(email: String, password:String, completion: ((succeeded: Bool, msg: String, result: User) -> Void)!){
        let postString = String(format: "password=%@&username=%@&grant_type=password",password,email)
        self.post(postString, urlResource: "Token"){(error: NSError?, result: NSData?, success: Bool) -> () in
            if(error !=  nil)
            {
                println("After posting \(error!.description)")
            }
            else
            {
                if success
                {
                    var token = AuthToken(JSONDecoder(result!))
                    println("**Token: \(token.access_token)")
                    let jsonStr = NSString(data: result!, encoding: NSUTF8StringEncoding)
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(jsonStr, forKey: "authToken")
                    self.get("Account/UserInfo"){(error: NSError?, result: NSData?, success: Bool) -> () in
                        if(error !=  nil)
                        {
                            println("After getting \(error!.description)")
                        }
                        else
                        {
                            var message = ""
                            var user : User = User(JSONDecoder(result!))

                            if success
                            {
                                message = "User is autenticated"
                            }
                            else
                            {
                                message = "User is autenticated"
                            }
                            completion(succeeded: success, msg: message, result: user)
                        }
                    }
                }
            }
        }
    }*/
    
    //POST Client
    func post(params : String, urlResource: String, postCompleted : ((error: NSError?, result: NSData?, success: Bool) -> Void)!) {
        let finalURL = String(format: "%@/%@", apiURL, urlResource)
        var request = NSMutableURLRequest(URL: NSURL(string: finalURL)!)
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        let data = (params as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            let httpResponse = response as! NSHTTPURLResponse
            var success = true
            println("***HTTP Code POST: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200
            {
                success = false
            }
            
            postCompleted(error: error, result: data, success: success);
        })
        
        task.resume()
    }
    
    //POST Custom route
    func postCustomRoute(title: String, attractionIDs: [Int]) {
        let json: JSON  = ["Name":title, "AttractionIDs":attractionIDs]
        let data = json.rawData()
        
        let finalURL = apiURL + "/createroute/"
        
        
    }
    
   /* //GET Client
    func get(urlResource: String, getCompleted : ((error: NSError?, result: NSData?, success: Bool) -> Void)!) {
        let finalURL = String(format: "%@/%@", apiURL, urlResource)
        var request = NSMutableURLRequest(URL: NSURL(string: finalURL)!)
        var session = NSURLSession.sharedSession()
        
        //Gets token previously stored and sets it up on the header
        let defaults = NSUserDefaults.standardUserDefaults()
        if let tokenJsonString = defaults.stringForKey("authToken")
        {
            var data: NSData = tokenJsonString.dataUsingEncoding(NSUTF8StringEncoding)!
            var token = AuthToken(JSONDecoder(data))
            request.addValue(String(format: "Bearer %@",token.access_token!), forHTTPHeaderField: "Authorization")
        }
        
        request.HTTPMethod = "GET"
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            let httpResponse = response as! NSHTTPURLResponse
            var success = true
            println("***HTTP Code GET: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200
            {
                success = false
            }
            
            getCompleted(error: error, result: data, success: success);
        })
        
        task.resume()
    }*/

}
