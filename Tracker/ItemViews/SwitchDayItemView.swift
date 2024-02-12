import UIKit


final class SwitchDayItemView: UIView {
    
    let day: Days
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blackYP
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var daySwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.onTintColor = .switch
        return sw
    }()
    
    init(day: Days, text: String, separator: Bool, topCorner: Bool, bottomCorner: Bool) {
        self.day = day
        super.init(frame: .zero)
        setup(text: text, separator: separator, topCorner: topCorner, bottomCorner: bottomCorner)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isSelect() -> Bool {
        return daySwitch.isOn
    }
    
    func setIsSelect() {
        daySwitch.isOn = true
    }
    
}

private extension SwitchDayItemView {
    
    func setup(text: String, separator: Bool, topCorner: Bool, bottomCorner: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = text
        let background = ItemBackgroundView(separator: separator, topCorner: topCorner, bottomCorner: bottomCorner)
        background.addSubview(textLabel)
        background.addSubview(daySwitch)
        addSubview(background)
        
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: daySwitch.leadingAnchor),
            daySwitch.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            daySwitch.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            daySwitch.widthAnchor.constraint(equalToConstant: 51)
        ])
    }
    
}

