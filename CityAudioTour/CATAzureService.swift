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
                    
                    var tempAttraction = Attraction()
                    tempAttraction.AttractionName = name
                    tempAttraction.Latitude = latitude
                    tempAttraction.Longitude = longitude
                    tempAttraction.AttractionID = attractionId
                    
                    attractions.append(tempAttraction)
                }
        }
        return attractions;
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
