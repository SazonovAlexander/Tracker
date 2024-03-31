import UIKit


final class NameTextField: UIView {
    
    enum Types {
        static let tracker = "трекера"
        static let category = "категории"
    }
    
    var validateAction: ((Bool) -> Void)?
    
    private var isValid: Bool = false
    
    private let type: String
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = .background
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .blackYP
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightViewMode = .whileEditing
        return textField
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.clear, for: .normal)
        return button
    }()
    
    private lazy var validateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .redYP
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "Ограничение 38 символов"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()
    
    init(type: String) {
        self.type = type
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getText() -> String {
        return textField.text ?? ""
    }
}

private extension NameTextField {
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        textField.rightView = clearButton
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название \(type)",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.grayYP,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        
        stack.addArrangedSubview(textField)
        stack.addArrangedSubview(validateLabel)
        addSubview(stack)
        
        textField.addTarget(self, action: #selector(Self.validateName), for: .allEditingEvents)
        clearButton.addTarget(self, action: #selector(Self.clearText), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75),
            clearButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    @objc
    func clearText() {
        textField.text = nil
        validateLabel.isHidden = true
        validateAction?(false)
    }
    
    @objc
    func validateName() {
        if let text = textField.text {
            let count = text.count
            var result = false
            if count > 38 {
                presentValidateLabel()
            }
            else {
                hideValidateLabel()
                if count != 0 {
                    result = true
                }
            }
            validateAction?(result)
        }
    }
    
    func hideValidateLabel() {
        validateLabel.isHidden = true
    }
    
    func presentValidateLabel() {
        validateLabel.isHidden = false
    }
}

