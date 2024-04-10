import UIKit


final class TrackersViewController: UIViewController {
    
    private lazy var searchField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = NSLocalizedString("search", comment: "Search text field placeholder")
        return searchTextField
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .blackYP
        label.text = NSLocalizedString("trackers", comment: "Trackers")
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
        label.text = NSLocalizedString("trackers.stub", comment: "Trackers screen stub")
        return label
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blueYP
        button.setTitleColor(.whiteYP, for: .normal)
        button.setTitle(NSLocalizedString("filters", comment: "Filter button text"), for: .normal)
        button.layer.zPosition = 2
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 16
        return button
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
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private let trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore: TrackerRecordStore = TrackerRecordStore()
    private let trackerStore: TrackerStore = TrackerStore()
    private var selectedFilter: Filters = .all
    private var categories: [TrackerCategory] = []
    private var trackers: [Tracker] = []
    private var completedTrackers: [TrackerRecord] = []
    private var completedTrackersSet: Set<UUID> = []
    private var currentDayCompletedTrackers: Set<UUID> = []
    private var currentDate: Date = TrackerDate.currentDate()
    private var currentDayCategories: [TrackerCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        self.categories = trackerCategoryStore.categories
        self.completedTrackers = trackerRecordStore.records
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticManager.shared.report(event: .open, screen: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticManager.shared.report(event: .close, screen: .main)
    }
    
    func updateDate(_ date: Date) {
        currentDate = TrackerDate.dateWithoutTime(from: date)
        if selectedFilter == .current {
            selectedFilter = .all
        }
        updateTrackers()
    }
}

private extension TrackersViewController {
    
    func setup() {
        view.backgroundColor = .screenBackground
        setupNavItem()
        addSubviews()
        activateConstraints()
        setupCollectionView()
        addActions()
        updateTrackers()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .screenBackground
    }
    
    
    func setupNavItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .plus, style: .done, target: self, action: #selector(Self.createTracker))
        self.navigationItem.leftBarButtonItem?.tintColor = .blackYP
        
