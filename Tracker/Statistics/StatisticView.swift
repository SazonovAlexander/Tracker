import UIKit


final class StatisticView: UIView {
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .blackYP
        return label
    }()
    
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackYP
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.borderWidth = 1
        
        addSubview(countLabel)
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 90),
            countLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            textLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            textLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
            countLabel.topAnchor.constraint(lessThanOrEqualTo: textLabel.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradient()
    }
    
    func setup(text: String, count: Int) {
        countLabel.text = "\(count)"
        textLabel.text = text
    }
    
    private func updateGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [
            UIColor.colorFromString("FD4C49")?.cgColor ?? UIColor.clear.cgColor,
            UIColor.colorFromString("46E69D")?.cgColor ?? UIColor.clear.cgColor,
            UIColor.colorFromString("007BFA")?.cgColor ?? UIColor.clear.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let gradientImage = renderer.image { ctx in
            gradient.render(in: ctx.cgContext)
        }
        layer.borderColor = UIColor(patternImage: gradientImage).cgColor
    }
}
