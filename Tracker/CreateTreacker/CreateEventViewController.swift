import UIKit


final class CreateEventViewController: UIViewController {
    
    weak var delegate: TrackersViewControllerProtocol?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новое нерегулярное событие"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackYP
        return label
    }()
    
    private lazy var nameTextField: TrackerNameTextField = TrackerNameTextField()
    
    private lazy var selectCategoryButton: SelectButtonItemView = SelectButtonItemView(text: "Категория", separator: false, topCorner: true, bottomCorner: true)
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.redYP, for: .normal)
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .whiteYP
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.redYP.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .grayYP
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()
    
    private var isValidName = false
    private var selectedCategoty: TrackerCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCategoty = delegate?.getCategories()[0]
        setup()
    }
}

private extension CreateEventViewController {
    
    func setup() {
        view.backgroundColor = .whiteYP
        addSubviews()
        activateConstraints()
        setupValidateAction()
        addAction()
    }
    
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(selectCategoryButton)
        view.addSubview(cancelButton)
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
            selectCategoryButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            selectCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectCategoryButton.heightAnchor.constraint(equalToConstant: 75),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor)
        ])
    }
    
    func setupValidateAction() {
        nameTextField.validateAction = {[weak self] isValid in
            guard let self else { return }
            self.isValidName = isValid
            self.activateButton()
        }
    }
    
    func addAction() {
        cancelButton.addTarget(self, action: #selector(Self.cancel), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(Self.create), for: .touchUpInside)
    }
    
    @objc
    func cancel() {
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc
    func create() {
        if let selectedCategoty {
            var trackers = selectedCategoty.trackers
            trackers.append(Tracker(id: Increment.nextId(), name: nameTextField.getText(), color: .blueYP, emoji: "🐶", schedule: nil))
            let category = TrackerCategory(name: selectedCategoty.name, trackers: trackers)
            delegate?.addTracker([category])
            navigationController?.dismiss(animated: true)
        }
    }
    
    func activateButton() {
        if isValidName && selectedCategoty != nil {
            createButton.backgroundColor = .blackYP
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .grayYP
            createButton.isEnabled = false
        }
    }
}
