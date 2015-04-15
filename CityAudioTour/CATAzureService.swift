import Foundation
import UIKit
import SwiftyJSON

public class CATAzureService
{
    public init(){}
    
    private let apiURL = "http://cityaudiotourweb.azurewebsites.net/api"
    private var response:NSURLResponse?
    private var error:NSError?
   // private let
    
    public func GetAttractions() -> [Attraction]
    {
        var attractions = [Attraction]()

        let finalURL = apiURL + "/attraction/"
        let url = NSURL(string:finalURL)
        let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)

        if data != nil {
            var HTTPResponse = response as NSHTTPURLResponse
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
            var HTTPResponse = response as NSHTTPURLResponse
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
            var HTTPResponse = response as NSHTTPURLResponse
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
            var HTTPResponse = response as NSHTTPURLResponse
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
            var HTTPResponse = response as NSHTTPURLResponse
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
        
        connectToDB(requestMessage, MainThreadQueue: MainThread, handler)
    }
    
    func GetAttractionContentByID(AttractionID:Int, MainThread:NSOperationQueue, handler:(response:NSURLResponse!,data:NSData!,error:NSError!) -> Void){

        let finalURL = apiURL + "/attraction/" + String(AttractionID) + "/contents"
        let url = NSURL(string:finalURL)
        
        var request = NSURLRequest(URL: url!)
        connectToDB(request, MainThreadQueue: MainThread, handler)
        
    }

    private func connectToDB(request:NSURLRequest,MainThreadQueue:NSOperationQueue,handler:(response:NSURLResponse!,data:NSData!,error:NSError!) -> Void){
        NSURLConnection.sendAsynchronousRequest(request, queue: MainThreadQueue, completionHandler: handler)
    }
    
    //Authentication Services
    func AuthenticateUser(email: String, password:String, completion: ((succeeded: Bool, msg: String, result: User) -> Void)!){
        let finalURL = apiURL + "/Token";
        var request = NSMutableURLRequest(URL: NSURL(string: finalURL)!)
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        
        var params = ["username":email, "password":password, "grant_type":"password"] as Dictionary<String, String>
        var err: NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                if let parseJSON = json {
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                    //Calling the handler
                    var userTmp = User();
                    completion(succeeded: true, msg: "Succes", result: userTmp)
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }
    
}
