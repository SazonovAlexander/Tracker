import UIKit


final class SelectDayViewController: UIViewController {
    
    weak var delegate: CreateHabitViewControllerDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackYP
        return label
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackYP
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var monday: SwitchDayItemView = SwitchDayItemView(day: .monday, text: "Понедельник", separator: true, topCorner: true, bottomCorner: false)
    
    private lazy var tuesday: SwitchDayItemView = SwitchDayItemView(day: .tuesday, text: "Вторник", separator: true, topCorner: false, bottomCorner: false)
    
    private lazy var wednesday: SwitchDayItemView = SwitchDayItemView(day: .wednesday, text: "Среда", separator: true, topCorner: false, bottomCorner: false)
    
    private lazy var thursday: SwitchDayItemView = SwitchDayItemView(day: .thursday, text: "Четверг", separator: true, topCorner: false, bottomCorner: false)
    
    private lazy var friday: SwitchDayItemView = SwitchDayItemView(day: .friday, text: "Пятница", separator: true, topCorner: false, bottomCorner: false)
    
    private lazy var saturday: SwitchDayItemView = SwitchDayItemView(day: .saturday, text: "Суббота", separator: true, topCorner: false, bottomCorner: false)
    
    private lazy var sunday: SwitchDayItemView = SwitchDayItemView(day: .sunday, text: "Воскресенье", separator: false, topCorner: false, bottomCorner: true)
    
    private lazy var daysStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var daysView: [SwitchDayItemView] = []
    private let selectedDays: [Days]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    init(selectedDays: [Days]) {
        self.selectedDays = selectedDays
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SelectDayViewController {
    
    func setup() {
        view.backgroundColor = .whiteYP
        daysView += [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        daysView.forEach({if selectedDays.contains($0.day) {
            $0.setIsSelect()
        }})
        addSubviews()
        activateConstraints()
        addAction()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(readyButton)
        contentView.addSubview(daysStack)
        daysView.forEach({daysStack.addArrangedSubview($0)}
        )
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 42),
            daysStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            daysStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            daysStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daysStack.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -40),
            daysStack.heightAnchor.constraint(equalToConstant: 525),
            readyButton.topAnchor.constraint(equalTo: daysStack.bottomAnchor, constant: 40),
            readyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    func addAction() {
        readyButton.addTarget(self, action: #selector(Self.ready), for: .touchUpInside)
    }
    
    @objc
    func ready() {
        let schedule = daysView.filter({$0.isSelect()}).map({$0.day})
        delegate?.setSchedule(schedule)
        navigationController?.popViewController(animated: true)
    }
}


    



