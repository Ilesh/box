import Foundation
import CoreData

extension DEnergy
{
    static let kMaxEnergy:Int16 = 100
    private static let kEnergyUpdateRate:Int = 1000
    
    //MARK: private
    
    private func updateEnergy()
    {
        let timestamp:TimeInterval = Date().timeIntervalSince1970
        let deltaTimestamp:Int = Int(timestamp - lastDate)
        let energyRecovered:Int = deltaTimestamp / DEnergy.kEnergyUpdateRate
        
        if energyRecovered > 0
        {
            let energy16:Int16 = Int16(energyRecovered)
            var newEnergy:Int16 = lastAmount + energy16
            
            if newEnergy > DEnergy.kMaxEnergy
            {
                newEnergy = DEnergy.kMaxEnergy
            }
            
            amount = newEnergy
            
            DManager.sharedInstance?.save()
        }
    }
    
    //MARK: public
    
    func defaultValues()
    {
        amount = DEnergy.kMaxEnergy
        lastAmount = amount
        lastDate = Date().timeIntervalSince1970
    }
    
    func percentEnergy() -> Int
    {
        if amount >= DEnergy.kMaxEnergy
        {
            return 100
        }
        else
        {
            updateEnergy()
        }
        
        let floatAmount:Float = Float(amount)
        let percentAmount:Float = floatAmount / Float(DEnergy.kMaxEnergy)
        let intPercent:Int = Int(percentAmount * 100)
        
        return intPercent
    }
    
    func spendEnergy(hostile:MGridAlgoItemHostile)
    {
        amount -= Int16(hostile.credits)
        
        if amount < 0
        {
            amount = 0
        }
        
        lastAmount = amount
        lastDate = NSDate().timeIntervalSince1970
        
        DManager.sharedInstance?.save()
    }
}
