import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ColorCollectionViewCell"

    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.whiteYP.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    private var color: UIColor?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(color: String, isSelected: Bool) {
        let color = UIColor.colorFromString(color)
        colorView.backgroundColor = color
        self.color = color
        if isSelected {
            backgroundColor = self.color?.withAlphaComponent(0.3)
        } else {
            backgroundColor = .none
        }
    }
}

private extension ColorCollectionViewCell {

    func setupAppearance() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubviews()
        activateConstraints()
    }

    func addSubviews() {
        contentView.addSubview(colorView)
    }

    func activateConstraints() {
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 46),
            colorView.widthAnchor.constraint(equalToConstant: 46)
        ])
    }
}
