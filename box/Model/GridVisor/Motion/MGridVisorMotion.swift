import Foundation
import CoreMotion

class MGridVisorMotion
{
    private weak var controller:CGridVisor!
    private let manager:CMMotionManager!
    private let kRotationThreshold:Double = 1.9
    private let k180Deg:Double = 180
    private let kUpdatesInterval:TimeInterval = 0.07
    
    init(controller:CGridVisor)
    {
        self.controller = controller
        let manager:CMMotionManager = CMMotionManager()
        manager.deviceMotionUpdateInterval = kUpdatesInterval
        self.manager = manager
        
        if manager.isDeviceMotionAvailable
        {
            manager.startDeviceMotionUpdates(
                using:CMAttitudeReferenceFrame.xArbitraryZVertical,
                to:OperationQueue())
            { (data:CMDeviceMotion?, error:Error?) in
                
                guard
                    
                    let dataMotion:CMDeviceMotion = data
                    
                else
                {
                    return
                }
                
                let acceleration:CMAcceleration = dataMotion.gravity
                
                DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async
                { [weak self] in
                    
                    self?.gravityCompute(acceleration:acceleration)
                }
            }
        }
    }
    
    deinit
    {
        cleanSession()
    }
    
    //MARK: private
    
    private func orientationPortrait()
    {
        guard
            
            let _:MGridVisorOrientationPortrait = controller.orientation as? MGridVisorOrientationPortrait
            
        else
        {
            controller.orientation = MGridVisorOrientationPortrait()
            
            return
        }
    }
    
    private func orientationLandscapeLeft()
    {
        guard
            
            let _:MGridVisorOrientationLandscapeLeft = controller.orientation as? MGridVisorOrientationLandscapeLeft
            
        else
        {
            controller.orientation = MGridVisorOrientationLandscapeLeft()
            
            return
        }
    }
    
    private func orientationLandscapeRight()
    {
        guard
            
            let _:MGridVisorOrientationLandscapeRight = controller.orientation as? MGridVisorOrientationLandscapeRight
            
        else
        {
            controller.orientation = MGridVisorOrientationLandscapeRight()
            
            return
        }
    }
    
    private func gravityCompute(acceleration:CMAcceleration)
    {
        let accelerationX:Double = acceleration.x
        let accelerationY:Double = acceleration.y
        let accelerationZ:Double = acceleration.z
        
        let rotationHorizontal:Double = atan2(accelerationX, accelerationY)
        let rotationHorizontalInversed:Double = rotationHorizontal - Double.pi
        let rotationHorizontalDegrees:Double = rotationHorizontal * k180Deg / Double.pi
        let moveHorizontal:Float = Float(rotationHorizontalInversed)
        let compensateHeading:Double
        
        if rotationHorizontalDegrees >= 0
        {
            compensateHeading = k180Deg - rotationHorizontalDegrees
        }
        else
        {
            compensateHeading = -(rotationHorizontalDegrees + k180Deg)
        }
        
        let rotationVertical:Double = atan2(accelerationZ, accelerationY)
        let rotationVerticalDeg:Double = rotationVertical * k180Deg / Double.pi
        let normalRotationVertical:Double
        
        if rotationVerticalDeg >= 0
        {
            normalRotationVertical = -(k180Deg - rotationVerticalDeg)
        }
        else
        {
            normalRotationVertical = k180Deg + rotationVerticalDeg
        }
        
        let moveVertical:Float = Float(normalRotationVertical)
        
        if rotationHorizontal >= 0
        {
            if rotationHorizontal < kRotationThreshold
            {
                orientationLandscapeRight()
            }
            else
            {
                orientationPortrait()
            }
        }
        else
        {
            if rotationHorizontal > -kRotationThreshold
            {
                orientationLandscapeLeft()
            }
            else
            {
                orientationPortrait()
            }
        }
        
        controller.modelRender?.motionRotate(
            moveHorizontal:moveHorizontal,
            moveVertical:moveVertical)
        controller.modelGPS?.compensateHeading = compensateHeading
    }
    
    //MARK: public
    
    func cleanSession()
    {
        manager.stopDeviceMotionUpdates()
    }
}
