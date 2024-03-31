import UIKit


final class CreateEventViewController: UIViewController {
    
    weak var delegate: TrackersViewControllerProtocol?
    
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
        label.text = "Новое нерегулярное событие"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackYP
        return label
    }()
    
    private lazy var nameTextField: NameTextField = NameTextField(type: NameTextField.Types.tracker)
    
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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.identifier)
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var isValidName = false
    private var selectedCategoty: TrackerCategory?
    private var selectedEmoji: IndexPath?
    private var selectedColor: IndexPath?
    private let emojies = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                           "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                            "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private let colors = ["FD4C49", "FF881E", "007BFA", "6E44FE", "33CF69", "E66DD4",
                          "F9D4D4", "34A7FE", "46E69D", "35347C", "FF674D", "FF99CC",
                          "F6C48B", "7994F5", "832CF1", "AD56DA", "8D72E6", "2FD058"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension CreateEventViewController {
    
    func setup() {
        view.backgroundColor = .whiteYP
        addSubviews()
        activateConstraints()
        setupValidateAction()
        setupCollectionView()
        addAction()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(selectCategoryButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(createButton)
        contentView.addSubview(collectionView)
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
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 42),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectCategoryButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            selectCategoryButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectCategoryButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectCategoryButton.heightAnchor.constraint(equalToConstant: 75),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            collectionView.topAnchor.constraint(equalTo: selectCategoryButton.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: self.view.bounds.width + 112),
            createButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
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
        selectCategoryButton.addTarget(self, action: #selector(Self.selectCategory), for: .touchUpInside)
    }
    
    @objc
    func cancel() {
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc
    func create() {
        if let selectedCategoty {
            var trackers = selectedCategoty.trackers
            trackers.append(Tracker(id: UUID(), name: nameTextField.getText(), color: UIColor.colorFromString(colors[selectedColor?.row ?? 0]) ?? .whiteYP, emoji: emojies[selectedEmoji?.row ?? 0], schedule: nil))
            let category = TrackerCategory(id: selectedCategoty.id, name: selectedCategoty.name, trackers: trackers)
            delegate?.addTracker(category)
            navigationController?.dismiss(animated: true)
        }
    }
    
    @objc
    func selectCategory() {
        let selectCategoryViewController = SelectCategoryViewController()
        let viewModel = SelectCategoryViewModel()
        selectCategoryViewController.initialize(viewModel: viewModel)
        viewModel.selectedCategory = { [weak self] category in
            self?.selectedCategoty = category
            self?.selectCategoryButton.setSelectText(category.name)
            self?.activateButton()
        }
        present(selectCategoryViewController, animated: true)
    }
    
    func activateButton() {
        if isValidName && selectedCategoty != nil && selectedColor != nil && selectedEmoji != nil {
            createButton.backgroundColor = .blackYP
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .grayYP
            createButton.isEnabled = false
        }
    }
}


extension CreateEventViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojies.count
        }
        else {
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.setupCell(emoji: emojies[indexPath.row], isSelected: indexPath == selectedEmoji)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.setupCell(color: colors[indexPath.row], isSelected: indexPath == selectedColor)
            return cell
        }
    }
    
    
}


extension CreateEventViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var updateCells: [IndexPath] = [indexPath]
        if indexPath.section == 0 {
            if let selectedEmoji {
                updateCells.append(selectedEmoji)
            }
            selectedEmoji = indexPath
        } else {
            if let selectedColor {
                updateCells.append(selectedColor)
            }
            selectedColor = indexPath
        }
        collectionView.reloadItems(at: updateCells)
        activateButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeader.identifier, for: indexPath) as? CollectionViewHeader
            else { return UICollectionReusableView()}
            
            view.setup(name: "Emoji")
            return view
        } else {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeader.identifier, for: indexPath) as? CollectionViewHeader
            else { return UICollectionReusableView()}
            
            view.setup(name: "Цвет")
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var size = collectionView.bounds.width / 6
        size = size > 52 ? 52 : size
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        let size = collectionView.bounds.width / 6
        return size > 52 ? size - 52 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
