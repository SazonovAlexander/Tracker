import UIKit


final class CollectionViewHeader: UICollectionReusableView {
    
    static let identifier = "CollectionViewHeader"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blackYP
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
       
    override init(frame: CGRect) {
       super.init(frame: frame)
       setupAppearance()
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String) {
        label.text = name
    }
}

private extension CollectionViewHeader {
    
    func setupAppearance() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
           label.topAnchor.constraint(equalTo: topAnchor, constant: 32),
           label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
           label.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -12),
        ])
    }
    
}
