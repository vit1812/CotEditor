//
//  FormatSettingsView.swift
//
//  CotEditor
//  https://coteditor.com
//
//  Created by 1024jp on 2023-11-29.
//
//  ---------------------------------------------------------------------------
//
//  © 2023-2024 1024jp
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SwiftUI

struct FormatSettingsView: View {
    
    @AppStorage(.lineEndCharCode) private var lineEnding
    
    @AppStorage(.encoding) private var encoding
    @AppStorage(.saveUTF8BOM) private var saveUTF8BOM
    @AppStorage(.referToEncodingTag) private var referToEncodingTag
    
    @AppStorage(.syntax) private var syntax
    
    @StateObject private var encodingManager: EncodingManager = .shared
    @StateObject private var syntaxManager: SyntaxManager = .shared
    
    
    private var fileEncoding: Binding<FileEncoding> {
        
        Binding(
            get: {
                FileEncoding(encoding: String.Encoding(rawValue: UInt(self.encoding)),
                             withUTF8BOM: self.saveUTF8BOM)
            },
            set: {
                self.encoding = Int($0.encoding.rawValue)
                self.saveUTF8BOM = $0.withUTF8BOM
            })
    }
    
    @State private var isEncodingListPresented = false
    
    
    var body: some View {
        
        Grid(alignment: .leadingFirstTextBaseline) {
            GridRow {
                Text("Default line endings:", tableName: "FormatSettings")
                    .gridColumnAlignment(.trailing)
                
                Picker(selection: $lineEnding) {
                    ForEach(LineEnding.allCases.filter(\.isBasic), id: \.self) {
                        Text("\($0.longName) (\($0.name))")
                            .tag($0.index)
                    }
                } label: {
                    EmptyView()
                }
                .fixedSize()
            }
            
            Divider()
                .padding(.vertical, 8)
            
            GridRow {
                Text("Default encoding:", tableName: "FormatSettings")
                    .gridColumnAlignment(.trailing)
                
                Picker(selection: fileEncoding) {
                    ForEach(Array(self.encodingManager.fileEncodings.enumerated()), id: \.offset) { (_, encoding) in
                        if let encoding {
                            Text(encoding.localizedName)
                                .tag(encoding)
                        } else {
                            Divider()
                        }
                    }
                } label: {
                    EmptyView()
                }
                .frame(maxWidth: 260)
            }
            
            GridRow {
                Text("Priority of encodings:", tableName: "FormatSettings")
                    .gridColumnAlignment(.trailing)
                
                VStack {
                    VStack(alignment: .leading) {
                        Button(String(localized: "Edit List…", table: "FormatSettings")) {
                            self.isEncodingListPresented.toggle()
                        }
                        .sheet(isPresented: $isEncodingListPresented, content: {
                            EncodingListView()
                        })
                        
                        Toggle(String(localized: "Refer to encoding declaration in document", table: "FormatSettings"), isOn: $referToEncodingTag)
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 8)
            
            GridRow {
                Text("Default syntax:", tableName: "FormatSettings")
                    .gridColumnAlignment(.trailing)
                
                Picker(selection: $syntax) {
                    Text("None").tag("None")
                    Divider()
                    ForEach(self.syntaxManager.settingNames, id: \.self) {
                        Text($0).tag($0)
                    }
                } label: {
                    EmptyView()
                }
                .frame(maxWidth: 260)
            }
            
            GridRow(alignment: .top) {
                Text("Available syntaxes:", tableName: "FormatSettings")
                    .gridColumnAlignment(.trailing)
                
                SyntaxListView()
                    .background()
                    .border(.separator)
                    .frame(width: 260)
            }
            
            HStack {
                Spacer()
                HelpButton(anchor: "settings_format")
            }
        }
        .scenePadding()
        .frame(width: 600)
    }
}


private struct SyntaxListView: NSViewControllerRepresentable {
    
    typealias NSViewControllerType = NSViewController
    
    
    func makeNSViewController(context: Context) -> NSViewController {
        
        NSStoryboard(name: "SyntaxListView", bundle: nil).instantiateInitialController()!
    }
    
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        
    }
}



// MARK: - Preview

#Preview {
    FormatSettingsView()
}
