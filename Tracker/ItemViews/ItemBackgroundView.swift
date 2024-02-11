import UIKit


final class ItemBackgroundView: UIView {
    
    init(separator: Bool, topCorner: Bool, bottomCorner: Bool) {
        super.init(frame: .zero)
        backgroundColor = .background
        if separator {
            let lineView = UIView()
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.backgroundColor = .grayYP
            addSubview(lineView)
            NSLayoutConstraint.activate([
                lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
                lineView.heightAnchor.constraint(equalToConstant: 1),
                lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        }
        if topCorner || bottomCorner {
            layer.cornerRadius = 16
            layer.masksToBounds = true
        }
        if topCorner && !bottomCorner {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        else if !topCorner && bottomCorner {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
