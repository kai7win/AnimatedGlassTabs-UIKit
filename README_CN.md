# AnimatedGlassTabs-UIKit
一個支援 iOS 26+ 的 UIKit 自訂 TabBar，具有液態玻璃效果和動畫圖示。

[English README](README.md) | [SwiftUI 版本](https://github.com/kai7win/AnimatedGlassTabs)

## 示範
![示範 GIF](demo.gif)

## 特色
- 🌟 **液態玻璃效果**: 使用 UISegmentedControl 實現精美的液態玻璃擬態設計
- 🎨 **動畫圖示**: 使用 UIView 關鍵幀動畫實現流暢的圖示縮放和旋轉效果
- ⚡ **UIKit 原生**: 完全使用 UIKit 和程式化 UI 建構
- 🔧 **可自訂**: 輕鬆自訂顏色、動畫和標籤項目
- 📱 **iOS 26+ 相容**: 使用最新的 iOS 功能和設計模式

## 安裝

### 需求
- iOS 26.0+
- Swift 5.9+
- Xcode 26.1+

### 複製儲存庫
```bash
git clone https://github.com/yourusername/AnimatedGlassTabs-UIKit.git
cd AnimatedGlassTabs-UIKit
```

## 使用方式

### 基本實作

```swift
import UIKit

class ViewController: UIViewController {
    let customTabBar = CustomTabBarView()
    
    private let homeVC = HomeViewController()
    private let notificationsVC = NotificationsViewController()
    private let settingsVC = SettingsVieController()
    
    private var currentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTabBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        customTabBar.onTabSelected = { [weak self] tab in
            self?.updateView(for: tab)
        }
        
        updateView(for: customTabBar.activeTab)
    }
}
```

### 自訂標籤定義

```swift
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
}
```

### 自訂設定

```swift
// 自訂標籤列顏色
customTabBar.activeTint = .label
customTabBar.inActiveTint = .secondaryLabel
customTabBar.activeTab = .home

// 處理標籤選擇
customTabBar.onTabSelected = { tab in
    print("已選擇標籤: \(tab.rawValue)")
}
```

## 專案結構

```
AnimatedGlassTabs-UIKit/
├── AppDelegate.swift                    # 應用程式生命週期
├── SceneDelegate.swift                  # 場景生命週期
├── AnimatedTabBar/
│   └── CustomTabBarView.swift          # 具有玻璃效果和動畫的自訂標籤列
├── ViewControllers/
│   ├── ViewController.swift            # 主容器視圖控制器
│   ├── HomeViewController.swift        # 首頁
│   ├── NotificationsViewController.swift # 通知頁面
│   └── SettingsVieController.swift     # 設定頁面
├── Base.lproj/
│   ├── Main.storyboard                 # 主要 Storyboard
│   └── LaunchScreen.storyboard         # 啟動畫面
└── Assets.xcassets/                    # 應用程式資源和圖示
```

## 核心元件

### CustomTabBarView
一個包裝 `UISegmentedControl` 的自訂 UIView，提供：
- 使用 UISegmentedControl 的玻璃效果樣式
- 使用 SF Symbols 的自訂標籤項目渲染
- 支援回調的流暢選擇動畫
- 動態生成標籤圖片

### AnimationTabLayerView
處理圖示動畫的覆蓋層視圖：
- 縮放和旋轉動畫
- 關鍵幀動畫序列
- 標籤之間的流暢過渡

### 動畫系統
- **關鍵幀動畫**: 使用 `UIView.animateKeyframes` 實現複雜的多階段動畫
- **縮放動畫**: 圖示從 0.8 倍縮放到 1.2 倍，最後回到 1.0 倍
- **旋轉動畫**: 結合縮放的旋轉效果，提供動態回饋
- **持續時間**: 總動畫持續時間為 0.6 秒，分為三個不同階段

## 運作原理

1. **標籤選擇**: 當點擊標籤時，`UISegmentedControl` 觸發選擇回調
2. **視圖控制器切換**: 主 `ViewController` 移除當前的子視圖控制器並添加新的
3. **動畫觸發**: `AnimationTabLayerView` 對所選標籤圖示執行關鍵幀動畫
4. **圖片更新**: 使用適當的顏色和符號重新生成標籤圖片
