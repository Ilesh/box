import Foundation
import CoreLocation

class MScannerGPS:NSObject, CLLocationManagerDelegate
{
    private weak var controller:CScanner!
    private var locationManager:CLLocationManager?
    private let kLocationDistanceFilter:CLLocationDistance = 10
    
    init(controller:CScanner)
    {
        self.controller = controller
        super.init()
        
        DispatchQueue.main.async
        { [weak self] in
            
            self?.asyncAskLocation()
        }
    }
    
    deinit
    {
        locationManager?.stopUpdatingHeading()
        locationManager?.stopUpdatingLocation()
    }
    
    //MARK: private
    
    private func asyncAskLocation()
    {
        let locationManager:CLLocationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kLocationDistanceFilter
        locationManager.delegate = self
        self.locationManager = locationManager
        
        let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        switch status
        {
        case CLAuthorizationStatus.authorizedAlways,
             CLAuthorizationStatus.authorizedWhenInUse:
            
            authGranted()
            
            break
            
        case CLAuthorizationStatus.notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
            
            break
            
        default:
            
            let error:String = NSLocalizedString("MScannerGPS_errorAuth", comment:"")
            VAlert.message(message:error)
            
            break
        }
    }
    
    private func authGranted()
    {
        locationManager?.startUpdatingLocation()
        locationManager?.startUpdatingHeading()
    }
    
    //MARK: public
    
    func changeOrientationPortrait()
    {
        print("portrait")
        locationManager?.headingOrientation = CLDeviceOrientation.portrait
    }
    
    func changeOrientationLandscapeLeft()
    {
        print("landspace left")
        locationManager?.headingOrientation = CLDeviceOrientation.landscapeLeft
    }
    
    func changeOrientationLandscapeRight()
    {
        print("landscape right")
        locationManager?.headingOrientation = CLDeviceOrientation.landscapeRight
    }
    
    //MARK: location delegate
    
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus)
    {
        switch status
        {
        case CLAuthorizationStatus.authorizedAlways,
             CLAuthorizationStatus.authorizedWhenInUse:
 
            authGranted()
            
            break
            
        case CLAuthorizationStatus.notDetermined:
            break
            
        default:
            
            let error:String = NSLocalizedString("MScannerGPS_errorAuth", comment:"")
            VAlert.message(message:error)
            
            break
        }
    }
    
    func locationManager(_ manager:CLLocationManager, didFailWithError error:Error)
    {
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateHeading newHeading:CLHeading)
    {
        let magneticHeading:CLLocationDirection = newHeading.magneticHeading
        
        guard
            
            let inversedHeading:Float = controller.modelRender?.mines.inverseHeading
        
        else
        {
            return
        }
        
        let compensedHeading:CLLocationDirection = CLLocationDirection(inversedHeading) + magneticHeading
        let normalHeading:CLLocationDirection
        
        if magneticHeading >= 180
        {
            normalHeading = compensedHeading - 360
        }
        else
        {
            normalHeading = compensedHeading
        }
        
        controller.modelRender?.mines.userHeading = normalHeading
    }
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation])
    {
        guard
        
            let currentLocation:CLLocation = locations.last
        
        else
        {
            return
        }
        
//        for mine:MScannerMinesItem in controller.modelMines.items
//        {
//            print("distance")
//            print(currentLocation.distance(from:mine.location))
//        }
        
//        print(currentLocation.coordinate)
    }
}
