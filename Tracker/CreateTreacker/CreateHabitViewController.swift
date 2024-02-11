import UIKit


final class CreateHabitViewController: UIViewController {
    
    weak var delegate: TrackersViewControllerProtocol?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackYP
        return label
    }()
    
    private lazy var nameTextField: TrackerNameTextField = TrackerNameTextField()
    
    private lazy var selectCategoryButton: SelectButtonItemView = SelectButtonItemView(text: "Категория", separator: true, topCorner: true, bottomCorner: false)
    
    private lazy var selectScheduleButton: SelectButtonItemView = SelectButtonItemView(text: "Расписание", separator: false, topCorner: false, bottomCorner: true)
    
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
    private var schedule: [Days] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCategoty = delegate?.getCategories()[0]
        setup()
    }
}

private extension CreateHabitViewController {
    
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
        view.addSubview(selectScheduleButton)
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
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            selectScheduleButton.topAnchor.constraint(equalTo: selectCategoryButton.bottomAnchor),
            selectScheduleButton.leadingAnchor.constraint(equalTo: selectCategoryButton.leadingAnchor),
            selectScheduleButton.trailingAnchor.constraint(equalTo: selectCategoryButton.trailingAnchor),
            selectScheduleButton.heightAnchor.constraint(equalToConstant: 75)
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
        selectScheduleButton.addTarget(self, action: #selector(Self.selectSchedule), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(Self.create), for: .touchUpInside)
    }
    
    @objc
    func selectSchedule() {
        let selectDayViewController = SelectDayViewController(selectedDays: schedule)
        selectDayViewController.delegate = self
        navigationController?.pushViewController(selectDayViewController, animated: true)
    }
    
    @objc
    func create() {
        if let selectedCategoty {
            var trackers = selectedCategoty.trackers
            trackers.append(Tracker(id: Increment.nextId(), name: nameTextField.getText(), color: .green, emoji: "🍔", schedule: schedule))
            let category = TrackerCategory(name: selectedCategoty.name, trackers: trackers)
            delegate?.addTracker([category])
            navigationController?.dismiss(animated: true)
        }
    }
    
    @objc
    func cancel() {
        self.navigationController?.dismiss(animated: true)
    }
    
    func activateButton() {
        if isValidName && selectedCategoty != nil && !schedule.isEmpty {
            createButton.backgroundColor = .blackYP
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .grayYP
            createButton.isEnabled = false
        }
    }
}

extension CreateHabitViewController: CreateHabitViewControllerDelegate {
    
    func setSchedule(_ schedule: [Days]) {
        self.schedule = schedule
        var daysText = ""
        if schedule.count == 7 {
            daysText = "Каждый день"
        }
        else if schedule.count > 0 {
            schedule.forEach({daysText += "\($0.rawValue), "})
            daysText.removeLast(2)
        }
        selectScheduleButton.setSelectText(daysText)
        self.activateButton()
    }
    
}

