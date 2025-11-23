//
//  CustomTabBarView.swift
//  UIGlassContainerEffect-Demo
//
//  Created by Thomas on 2025/11/23.
//

import UIKit

enum CustomTab: String, CaseIterable {
    case home = "Home"
    case notifications = "Notifications"
    case settings = "Settings"
    
    var symbol: String {
        switch self {
        case .home: return "house"
        case .notifications: return "bell"
        case .settings: return "gearshape"
        }
    }
    
    var selectedSymbol: String {
        switch self {
        case .home: return "house.fill"
        case .notifications: return "bell.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

class CustomTabBarView: UIView {

    private let segmentedControl = UISegmentedControl()
    private let allTabs = CustomTab.allCases
    
    var onTabSelected: ((CustomTab) -> Void)?
    var activeTint: UIColor = .label
    var inActiveTint: UIColor = .secondaryLabel
    
    private var symbolSize: CGSize = .zero
    private var textSize: CGSize = .zero
    
    var activeTab: CustomTab = .home {
        didSet {
            segmentedControl.selectedSegmentIndex = activeTab.index
            updateSegmentImages()
        }
    }

    private lazy var animationLayerView = AnimationTabLayerView(symbolSize: symbolSize)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupAnimationLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.topAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        segmentedControl.removeAllSegments()
        for (index, _) in allTabs.enumerated() {
            segmentedControl.insertSegment(withTitle: "", at: index, animated: false)
        }
        updateSegmentImages()
        segmentedControl.selectedSegmentIndex = activeTab.index
        segmentedControl.addTarget(self, action: #selector(tabSelected(_:)), for: .valueChanged)
    }
    
    
    private func setupAnimationLayer() {
        addSubview(animationLayerView)
        animationLayerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationLayerView.topAnchor.constraint(equalTo: self.topAnchor),
            animationLayerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -textSize.height),
            animationLayerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            animationLayerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        animationLayerView.activeTab(at: activeTab.index)
    }

    @objc private func tabSelected(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        guard let newTab = allTabs[safe: selectedIndex] else { return }
        
        self.activeTab = newTab
        onTabSelected?(newTab)
        animationLayerView.activeTab(at: selectedIndex)
    }

    private func updateSegmentImages() {
        for (index, tab) in allTabs.enumerated() {
            let isSelected = (tab == activeTab)
            let image = createImageFor(tab: tab, isSelected: isSelected)
            segmentedControl.setImage(image, forSegmentAt: index)
        }
    }

    private func createImageFor(tab: CustomTab, isSelected: Bool) -> UIImage {
        let symbolName = isSelected ? tab.selectedSymbol : tab.symbol
        let text = tab.rawValue
        let color = isSelected ? activeTint : inActiveTint

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        guard let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig) else {
            return UIImage()
        }
        symbolSize = symbol.size
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .foregroundColor: color
        ]
        textSize = text.size(withAttributes: textAttributes)
        
        let spacing: CGFloat = 3.0
        let imageSize = CGSize(
            width: max(symbol.size.width, textSize.width) + 16,
            height: symbol.size.height + spacing + textSize.height
        )
        
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        return renderer.image { ctx in
            let symbolX = (imageSize.width - symbol.size.width) / 2
            if !isSelected {
                symbol.withTintColor(color).draw(at: CGPoint(x: symbolX, y: 0))
            }
            
            let textX = (imageSize.width - textSize.width) / 2
            let textY = symbol.size.height + spacing
            text.draw(at: CGPoint(x: textX, y: textY), withAttributes: textAttributes)
        }
    }
}

class AnimationTabLayerView: UIView {
    private let allTabs = CustomTab.allCases
    private var tabViews: [UIView] = []
    private let symbolSize: CGSize
    
    init(symbolSize: CGSize) {
        self.symbolSize = symbolSize
        super.init(frame: .zero)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.isUserInteractionEnabled = false
        for (_, tab) in allTabs.enumerated() {
            let image = UIImageView(image: UIImage(systemName: tab.selectedSymbol))
            image.tintColor = .label
            image.contentMode = .scaleAspectFit
            image.translatesAutoresizingMaskIntoConstraints = false
            image.widthAnchor.constraint(equalToConstant: symbolSize.width).isActive = true
            image.heightAnchor.constraint(equalToConstant: symbolSize.height).isActive = true
            image.alpha = 0
            tabViews.append(image)
        }
        
        let hStack = UIStackView(arrangedSubviews: tabViews)
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillEqually
        hStack.spacing = 0
        
        addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func activeTab(at index: Int) {
        for (i, view) in self.tabViews.enumerated() {
            if i == index {
                view.alpha = 1.0
                
                let totalDuration = 0.6
                UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: [.calculationModeLinear]) {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).rotated(by: -CGFloat.pi / 18)
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4) {
                        view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).rotated(by: CGFloat.pi / 18)
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                        view.transform = .identity
                    }
                }
                
            } else {
                view.alpha = 0.0
            }
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
