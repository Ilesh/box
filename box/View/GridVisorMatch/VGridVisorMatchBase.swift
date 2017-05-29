import UIKit

class VGridVisorMatchBase:UIView
{
    private weak var controller:CGridVisorMatch!
    private weak var buttonCancel:VGridVisorMatchBaseButton!
    private weak var buttonPlay:VGridVisorMatchBaseButton!
    private let kCornerRadius:CGFloat = 15
    private let kBorderWidth:CGFloat = 1
    private let kButtonSize:CGFloat = 50
    
    init(controller:CGridVisorMatch)
    {
        super.init(frame:CGRect.zero)
        clipsToBounds = true
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = kCornerRadius
        layer.borderWidth = kBorderWidth
        layer.borderColor = UIColor.black.cgColor
        self.controller = controller
        
        let blur:VBlur = VBlur.extraLight()
        
        addSubview(blur)
        
        NSLayoutConstraint.equals(
            view:blur,
            toView:self)
    }
    
    required init?(coder:NSCoder)
    {
        return nil
    }
}
