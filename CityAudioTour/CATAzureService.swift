import Foundation

class CATAzureService
{
    
    private var apiURL = "http://cityaudiotourweb.azurewebsites.net/api"
    
    internal func GetAttractions() -> [MapViewAttraction]
    {
        var attractions = [MapViewAttraction]()

        let url = NSURL(string: "http://cityaudiotourweb.azurewebsites.net/api/attraction/")
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
                    
                    var tempAttraction = MapViewAttraction(AttractionId: attractionId, Name: name, Latitude: latitude, Longitude: longitude)
                    
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

}
