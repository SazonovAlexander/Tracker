import UIKit


final class OnboardingViewController: UIViewController {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var backgroundImage: UIImage
    
    init(backgroundImage: UIImage) {
        self.backgroundImage = backgroundImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension OnboardingViewController {
    
    func setup() {
        addSubviews()
        activateConstraints()
    }
    
    func addSubviews() {
        view.addSubview(backgroundImageView)
        backgroundImageView.image = backgroundImage
    }
    
    func activateConstraints() {
        let superView: UIView = view.superview ?? view
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: superView.topAnchor ),
            backgroundImageView.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
        ])
    }
}
