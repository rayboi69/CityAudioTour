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
    
    func GetAttraction(AttractionID:Int) -> Attraction?{
        
        
        var finalURL = apiURL + "/attraction/" + String(AttractionID)
        let url = NSURL(string:finalURL)
        
        var requestMessage : NSURLRequest = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5000)
        
        let jsonObject = NSURLConnection.sendSynchronousRequest(requestMessage, returningResponse: nil, error: nil)
        
        if ( jsonObject != nil ) {
            let retval = Attraction()
            
            let json = JSON(data:jsonObject!)
            
            var address = json["Address"].stringValue
            var city = json["City"].stringValue
            var state = json["StateAbbreviation"].stringValue
            var zip = json["ZipCode"].stringValue
            
            retval.setAddress(address, city: city, state: state, ZIP: zip)
            retval.AttractionName = json["Name"].stringValue
            retval.Detail = json["Details"].stringValue
            retval.Content = json["TextContent"].stringValue
            return retval
        }else{
            return nil
        }
    }
    
    
    func GetAttractionContentByID(AttractionID:Int) -> AttractionContent{

        let finalURL = apiURL + "/attraction/" + String(AttractionID) + "/contents"
        let url = NSURL(string:finalURL)
        
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        
        var attractionContent = AttractionContent()

        
        if data != nil {
            var content = JSON(data: data!)
            
            var title = content[1]["Title"]
            attractionContent.Title = title.stringValue
            
            var speechText = content[1]["Description"]
            attractionContent.Description = speechText.stringValue
        }
        
        return attractionContent

        
    }


}
