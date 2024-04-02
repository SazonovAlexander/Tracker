import UIKit


final class CreateCategoryViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая категория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackYP
        return label
    }()
    
    private lazy var nameTextField: NameTextField = NameTextField(type: NameTextField.Types.category)
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .grayYP
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()
    
    private var isValidName = false
    
    private var viewModel: SelectCategoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func initialize(viewModel: SelectCategoryViewModel) {
        self.viewModel = viewModel
    }
}


private extension CreateCategoryViewController {
    
    func setup() {
        view.backgroundColor = .whiteYP
        addSubviews()
        activateConstraints()
        setupValidateAction()
        addActions()
    }
    
    func setupValidateAction() {
        nameTextField.validateAction = {[weak self] isValid in
            guard let self else { return }
            self.isValidName = isValid
            self.activateButton()
        }
    }
    
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(createButton)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        titleLabel.heightAnchor.constraint(equalToConstant: 42),
        nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
        nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        createButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func activateButton() {
        if isValidName {
            createButton.backgroundColor = .blackYP
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .grayYP
            createButton.isEnabled = false
        }
    }
    
    func addActions() {
        createButton.addTarget(self, action: #selector(Self.createCategory), for: .touchUpInside)
    }
    
    @objc
    func createCategory() {
        do { 
            try viewModel?.addCategory(name: nameTextField.getText())
            dismiss(animated: true)
        } catch (let error) {
            let alert = UIAlertController(title: "Что-то пошло не так", message: error.localizedDescription, preferredStyle: .alert)
            present(alert, animated: true)
        }
    }
}
