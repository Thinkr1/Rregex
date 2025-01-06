//
//  ContentView.swift
//  Rregex
//
//  Created by Pierre-Louis ML on 04/01/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var regex: String = ""
    @State private var textEditorContent: String = "10 km SSW of Idyllwild, CA\n9 km WSW of Willow, Alaska\n2 km E of Magas Arriba, Puerto Rico\n267 km SSE of Alo, Wallis and Futuna"
    @State private var attributedText: NSAttributedString = NSAttributedString(string: "10 km SSW of Idyllwild, CA\n9 km WSW of Willow, Alaska\n2 km E of Magas Arriba, Puerto Rico\n267 km SSE of Alo, Wallis and Futuna", attributes: [.foregroundColor: NSColor.labelColor, .font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)])
    @State private var isCaseInsensitive: Bool = false
    @State private var isGlobal: Bool = true
    @State private var isMultiline: Bool = false
    @State private var isUnicode: Bool = false
    @State private var savedRegex: [String] = []
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(savedRegex, id: \.self) { r in
                    Text(r)
                        .font(.system(.body, design: .monospaced))
                        .onTapGesture {regex=r}
                }
            }
            .navigationTitle("Sidebar")
        } detail : {
            VStack(alignment: .leading, spacing: 10) {
                Text("Rregex")
                    .font(.system(.largeTitle))//, design: .monospaced))
                    .bold()
                    .padding()
                    .padding(.bottom, -15)
                HStack {
                    TextField("Enter your regex...", text: $regex, onCommit: applyRegex)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(.body, design: .monospaced))
                    Menu {
                        Toggle("Case insensitive (i)", isOn: $isCaseInsensitive)
                        Toggle("Global (g)", isOn: $isGlobal)
                        Toggle("Multiline (m)", isOn: $isMultiline)
                        Toggle("Unicode (u)", isOn: $isUnicode)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                    }.frame(maxWidth: 50).menuStyle(.automatic)
                    Button(action: {
                        savedRegex.append(regex)
                    }) {
                        Image(systemName: "bookmark")
                    }.buttonStyle(.borderless)
                }.padding()
                AttributedTextView(attributedText: $attributedText, onTextChange: { new in
                    textEditorContent = new
                })
                .frame(maxHeight: 300)
                .padding(.horizontal)
                Spacer()
            }
        }
    }
    
    private func applyRegex() {
        do {
            var options: NSRegularExpression.Options = []
            if isCaseInsensitive {options.insert(.caseInsensitive)}
            if isMultiline {options.insert(.anchorsMatchLines)}
            if isUnicode {options.insert(.useUnicodeWordBoundaries)}
            
            let attributedString = NSMutableAttributedString(string: textEditorContent)
            let regex = try NSRegularExpression(pattern: self.regex, options: options)
            let nsString = textEditorContent as NSString
            if isGlobal {
                let matches = regex.matches(in: textEditorContent, range:NSRange(location: 0, length: nsString.length))
                print(matches)
                attributedString.addAttributes([
                    .foregroundColor: NSColor.controlTextColor,
                    .font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular),
                    .backgroundColor: NSColor.clear
                ], range: NSRange(location: 0, length: attributedString.length))

                for match in matches {
                    attributedString.addAttribute(.backgroundColor, value: NSColor.blue, range: match.range)
                }
            } else {
                if let match = regex.firstMatch(in: textEditorContent, range:NSRange(location: 0, length: nsString.length)) {
                    print(match)
                    attributedString.addAttributes([
                        .foregroundColor: NSColor.controlTextColor,
                        .font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular),
                        .backgroundColor: NSColor.clear
                    ], range: NSRange(location: 0, length: attributedString.length))
                    attributedString.addAttribute(.backgroundColor, value:NSColor.blue, range:match.range)
                }
            }

            self.attributedText = attributedString
        } catch {
            self.attributedText = NSAttributedString(string: textEditorContent)
        }
    }
}

struct AttributedTextView: NSViewRepresentable {
    @Binding var attributedText: NSAttributedString
    var onTextChange: (String) -> Void
    
    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.textColor = NSColor.controlTextColor
        textView.font = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.textContainerInset = NSSize(width:5, height:5)
        return textView
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        if nsView.attributedString() != attributedText {
            nsView.textStorage?.setAttributedString(attributedText)
            nsView.textColor = NSColor.controlTextColor
            nsView.font = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
            nsView.backgroundColor = .clear
            nsView.isEditable = true
            nsView.isSelectable = true
            nsView.delegate = context.coordinator
            nsView.textContainerInset = NSSize(width:5, height:5)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: AttributedTextView
        
        init(_ parent: AttributedTextView) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? NSTextView {
                let new = textView.string
                parent.onTextChange(new)
                
                let attributedString = NSMutableAttributedString(string: new)
                attributedString.addAttributes([
                    .foregroundColor: NSColor.controlTextColor,
                    .font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular),
                    .backgroundColor: NSColor.clear
                ], range: NSRange(location: 0, length: attributedString.length))
            }
        }
    }
}

#Preview {
    ContentView()
}
