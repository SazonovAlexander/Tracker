import UIKit


final class SelectButtonItemView: UIButton {

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blackYP
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var selectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .grayYP
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.isHidden = true
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var arrow: UIImageView = {
        let imageView = UIImageView(image: .arrow)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let background: ItemBackgroundView
    
    init(text: String, separator: Bool, topCorner: Bool, bottomCorner: Bool) {
        background = ItemBackgroundView(separator: separator, topCorner: topCorner, bottomCorner: bottomCorner)
        super.init(frame: .zero)
        setup(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelectText(_ text: String) {
        selectLabel.text = text
        selectLabel.isHidden = false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let test = super.hitTest(point, with: event)
        return test != nil ? self : test
    }
}

private extension SelectButtonItemView {
    
    func setup(text: String) {
        translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = text
        stack.addArrangedSubview(textLabel)
        stack.addArrangedSubview(selectLabel)
        background.addSubview(stack)
        background.addSubview(arrow)
        addSubview(background)
        
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: arrow.leadingAnchor),
            arrow.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            arrow.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
}
