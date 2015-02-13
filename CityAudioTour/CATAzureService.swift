import Foundation

class CATAzureService
{
    
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
}
