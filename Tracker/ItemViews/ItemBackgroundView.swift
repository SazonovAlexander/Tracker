import UIKit


final class ItemBackgroundView: UIView {
    
    private lazy var separatorLine: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .grayYP
        lineView.isHidden = true
        return lineView
    }()
    
    init(separator: Bool = false, topCorner: Bool = false, bottomCorner: Bool = false) {
        super.init(frame: .zero)
        backgroundColor = .background
        addSubview(separatorLine)
        NSLayoutConstraint.activate([
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        config(separator: separator, topCorner: topCorner, bottomCorner: bottomCorner)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(separator: Bool, topCorner: Bool, bottomCorner: Bool) {
        separatorLine.isHidden = !separator
        if topCorner || bottomCorner {
            layer.cornerRadius = 16
            layer.masksToBounds = true
        } else {
            layer.cornerRadius = 0
        }
        if topCorner && !bottomCorner {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        else if !topCorner && bottomCorner {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
}
