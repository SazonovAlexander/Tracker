import UIKit


final class SelectCategoryViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("category", comment: "Category")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .blackYP
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("createCategory.button", comment: "Create category button text"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackYP
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: .stubTrackers)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackYP
        label.text = NSLocalizedString("createCategory.stub", comment: "Category creation screen stub")
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var categories: [TrackerCategory] = [] {
        didSet {
            let hidden = !categories.isEmpty
            stubLabel.isHidden = hidden
            imageView.isHidden = hidden
            tableView.isHidden = !hidden
            tableView.reloadData()
        }
    }
    
    private var viewModel: SelectCategoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func initialize(viewModel: SelectCategoryViewModel) {
        self.viewModel = viewModel
        bind()
        viewModel.getCategories()
    }
}

private extension SelectCategoryViewController {
    
    func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.categories = { [weak self] categories in
            self?.categories = categories
        }
    }
    
    func setup() {
        view.backgroundColor = .whiteYP
        addSubviews()
        activateConstraints()
        addAction()
        setupTableView()
    }
    
    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(addCategoryButton)
        view.addSubview(imageView)
        view.addSubview(tableView)
        view.addSubview(stubLabel)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 42),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -24)
        ])
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SelectCategoryViewCell.self, forCellReuseIdentifier: SelectCategoryViewCell.identifier)
    }
    
    func addAction() {
        addCategoryButton.addTarget(self, action: #selector(Self.addCategory), for: .touchUpInside)
    }
    
    @objc
    func addCategory() {
        let createCategoryViewController = CreateCategoryViewController()
        if let viewModel {
            createCategoryViewController.initialize(viewModel: viewModel)
        }
        present(createCategoryViewController, animated: true)
    }
}


extension SelectCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectCategoryViewCell else
            { return }
        cell.isSelect()
        let category = categories[indexPath.row]
        viewModel?.setSelectedCategory(category)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
    }
}

extension SelectCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectCategoryViewCell.identifier, for: indexPath)
                
        guard let selectCategoryCell = cell as? SelectCategoryViewCell else {
            return UITableViewCell()
        }
        
        let index = indexPath.row
        selectCategoryCell.config(
            text: categories[index].name,
            separator: index != categories.count - 1,
            topCorner: index == 0,
            bottomCorner: index == categories.count - 1
        )

        return selectCategoryCell
    }
}
