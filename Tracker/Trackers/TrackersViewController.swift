import UIKit


final class TrackersViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .blackYP
        label.text = "Трекеры"
        return label
    }()
    
    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.stubTrackers)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackYP
        label.text = "Что будем отслеживать?"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(TrackerCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerCollectionViewHeader.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    private var categories: [TrackerCategory] = [TrackerCategory(name: "Категория", trackers: [])]
    private var completedTrackers: [TrackerRecord] = []
    private var completedTrackersSet: Set<UInt> = []
    private var currentDayCompletedTrackers: Set<UInt> = []
    private var currentDate: Date = TrackerDate.currentDate()
    private var currentDayCategories: [TrackerCategory] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
}

private extension TrackersViewController {
    
    func setup() {
        view.backgroundColor = .white
        setupNavItem()
        addSubviews()
        activateConstraints()
        setupCollectionView()
        updateTrackers()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    func setupNavItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .plus, style: .done, target: self, action: #selector(Self.createTracker))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(Self.datePickerValueChanged(_:)), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
    }
    
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        view.addSubview(collectionView)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubLabel.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateTrackers() {
        
        var dayCategories: [TrackerCategory] = []
        var dayCompleted: Set<UInt> = []
        
        completedTrackers.forEach   {
            if $0.date == currentDate {
                dayCompleted.insert($0.trackerId)
            }
        }
        
        categories.forEach({
            let trackers = $0.trackers.filter({
                ($0.schedule == nil && (dayCompleted.contains($0.id) || !completedTrackersSet.contains($0.id))) || ($0.schedule != nil && $0.schedule!.contains(TrackerDate.dayOfDate(currentDate)))
            })
            if !trackers.isEmpty {
                dayCategories.append(TrackerCategory(name: $0.name, trackers: trackers))
            }
        })
        
        currentDayCategories = dayCategories
        currentDayCompletedTrackers = dayCompleted
        
        if !dayCategories.isEmpty {
            stubLabel.isHidden = true
            stubImageView.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        }
        else {
            stubLabel.isHidden = false
            stubImageView.isHidden = false
            collectionView.isHidden = true
        }
    }
    
    @objc
    func createTracker() {
        let selectionTypeViewController = SelectionTypeViewController()
        selectionTypeViewController.delegate = self
        let createNavigationContoller = UINavigationController(rootViewController: selectionTypeViewController)
        createNavigationContoller.setNavigationBarHidden(true, animated: false)
        navigationController?.present(createNavigationContoller, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        currentDate = TrackerDate.dateWithoutTime(from: selectedDate)
        updateTrackers()
    }
}


extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2) - 5, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerCollectionViewHeader.identifier, for: indexPath) as? TrackerCollectionViewHeader
        else { return UICollectionReusableView()}
        
        view.setup(name: currentDayCategories[indexPath.section].name)
        return view
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
}


extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDayCategories[section].trackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentDayCategories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        let id = currentDayCategories[indexPath.section].trackers[indexPath.row].id
        let counter = completedTrackers.filter({$0.trackerId == id}).count
        cell.setupCell(tracker: currentDayCategories[indexPath.section].trackers[indexPath.row], counter: UInt(counter), isCompleted: currentDayCompletedTrackers.contains(id)) { [weak self] in
            guard let self else {return}
            if currentDate <= TrackerDate.currentDate() {
                let id = self.currentDayCategories[indexPath.section].trackers[indexPath.row].id
                if !self.currentDayCompletedTrackers.contains(id) {
                    self.completedTrackers.append(TrackerRecord(trackerId: id, date: self.currentDate))
                    self.completedTrackersSet.insert(id)
                    self.currentDayCompletedTrackers.insert(id)
                }
                else {
                    self.completedTrackers.removeAll(where: {$0.trackerId == id &&
                        $0.date == self.currentDate})
                    self.currentDayCompletedTrackers.remove(id)
                    if !self.completedTrackers.contains(where: {$0.trackerId == id}) {
                        self.completedTrackersSet.remove(id)
                    }
                }
                self.collectionView.reloadItems(at: [indexPath])
            }
        }
        return cell
    }
    
}


extension TrackersViewController: TrackersViewControllerProtocol {
    func getCategories() -> [TrackerCategory] {
        self.categories
    }
    
    func addTracker(_ categories: [TrackerCategory]) {
        self.categories = categories
        updateTrackers()
    }
    
    
}
