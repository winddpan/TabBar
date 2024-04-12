//
//  MIT License
//
//  Copyright (c) 2021 Tamerlan Satualdypov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI

/**
 `TabBar` – highly customizable tab bar for your SwiftUI application.

 By using this component you will be able to add a view that
 switches between multiple child views using interactive user
 interface elements.

 `TabBar` can be easily customized. You have to conform
 to `TabBarStyle` and `TabItemStyle` to customize bar
 and item respectively. To apply customization you have to inject
 them to tab bar using `tabBar(style:)` for bar
 and `tabItem(style:)` for item.

 Usage:

 ```
 TabBar(selection: $selection) { }
    .tabBar(style: CustomTabBarStyle())
    .tabItem(style: CustomTabItemStyle())
 ```
 */
public struct TabBar<TabItem: Tabbable, Content: View>: View {
    @StateObject private var selectedItem: TabBarSelection<TabItem>
    private let content: () -> Content

    private var tabItemStyle: AnyTabItemStyle = .init(itemStyle: DefaultTabItemStyle())
    private var tabBarStyle: AnyTabBarStyle = .init(barStyle: DefaultTabBarStyle())

    /**
     Creates a tab bar components with given
     bindings to selection and visibility.

     Provided views in the `content` closure
     will be recognized as a tab bar item only
     if they have `tabItem(for:)` applied on them.
     */
    public init(
        selection: Binding<TabItem>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _selectedItem = .init(wrappedValue: .init(selection: selection))
        self.content = content
    }

    public var body: some View {
        let _ = {
            selectedItem.tabItemStyle = tabItemStyle
            selectedItem.tabBarStyle = tabBarStyle
        }()

        ZStack {
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environmentObject(selectedItem)
        }
        .onPreferenceChange(TabBarPreferenceKey.self) { value in
            if value != selectedItem.items {
                selectedItem.items = value
            }
        }
    }
}

public extension TabBar {
    /**
     A function that is used to apply tab item's style on `TabBar`.

     By passing the instance of object that conforms to `TabItemStyle`
     protocol `TabBar` will use this style for its items.

     - Parameters:
        - style: Item style that should be applied to `TabBar`.

     - Returns:
        `TabBar` with applied item style.
     */
    func tabItem(style: some TabItemStyle) -> Self {
        var _self = self
        _self.tabItemStyle = .init(itemStyle: style)
        return _self
    }

    /**
     A function that is used to apply tab bar's style on `TabBar`.

     By passing the instance of object that conforms to `TabBarStyle`
     protocol `TabBar` will apply this style to its bar.

     - Parameters:
        - style: Bar style that should be applied to `TabBar`.

     - Returns:
        `TabBar` with applied bar style.
     */
    func tabBar(style: some TabBarStyle) -> Self {
        var _self = self
        _self.tabBarStyle = .init(barStyle: style)
        return _self
    }
}
