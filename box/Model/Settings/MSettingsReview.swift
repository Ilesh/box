import UIKit

class MSettingsReview:MSettingsProtocol
{
    private let kCellHeight:CGFloat = 80
    
    var reusableIdentifier:String
    {
        get
        {
            return VSettingsCellDistance.reusableIdentifier
        }
    }
    
    var cellHeight:CGFloat
    {
        get
        {
            return kCellHeight
        }
    }
}