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
import TabBar

struct ContentView: View {
    private enum Item: Int, Tabbable {
        case first = 0
        case second
        case third

        var icon: String {
            switch self {
            case .first: "house"
            case .second: "magnifyingglass"
            case .third: "person"
            }
        }

        var title: String {
            switch self {
            case .first: "First"
            case .second: "Second"
            case .third: "Third"
            }
        }
    }

    @State private var selection: Item = .first
    @State var count: Int = 0

    var body: some View {
        HStack {
            body1
            body2
        }
    }

    @ViewBuilder
    var body2: some View {
        TabView(selection: $selection) {
            NavigationStack {
                NavigationLink {
                    Text("123")
                        .navigationTitle("123")
                } label: {
                    Color.red.overlay {
                        Text("subview")
                    }
                    .navigationTitle("root")
                }
            }
            .tabItem {
                Image(systemName: Item.first.icon)
                Text(Item.first.title)
            }

            NavigationStack {
                TextWrapper()
            }
            .tabItem {
                Image(systemName: Item.second.icon)
                Text(Item.second.title)
            }

            NavigationStack {
                TextWrapper()
            }
            .tabItem {
                Image(systemName: Item.third.icon)
                Text(Item.third.title)
            }
        }
    }

    @ViewBuilder
    var body1: some View {
        TabBar(selection: $selection) {
            NavigationLink {
                Text("123")
                    .navigationTitle("123")
            } label: {
                Color.red.overlay {
                    Text("subview")
                }
                .navigationTitle("root")
//                .toolbar {
//                    ToolbarItemGroup(placement: .bottomBar) {
//                        HStack {
//                            Button(action: {}, label: {
//                                Text("Select All")
//                            })
//
//                            Spacer()
//                            Button(action: {}, label: {
//                                Text("Select All")
//                            })
//                        }\
//                    }
//                }
            }
            .tabItem(for: Item.first)

            TextWrapper()
                .tabItem(for: Item.second)

            TextWrapper()
                .tabItem(for: Item.third)
        }
//        .tabBar(style: CustomTabBarStyle())
//        .tabItem(style: CustomTabItemStyle())
        .onChange(of: selection) { newValue in
            print("selection changed:", newValue)
        }
    }
}

struct TextWrapper: View {
    @State var string: String = UUID().uuidString

    var body: some View {
        Text(string)
            .onTapGesture {
                string = UUID().uuidString
            }
            .onAppear(perform: {
                print("onAppear:", string)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
