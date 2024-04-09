import UIKit


final class SelectFilterViewCell: UITableViewCell {
    
    static let identifier = "SelectFilterViewCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .blackYP
        return label
    }()
    
    private lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView(image: .done)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var background: ItemBackgroundView = ItemBackgroundView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(filter: Filters, separator: Bool, topCorner: Bool, bottomCorner: Bool) {
        label.text = filter.localizedString()
        background.config(separator: separator, topCorner: topCorner, bottomCorner: bottomCorner)
    }
    
    func isSelect(_ isSelect: Bool) {
        selectedImageView.isHidden = !isSelect
    }
}

private extension SelectFilterViewCell {
    
    func setup() {
        selectionStyle = .none
        
        contentView.addSubview(background)
        background.addSubview(label)
        background.addSubview(selectedImageView)
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: selectedImageView.leadingAnchor),
            selectedImageView.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            contentView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}
