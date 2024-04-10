import UIKit

class StatisticsViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .blackYP
        label.text = NSLocalizedString("statistics", comment: "Statistics")
        return label
    }()
    
    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.statisticStub)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackYP
        label.text = NSLocalizedString("statistics.stub", comment: "Statistics screen stub")
        return label
    }()
    
    private lazy var completeStatisticView = StatisticView()
    
    private let trackerRecordStore = TrackerRecordStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
}

private extension StatisticsViewController {
    
    func setup() {
        view.backgroundColor = .white
        
        completeStatisticView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews()
        activateConstraints()
    }
    
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        view.addSubview(completeStatisticView)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            stubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubLabel.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            completeStatisticView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            completeStatisticView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            completeStatisticView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77)
        ])
    }
    
    func updateStatistics() {
        let completedCount = trackerRecordStore.records.count
        if completedCount > 0 {
            stubLabel.isHidden = true
            stubImageView.isHidden = true
            completeStatisticView.isHidden = false
            completeStatisticView.setup(text: NSLocalizedString("statistics.completed", comment: "Completed trackers statistic text"), count: completedCount)
        } else {
            stubLabel.isHidden = false
            stubImageView.isHidden = false
            completeStatisticView.isHidden = true
        }
        
    }
}
