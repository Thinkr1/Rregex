//
//  ContentView.swift
//  Rregex
//
//  Created by Pierre-Louis ML on 04/01/2025.
//

import SwiftUI

struct CheatsheetItem: Identifiable, Equatable, Hashable {
    let id: Int
    let symbol: String
    let desc: String
    let example: String
}

struct HUDVisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .menu
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = .menu
        nsView.blendingMode = .behindWindow
        nsView.state = .active
    }
}

struct SavedRegex: Codable, Identifiable {
    let id: UUID
    let regex: String
    let description: String
}

struct ContentView: View {
    @State private var regex: String = ""
    @State private var textEditorContent: String = "This is some text, you can edit is as you need to test your regex.\n10 km SSW of Idyllwild, CA\n9 km WSW of Willow, Alaska\n2 km E of Magas Arriba, Puerto Rico\n267 km SSE of Alo, Wallis and Futuna"
    @State private var attributedText: NSAttributedString = NSAttributedString(string: "This is some text, you can edit is as you need to test your regex.\n10 km SSW of Idyllwild, CA\n9 km WSW of Willow, Alaska\n2 km E of Magas Arriba, Puerto Rico\n267 km SSE of Alo, Wallis and Futuna", attributes: [.foregroundColor: NSColor.labelColor, .font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)])
    @State private var isCaseInsensitive: Bool = false
    @State private var isGlobal: Bool = true
    @State private var isMultiline: Bool = false
    @State private var isUnicode: Bool = false
    @State private var savedRegex: [SavedRegex] = []
    @AppStorage("savedRegexData") private var savedRegexData: Data = Data()
    @State private var cheatsheet: [CheatsheetItem] = [
        CheatsheetItem(id: 1, symbol: ".", desc: "Any character except a newline", example: "`a.c` matches `abc`, `aec`"),
        CheatsheetItem(id: 2, symbol: "\\w \\d \\s", desc: "A word character (\\w),\ndigit (\\d),\nor whitespace (\\s)", example: "`A\\dC` matches `A1C`, `A2C`"),
        CheatsheetItem(id: 3, symbol: "\\W \\D \\S", desc: "A non-word character (\\W),\nnon-digit (\\D),\nor non-whitespace (\\S)", example: "`A\\DC` matches `A%C`, `A#C`"),
        CheatsheetItem(id: 4, symbol: "[abc]", desc: "a, b, or c", example: "`[abc]d` matches `ad`, `bd`, `cd`"),
        CheatsheetItem(id: 5, symbol: "[^abc]", desc: "Not a, b, or c", example: "`[^abc]d` matches `zd`, `yd`"),
        CheatsheetItem(id: 6, symbol: "[a-g]", desc: "Any character in the range a through g", example: "`[a-g]z` matches `az`, `fz`"),
        CheatsheetItem(id: 7, symbol: "[a-z]", desc: "Any lowercase letter a through z", example: "`[a-z]x` matches `ax`, `zx`"),
        CheatsheetItem(id: 8, symbol: "[A-Z]", desc: "Any uppercase letter A through Z", example: "`[A-Z]y` matches `Ay`, `Zy`"),
        CheatsheetItem(id: 9, symbol: "[0-9]", desc: "Any digit from 0 to 9", example: "`[0-9]x` matches `3x`, `7x`"),
        CheatsheetItem(id: 10, symbol: "[a-zA-Z]", desc: "Any letter, lowercase or uppercase", example: "`[a-zA-Z]1` matches `A1`, `z1`"),
        CheatsheetItem(id: 11, symbol: "[a-zA-Z0-9]", desc: "Any letter or digit", example: "`[a-zA-Z0-9]_` matches `a_`, `1_`, `A_`"),
        CheatsheetItem(id: 12, symbol: "[\\s\\S]", desc: "Matches any character, including line breaks", example: "`[\\s\\S]` matches `The quick brown fox jumps over the lazy dog. Matches this too`"),
        CheatsheetItem(id: 13, symbol: "\\t", desc: "Matches a tab character", example: "`\\t` matches this tab character: '`    `'"),
        CheatsheetItem(id: 14, symbol: "\\n", desc: "Matches a line feed character", example: "`\\n` matches a line feed character (no example available)"),
        CheatsheetItem(id: 15, symbol: "^", desc: "Anchors the regex to the start of the string", example: "`^The` matches `The` at the start"),
        CheatsheetItem(id: 16, symbol: "$", desc: "Anchors the regex to the end of the string", example: "`end$` matches `end` at the end"),
        CheatsheetItem(id: 17, symbol: "\\b", desc: "A word boundary\n(start or end of a word)", example: "`\\bcat\\b` matches `cat`, not `scatter`"),
        CheatsheetItem(id: 18, symbol: "\\B", desc: "A position that is not a word boundary", example: "`\\Bcat\\B` matches `scatter`, not `cat`"),
        CheatsheetItem(id: 19, symbol: "|", desc: "Acts as a logical OR", example: "`cat|dog` matches `cat` or `dog`"),
        CheatsheetItem(id: 20, symbol: "()", desc: "Capturing group", example: "`(ab)+` matches `ab`, `abab`"),
        CheatsheetItem(id: 21, symbol: "(?<name>)", desc: "Named capturing group", example: "`(?<digit>\\d)` matches a digit"),
        CheatsheetItem(id: 22, symbol: "(?:)", desc: "Non-capturing group", example: "`(?:ab)+` matches `ab`, `abab`"),
        CheatsheetItem(id: 23, symbol: "(?=)", desc: "Positive lookahead\n(asserts that a pattern follows)", example: "`a(?=b)` matches `a` if followed by `b`"),
        CheatsheetItem(id: 24, symbol: "(?!)", desc: "Negative lookahead\n(asserts that a pattern does not follow)", example: "`a(?!b)` matches `a` not followed by `b`"),
        CheatsheetItem(id: 25, symbol: "(?>", desc: "Atomic group, prevents backtracking inside the group", example: "`(?>a*)b` matches `aaab`, not `aaaab`"),
        CheatsheetItem(id: 26, symbol: "(?<=)", desc: "Positive lookbehind\n(asserts that a pattern precedes)", example: "`(?<=a)b` matches `b` if preceded by `a`"),
        CheatsheetItem(id: 27, symbol: "(?<!)", desc: "Negative lookbehind\n(asserts that a pattern does not precede)", example: "`(?<!a)b` matches `b` not preceded by `a`"),
        CheatsheetItem(id: 28, symbol: "?", desc: "0 or 1 occurrences\nof the preceding element", example: "`a?b` matches `b`, `ab`"),
        CheatsheetItem(id: 29, symbol: "*", desc: "0 or more occurrences\nof the preceding element", example: "`a*b` matches `b`, `ab`, `aab`"),
        CheatsheetItem(id: 30, symbol: "+", desc: "1 or more occurrences\nof the preceding element", example: "`a+b` matches `ab`, `aab`"),
        CheatsheetItem(id: 31, symbol: "{n}", desc: "Exactly n occurrences\nof the preceding element", example: "`a{2}b` matches `aab`"),
        CheatsheetItem(id: 32, symbol: "{n,}", desc: "At least n occurrences\nof the preceding element", example: "`a{2,}b` matches `aab`, `aaab`"),
        CheatsheetItem(id: 33, symbol: "{n,m}", desc: "Between n and m occurrences\nof the preceding element", example: "`a{2,3}b` matches `aab`, `aaab`"),
        CheatsheetItem(id: 34, symbol: "?", desc: "Lazy quantifier\n(matches the shortest possible string)", example: "`a+?` matches `a`, in `aaa`"),
        CheatsheetItem(id: 35, symbol: "\\A", desc: "Anchors the regex to the start\nof the string (alternative to ^)", example: "`\\AThe` matches `The` at the start"),
        CheatsheetItem(id: 36, symbol: "\\Z", desc: "Anchors the regex to the end\nof the string (alternative to $)", example: "`end\\Z` matches `end` at the end"),
        CheatsheetItem(id: 37, symbol: "\\G", desc: "Matches the end of the previous match", example: "`(\\Gfoo)` matches subsequent `foo`"),
        CheatsheetItem(id: 38, symbol: "\\p{L}", desc: "Any Unicode letter\n(requires the 'u' flag)", example: "`\\p{L}` matches `α`, `A`"),
        CheatsheetItem(id: 39, symbol: "\\p{N}", desc: "Any Unicode number\n(requires the 'u' flag)", example: "`\\p{N}` matches `1`, `١`"),
        CheatsheetItem(id: 40, symbol: "\\P{L}", desc: "Any character that is\nnot a Unicode letter\n(requires the 'u' flag)", example: "`\\P{L}` matches `1`, `!`"),
        CheatsheetItem(id: 41, symbol: "\\P{N}", desc: "Any character that is\nnot a Unicode number\n(requires the 'u' flag)", example: "`\\P{N}` matches `A`, `!`"),
        CheatsheetItem(id: 42, symbol: "[[:alpha:]]", desc: "Any alphabetic character (POSIX)", example: "`[[:alpha:]]` matches `a`, `A`"),
        CheatsheetItem(id: 43, symbol: "[[:digit:]]", desc: "Any digit (POSIX)", example: "`[[:digit:]]` matches `1`, `2`"),
        CheatsheetItem(id: 44, symbol: "[[:alnum:]]", desc: "Any alphanumeric character (POSIX)", example: "`[[:alnum:]]` matches `a`, `1`"),
        CheatsheetItem(id: 45, symbol: "[[:space:]]", desc: "Any whitespace character (or tab, or form feed) (POSIX)", example: "`[[:space:]]` matches ` ` (space), `  ` (tab)"),
        CheatsheetItem(id: 46, symbol: "[[:punct:]]", desc: "Any punctuation character (POSIX)", example: "`[[:punct:]]` matches `!`, `,`"),
        CheatsheetItem(id: 47, symbol: "[[:upper:]]", desc: "Any uppercase letter (POSIX)", example: "`[[:upper:]]` matches `A`, `Z`"),
        CheatsheetItem(id: 48, symbol: "[[:lower:]]", desc: "Any lowercase letter (POSIX)", example: "`[[:lower:]]` matches `a`, `z`"),
        CheatsheetItem(id: 49, symbol: "[[:blank:]]", desc: "Space or tab character (POSIX)", example: "`[[:blank:]]` matches ` ` (space), `    ` (tab)"),
        CheatsheetItem(id: 50, symbol: "[[:xdigit:]]", desc: "Characters that are hexadecimal digits (POSIX)", example: "`[[:xdigit:]]` matches `47bb03a0`, `c369324edc`")
    ]
    @State private var selectedItem: CheatsheetItem? = nil
    @State private var showPopover: Bool = false
    @State private var rtr: SavedRegex?
    @State private var showDeleteConfirm: Bool = false
    @State private var showSavePopover: Bool = false
    @State private var saveRegexDescription: String = ""
    
    var body: some View {
        NavigationSplitView {
            listView()
        } detail : {
            detailView()
        }

        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: loadSavedRegex)
        .alert(isPresented: $showDeleteConfirm) {
            Alert(
                title: Text("Delete Saved Regex"),
                message: Text("Are you sure you want to delete this regex?"),
                primaryButton: .destructive(Text("Delete"), action: confirmRemove), // It seems that having a button both default and destructive is not supported
                secondaryButton: .cancel {rtr=nil}
            )
        }
    }
    
    @ViewBuilder
    private func listView() -> some View {
        ZStack {
            HUDVisualEffectView().edgesIgnoringSafeArea(.all)
            List {
                savedRegexSection()
                cheatsheetSection()
            }
            .listStyle(.sidebar)
            .scrollIndicators(.never)
        }
    }
    
    @ViewBuilder
    private func savedRegexSection() -> some View {
        Section("Saved Regex") {
//            LazyVStack(alignment: .leading, spacing:10) {
                ForEach(savedRegex) { r in
                    VStack(alignment: .leading, spacing: 10){
                        Button(action: {regex=r.regex}) {
                            VStack(alignment: .leading) {
                                Text(r.regex)
                                    .font(.system(.subheadline, design: .monospaced)).bold().foregroundStyle(.primary)
                                Text(r.description)
                                    .font(.system(.caption, design: .monospaced)).foregroundStyle(.secondary)
                            }
                        }
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                removeSavedRegex(r)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        if savedRegex.count>1 && r.id != savedRegex.last?.id {Divider()}
                    }
                   
                }
//            }
        }
    }
    
    @ViewBuilder
    private func cheatsheetSection() -> some View {
        Section("Cheatsheet") {
            ForEach(cheatsheet, id: \.self) { e in
                Button(action: {
                    selectedItem = e
                    showPopover=true
                }) {
                    HStack {
                        Text(e.symbol)
                            .font(.system(.body, design: .monospaced))
                        Spacer()
                        Image(systemName: "info.bubble")
                            .font(.system(.body))
                    }
                    .frame(maxWidth: .infinity)
                    .scrollContentBackground(.hidden)
                }
                .popover(isPresented: Binding(get: {
                    showPopover && selectedItem==e
                }, set: {
                    if !$0 {showPopover=false}
                })) {
                    if let e = selectedItem {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Symbol:")
                                .font(.headline)
                            Text(e.symbol)
                                .font(.system(.body, design: .monospaced))
                                .bold()
                            Text("Description:")
                                .font(.headline)
                            Text(e.desc)
                                .font(.body)
                            Text("Example: ")
                                .font(.headline)
                            formatStringBackticks(e.example)
                        }
                        .padding(20)
                        .frame(minWidth: 175)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .scrollIndicators(.never)
    }
    
    @ViewBuilder
    private func detailView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Rregex")
                .font(.system(.largeTitle, design: .rounded)) // or monospaced?
                .bold()
                .padding()
                .padding(.bottom, -15)
            HStack {
                TextField("Enter your regex...", text: $regex, onCommit: applyRegex)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(.body, design: .monospaced))
                    .onChange(of: regex, initial: false) {
                        applyRegex()
                    }
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.gray.opacity(0.6), lineWidth:1)
                    )
                Menu {
                    Toggle("Case insensitive (i)", isOn: $isCaseInsensitive)
                    Toggle("Global (g)", isOn: $isGlobal)
                    Toggle("Multiline (m)", isOn: $isMultiline)
                    Toggle("Unicode (u)", isOn: $isUnicode)
                } label: {
                    Image(systemName: "flag")
                        .font(.title2)
                }.frame(maxWidth: 50).menuStyle(.automatic)
                    .buttonStyle(.borderless)
                    .menuStyle(.automatic)
                    .onChange(of: [isCaseInsensitive, isGlobal, isMultiline, isUnicode]) {
                        applyRegex()
                    }
                Button(action: {showSavePopover=true}) {
                    Image(systemName: "bookmark")
                }.buttonStyle(.borderless).frame(maxWidth: 15).foregroundStyle(.primary)
                    .popover(isPresented: $showSavePopover) {
                        VStack {
                            Text("Save a regex").font(.title2).bold()
                            HStack {
                                TextField("Enter short description...", text: $saveRegexDescription)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.vertical)
                                    .onSubmit{
                                        saveRegex()
                                        showSavePopover=false
                                    }
                                Button("Save") {
                                    saveRegex()
                                    showSavePopover=false
                                }.buttonStyle(BorderedProminentButtonStyle()).padding(.vertical)
                            }
                        }.padding()
                    }
            }.padding()
            AttributedTextView(attributedText: $attributedText, onTextChange: { new in
                textEditorContent = new
            })
            .frame(maxHeight: .infinity)
            .padding(.horizontal)
            Spacer()
        }
    }
    
    private func formatStringBackticks(_ e: String) -> Text {
        let parts=e.split(separator: "`", omittingEmptySubsequences: false)
        
        var formatted = Text("")
        for (i,p) in parts.enumerated() {
            if i%2==0 {
                formatted = formatted + Text(p)
                    .font(.body)
            } else {
                formatted = formatted + Text(p)
                    .font(.system(.body, design: .monospaced))
                    .bold()
            }
        }
        return formatted
    }
    
    private func loadSavedRegex() {
        if let loaded = try? JSONDecoder().decode([SavedRegex].self, from: savedRegexData) {
            savedRegex = loaded
        }
    }

    private func saveRegex() {
        let newSavedRegex = SavedRegex(id: UUID(), regex: regex, description: saveRegexDescription)
        savedRegex.append(newSavedRegex)
        if let encoded = try? JSONEncoder().encode(savedRegex) {
            savedRegexData = encoded
        }
        saveRegexDescription = ""
    }

    private func removeSavedRegex(_ r: SavedRegex) {
        rtr = r
        showDeleteConfirm = true
    }

    private func confirmRemove() {
        guard let r = rtr, let i = savedRegex.firstIndex(where: { $0.id == r.id }) else { return }
        savedRegex.remove(at: i)
        if let encoded = try? JSONEncoder().encode(savedRegex) {
            savedRegexData = encoded
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
                    attributedString.addAttribute(.backgroundColor, value: NSColor(calibratedRed: 70/255.0, green: 137/255.0, blue: 199/255.0, alpha: 0.8), range: match.range)
                }
            } else {
                if let match = regex.firstMatch(in: textEditorContent, range:NSRange(location: 0, length: nsString.length)) {
                    print(match)
                    attributedString.addAttributes([
                        .foregroundColor: NSColor.controlTextColor,
                        .font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular),
                        .backgroundColor: NSColor.clear
                    ], range: NSRange(location: 0, length: attributedString.length))
                    attributedString.addAttribute(.backgroundColor, value:NSColor(calibratedRed: 70/255.0, green: 137/255.0, blue: 199/255.0, alpha: 0.8), range:match.range)
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
