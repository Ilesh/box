import UIKit

class MHelpBasicIntro:MHelpProtocol
{
    private let attributedString:NSAttributedString
    
    init()
    {
        let attributesTitle:[String:AnyObject] = [
            NSFontAttributeName:UIFont.bold(size:16),
            NSForegroundColorAttributeName:UIColor.white]
        let attributesDescription:[String:AnyObject] = [
            NSFontAttributeName:UIFont.regular(size:15),
            NSForegroundColorAttributeName:UIColor(white:1, alpha:0.7)]
        
        let stringTitle:NSAttributedString = NSAttributedString(
            string:NSLocalizedString("MHelpBasicIntro_title", comment:""),
            attributes:attributesTitle)
        let stringDescription:NSAttributedString = NSAttributedString(
            string:NSLocalizedString("MHelpBasicIntro_description", comment:""),
            attributes:attributesDescription)
        let mutableString:NSMutableAttributedString = NSMutableAttributedString()
        mutableString.append(stringTitle)
        mutableString.append(stringDescription)
        
        attributedString = mutableString
    }
    
    var message:NSAttributedString
    {
        get
        {
            return attributedString
        }
    }
    
    var image:UIImage
    {
        get
        {
            return #imageLiteral(resourceName: "assetHelpBasicIntro")
        }
    }
}