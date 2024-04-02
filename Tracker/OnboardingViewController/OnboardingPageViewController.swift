import UIKit


final class OnboardingPageViewController: UIPageViewController {
    
    private let pages: [UIViewController] = [
        OnboardingViewController(backgroundImage: .firstOnboarding),
        OnboardingViewController(backgroundImage: .secondOnboarding)
    ]
    
    private let pagesText: [String] = [
        "Отслеживайте только то, что хотите",
        "Даже если это не литры воды и йога"
    ]
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .blackYP
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .blackYP
        pageControl.pageIndicatorTintColor = .grayYP
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.whiteYP, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackYP
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension OnboardingPageViewController {
    
    func setup() {
        addSubviews()
        activateConstraints()
        setupPageViewController()
        setupActions()
    }
    
    func setupPageViewController() {
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        if let first = pagesText.first {
            label.text = first
        }
        delegate = self
        dataSource = self
    }
    
    func addSubviews() {
        view.addSubview(button)
        view.addSubview(pageControl)
        view.addSubview(label)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            pageControl.topAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor)
        ])
    }
    
    func setupActions() {
        button.addTarget(self, action: #selector(Self.didTapFinishButton), for: .touchUpInside)
    }
    
    @objc
    func didTapFinishButton() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = TabBarController()
           
  
        window.rootViewController = tabBarController
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
                pageControl.currentPage = currentIndex
                label.text = pagesText[currentIndex]
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
           return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
           return nil
        }

        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else {
            return nil
        }

        return pages[nextIndex]
    }
}
