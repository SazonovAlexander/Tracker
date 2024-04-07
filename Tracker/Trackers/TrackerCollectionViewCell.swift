import UIKit


final class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TrackerCollectionViewCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.zPosition = 2
        label.backgroundColor = UIColor.emojiBackground
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.zPosition = 1
        label.textColor = .whiteYP
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blackYP
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.layer.masksToBounds = true
        return button
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.cardBorder.cgColor
        return view
    }()
    
    private var completeButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(tracker: Tracker, counter: UInt, isCompleted: Bool, completeButtonAction: @escaping (() -> Void)) {
        emojiLabel.text = tracker.emoji
        cardView.backgroundColor = tracker.color
        completeButton.backgroundColor = tracker.color
        counterLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "Number of days"), Int(counter))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributedString = NSMutableAttributedString(string: tracker.name)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        nameLabel.attributedText = attributedString
        if isCompleted {
            completeButton.setImage(UIImage.done.withTintColor(.whiteYP), for: .normal)
            completeButton.alpha = 0.3
        } else {
            completeButton.setImage(UIImage.plusCompleted.withTintColor(.whiteYP), for: .normal)
            completeButton.alpha = 1
        }
        self.completeButtonAction = completeButtonAction
    }
}

private extension TrackerCollectionViewCell {
    
    func setupAppearance() {
        addSubviews()
        activateConstraints()
    }
    
    func addSubviews() {
        cardView.addSubview(emojiLabel)
        cardView.addSubview(nameLabel)
        contentView.addSubview(cardView)
        contentView.addSubview(completeButton)
        contentView.addSubview(counterLabel)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor,constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            counterLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            completeButton.centerYAnchor.constraint(equalTo: counterLabel.centerYAnchor),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func setupAction() {
        completeButton.addTarget(self, action: #selector(Self.tapCompleteButton), for: .touchUpInside)
    }
    
    @objc
    func tapCompleteButton() {
        completeButtonAction?()
    }
}