        datePicker.addTarget(self, action: #selector(Self.datePickerValueChanged(_:)), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        view.addSubview(collectionView)
        view.addSubview(searchField)
        view.addSubview(filterButton)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            stubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubLabel.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114)
        ])
    }
    
    func addActions() {
        searchField.addTarget(self, action: #selector(Self.updateTrackers), for: .editingChanged)
        filterButton.addTarget(self, action: #selector(Self.selectFilter), for: .touchUpInside)
    }
    
    @objc
    func selectFilter() {
        AnalyticManager.shared.report(event: .click, screen: .main, item: .filter)
        let selectFilterViewController = SelectFilterViewController(selectedFilter: selectedFilter)
        selectFilterViewController.delegate = self
        present(selectFilterViewController, animated: true)
    }
    
    @objc
    func updateTrackers() {
        if selectedFilter == .current {
            currentDate = TrackerDate.currentDate()
            datePicker.date = currentDate
        }
        
        var dayCategories: [TrackerCategory] = []
        var dayCompleted: Set<UUID> = []
        
        completedTrackers.forEach   {
            if $0.date == currentDate {
                dayCompleted.insert($0.trackerId)
            }
        }
        var fixedTrackers: [Tracker] = []
        let searchText = searchField.text ?? ""
        categories.forEach({
            let trackers = $0.trackers.filter({
                ((($0.schedule == nil && (dayCompleted.contains($0.id) || !completedTrackersSet.contains($0.id))) ||
                ($0.schedule != nil && $0.schedule!.contains(TrackerDate.dayOfDate(currentDate))))) &&
                (!searchText.isEmpty ? $0.name.lowercased().contains(searchText.lowercased()) : true) &&
                !$0.isFixed &&
                (selectedFilter == .completed ? dayCompleted.contains($0.id) : true) &&
                (selectedFilter == .uncompleted ? !dayCompleted.contains($0.id) : true)
            })
            let categoryFixedTrackers = $0.trackers.filter({
                ((($0.schedule == nil && (dayCompleted.contains($0.id) || !completedTrackersSet.contains($0.id))) ||
                ($0.schedule != nil && $0.schedule!.contains(TrackerDate.dayOfDate(currentDate))))) &&
                (!searchText.isEmpty ? $0.name.lowercased().contains(searchText.lowercased()) : true) &&
                $0.isFixed &&
                (selectedFilter == .completed ? dayCompleted.contains($0.id) : true) &&
                (selectedFilter == .uncompleted ? !dayCompleted.contains($0.id) : true)
            })
            fixedTrackers += categoryFixedTrackers
            if !trackers.isEmpty {
                dayCategories.append(TrackerCategory(id: $0.id, name: $0.name, trackers: trackers))
            }
        })
        
        if !fixedTrackers.isEmpty {
            dayCategories.insert(TrackerCategory(id: UUID(), name: NSLocalizedString("fixedCategory", comment: "Fixed category name"), trackers: fixedTrackers), at: 0)
        }
        
        if dayCategories.isEmpty {
            if !searchText.isEmpty || selectedFilter != .all {
                stubLabel.text = NSLocalizedString("searchStub", comment: "Search stub label text")
                stubImageView.image = .searchStub
            } else {
                stubLabel.text = NSLocalizedString("trackers.stub", comment: "Trackers screen stub")
                stubImageView.image = .stubTrackers
            }
        }
        
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
        AnalyticManager.shared.report(event: .click, screen: .main, item: .add_track)
        let selectionTypeViewController = SelectionTypeViewController()
        selectionTypeViewController.delegate = self
        let createNavigationContoller = UINavigationController(rootViewController: selectionTypeViewController)
        createNavigationContoller.setNavigationBarHidden(true, animated: false)
        navigationController?.present(createNavigationContoller, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDate(sender.date)
    }
    
    func presentErrorAlert(error: String) {
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .destructive))
        present(alert, animated: true)
    }
    
    func isFixed(tracker: Tracker) {
        do {
            let newTracker = Tracker(
                id: tracker.id,
                name: tracker.name,
                color: tracker.color,
                emoji: tracker.emoji,
                schedule: tracker.schedule,
                isFixed: !tracker.isFixed
            )
            try trackerStore.updateTracker(newTracker)
            categories = trackerCategoryStore.categories
            updateTrackers()
        } catch (let error) {
            presentErrorAlert(error: error.localizedDescription)
        }
    }
    
    func updateTracker(_ tracker: Tracker) {
        AnalyticManager.shared.report(event: .click, screen: .main, item: .edit)
        let category = categories.filter({$0.trackers.contains(where: {$0.id == tracker.id})}).first
        if tracker.schedule != nil {
            let counter = completedTrackers.filter({$0.trackerId == tracker.id}).count
            let changeTrackerViewController = CreateHabitViewController(tracker: tracker, category: category, countCompletedDays: counter)
            changeTrackerViewController.delegate = self
            let changeNavigationContoller = UINavigationController(rootViewController: changeTrackerViewController)
            changeNavigationContoller.setNavigationBarHidden(true, animated: false)
            self.navigationController?.present(changeNavigationContoller, animated: true)
        } else {
            let changeTrackerViewController = CreateEventViewController(tracker: tracker, category: category)
            changeTrackerViewController.delegate = self
            let changeNavigationContoller = UINavigationController(rootViewController: changeTrackerViewController)
            changeNavigationContoller.setNavigationBarHidden(true, animated: false)
            self.navigationController?.present(changeNavigationContoller, animated: true)
        }
    }
    
    func deleteTracker(_ tracker: Tracker) {
        AnalyticManager.shared.report(event: .click, screen: .main, item: .delete)
        do {
            try trackerStore.deleteTracker(tracker)
            categories = trackerCategoryStore.categories
            updateTrackers()
        } catch (let error) {
            presentErrorAlert(error: error.localizedDescription)
        }
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
        
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
                
        let indexPath = indexPaths[0]
        let category = currentDayCategories[indexPath.section]
        let tracker = category.trackers[indexPath.row]
        let fixedAction = UIAction(title: tracker.isFixed
            ? NSLocalizedString("noFixed", comment: "Tracker is fixed")
            : NSLocalizedString("fixed", comment: "Tracker is not fixed")
        ) { [weak self] _ in
            self?.isFixed(tracker: tracker)
        }
        let changeAction = UIAction(title: NSLocalizedString("change", comment: "Change text button")) { [weak self] _ in
            self?.updateTracker(tracker)
        }
        let deleteAction = UIAction(title: NSLocalizedString("delete", comment: "Delete text button"), attributes: .destructive){ [weak self] _ in
            self?.deleteTracker(tracker)
        }
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                fixedAction,
                changeAction,
                deleteAction
            ])
        })
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
            do {
                if currentDate <= TrackerDate.currentDate() {
                    let id = self.currentDayCategories[indexPath.section].trackers[indexPath.row].id
                    if !self.currentDayCompletedTrackers.contains(id) {
                        let record = TrackerRecord(id: UUID(), trackerId: id, date: self.currentDate)
                        self.completedTrackers.append(record)
                        self.completedTrackersSet.insert(id)
                        self.currentDayCompletedTrackers.insert(id)
                        try self.trackerRecordStore.addRecord(record)
                    }
                    else {
                        if let recordId = completedTrackers.first(where: {
                            $0.trackerId == id && $0.date == self.currentDate
                        })?.id {
                            try self.trackerRecordStore.deleteRecord(id: recordId)
                            self.completedTrackers.removeAll(where: {$0.trackerId == id &&
                                $0.date == self.currentDate})
                            self.currentDayCompletedTrackers.remove(id)
                            if !self.completedTrackers.contains(where: {$0.trackerId == id}) {
                                self.completedTrackersSet.remove(id)
                            }
                        }
                    }
                    self.collectionView.reloadItems(at: [indexPath])
                }
            } catch (let error) {
                presentErrorAlert(error: error.localizedDescription)
            }
        }
        return cell
    }
    
}


extension TrackersViewController: TrackersViewControllerProtocol {
    func setFilter(_ filter: Filters) {
        selectedFilter = filter
        updateTrackers()
    }
    
    func changeTracker(_ tracker: Tracker) {
        do {
            try trackerStore.updateTracker(tracker)
            categories = trackerCategoryStore.categories
            updateTrackers()
        } catch (let error) {
            presentErrorAlert(error: error.localizedDescription)
        }
    }
    
    func getCategories() -> [TrackerCategory] {
        self.categories
    }
    
    func addTracker(_ category: TrackerCategory) {
        do {
            if categories.contains(where: {$0.id == category.id}) {
                try trackerCategoryStore.updateCategory(category)
            } else {
                try trackerCategoryStore.addCategory(category)
            }
        } catch (let error) {
            presentErrorAlert(error: error.localizedDescription)
        }
    }
}


extension TrackersViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore) {
        categories = store.categories
        updateTrackers()
    }
}


extension TrackersViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore) {
        completedTrackers = store.records
    }
}


