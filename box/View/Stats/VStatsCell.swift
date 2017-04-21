import UIKit

class VStatsCell:UICollectionViewCell
{
    private weak var imageView:UIImageView!
    private weak var labelTitle:UILabel!
    private weak var labelCount:UILabel!
    private let kImageWidth:CGFloat = 100
    
    override init(frame:CGRect)
    {
        super.init(frame:frame)
        clipsToBounds = true
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
        
        let imageView:UIImageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.center
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView = imageView
        
        let labelTitle:UILabel = UILabel()
        labelTitle.isUserInteractionEnabled = false
        labelTitle.backgroundColor = UIColor.clear
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.font = UIFont.regular(size:12)
        labelTitle.textColor = UIColor.white
        self.labelTitle = labelTitle
        
        let labelCount:UILabel = UILabel()
        labelCount.backgroundColor = UIColor.clear
        labelCount.translatesAutoresizingMaskIntoConstraints = false
        labelCount.isUserInteractionEnabled = false
        labelCount.font = UIFont.numeric(size:30)
        labelCount.textAlignment = NSTextAlignment.right
        labelCount.textColor = UIColor.white
        self.labelCount = labelCount
        
        addSubview(imageView)
        addSubview(labelTitle)
        addSubview(labelCount)
        
        NSLayoutConstraint.equalsVertical(
            view:imageView,
            toView:self)
        NSLayoutConstraint.leftToLeft(
            view:imageView,
            toView:self)
        NSLayoutConstraint.width(
            view:imageView,
            constant:kImageWidth)
    }
    
    required init?(coder:NSCoder)
    {
        return nil
    }
    
    //MARK: public
    
    func config()
    {
    }
}
