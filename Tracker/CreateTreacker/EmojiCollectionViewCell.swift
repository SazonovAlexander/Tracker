import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EmojiCollectionViewCell"

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        if isSelected {
            backgroundColor = .lightGrayYP
        } else {
            backgroundColor = .none
        }
    }
}

private extension EmojiCollectionViewCell {

    func setupAppearance() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        addSubviews()
        activateConstraints()
    }

    func addSubviews() {
        contentView.addSubview(emojiLabel)
    }

    func activateConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.heightAnchor.constraint(equalToConstant: 40),
            emojiLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}

