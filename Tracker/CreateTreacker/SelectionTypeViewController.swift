import UIKit


final class SelectionTypeViewController: UIViewController {
    
    weak var delegate: TrackersViewControllerProtocol?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackYP
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackYP
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textColor = .whiteYP
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var eventButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackYP
        button.setTitle("Нерегулярные событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textColor = .whiteYP
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack  = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    } ()
    
    private lazy var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

private extension SelectionTypeViewController {
    
    func setup() {
        view.backgroundColor = .whiteYP
        addSubviews()
        activateConstraints()
        addAction()
    }
    
    func addSubviews() {
        stack.addArrangedSubview(habitButton)
        stack.addArrangedSubview(eventButton)
        buttonView.addSubview(stack)
        view.addSubview(titleLabel)
        view.addSubview(buttonView)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 42),
            stack.heightAnchor.constraint(equalToConstant: 136),
            stack.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            buttonView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            buttonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:  20),
            buttonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addAction() {
        habitButton.addTarget(self, action: #selector(Self.createHabit), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(Self.createEvent), for: .touchUpInside)
    }
    
    @objc
    func createHabit() {
        let createHabitViewController = CreateHabitViewController()
        createHabitViewController.delegate = self.delegate
        navigationController?.pushViewController(createHabitViewController, animated: true)
    }
    
    @objc
    func createEvent() {
        let createEventViewController = CreateEventViewController()
        createEventViewController.delegate = self.delegate
        navigationController?.pushViewController(createEventViewController, animated: true)
    }
    
}
