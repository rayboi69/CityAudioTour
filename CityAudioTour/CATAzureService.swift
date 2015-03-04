import Foundation

class CATAzureService
{
    
    private var apiURL = "http://cityaudiotourweb.azurewebsites.net/api"
    
    internal func GetAttractions() -> [Attraction]
    {
        var attractions = [Attraction]()

        var finalURL = apiURL + "/attraction/"
        let url = NSURL(string:finalURL)
        var request = NSURLRequest(URL: url!)
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)

        if data != nil {
            let content = JSON(data: data!)
            let attractionsArray = content.arrayValue
            
                for attraction in attractionsArray {
                    
                    var attractionId = attraction["AttractionID"].intValue
                    var name = attraction["Name"].stringValue
                    var latitude = attraction["Latitude"].doubleValue
                    var longitude = attraction["Longitude"].doubleValue
                    var categoryId = attraction["CategoryID"].intValue
                    
                    var tempAttraction = Attraction()
                    tempAttraction.AttractionName = name
                    tempAttraction.Latitude = latitude
                    tempAttraction.Longitude = longitude
                    tempAttraction.AttractionID = attractionId
                    tempAttraction.CategoryID = categoryId
                    //TODO - replace with real Tags IDS
                    tempAttraction.TagIDs = [1, 2, 3, 4, 5, 6]
                    tempAttraction.isHiden = false;
                    
                    attractions.append(tempAttraction)
                }
        }
        return attractions;
    }
    
    internal func GetCategoryList() -> [Category] {
        let finalURL = apiURL + "/category"
        let url = NSURL(string:finalURL)
        var request = NSURLRequest(URL: url!)
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)

        var categories = [Category]()
        
        if data != nil {
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
        }
        return categories
    }
    
    internal func GetTagList() -> [Tag] {
        let finalURL = apiURL + "/tag"
        let url = NSURL(string:finalURL)
        var request = NSURLRequest(URL: url!)
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        
        var tags = [Tag]()
        if data != nil {
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
        }
        return tags
    }
    
    internal func GetRoutes() -> [Route] {
        let finalURL = apiURL + "/route"
        let url = NSURL(string: finalURL)
        var request = NSURLRequest(URL: url!)
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        
        var routes = [Route]()
        if data != nil {
            let content = JSON(data: data!)
            let routeArray = content.arrayValue
            
            for route in routeArray {
                var tempRoute = Route()
                tempRoute.RouteID = route["RouteID"].intValue
                tempRoute.Name = route["Name"].stringValue
                if let attractionIDArray = route["AttractionIDs"].arrayObject as? [Int] {
                    tempRoute.AttractionIDs = attractionIDArray
                }
                
                routes.append(tempRoute)
            }
        }
        return routes
    }
    
    
    internal func GetAttractionImagebyId(attractionId : Int) -> [AttractionImage]
    {
        var attractionImages = [AttractionImage]()
        var finalURL = apiURL + "/attraction/" + String(attractionId) + "/images"
        
        let url = NSURL(string:finalURL)
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        
        if data != nil {
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
}
