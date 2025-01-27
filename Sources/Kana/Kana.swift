import Foundation

public struct Kana: Equatable, Hashable {

    // MARK: - Properties

    public let romaji: String?
    public let katakana: String?
    public let hiragana: String?

    public var isInvalid: Bool {
        if romaji == nil || katakana == nil || hiragana == nil {
            return true
        }

        return false
    }

    public var isValid: Bool {
        return !self.isInvalid
    }

    // MARK: - Enums

    public enum KanaType {
        case hiragana
        case katakana
        case romaji
    }

    public enum KanaError: Error {
        case characterNotFound
    }


    // MARK: - Constructors
    
    public init(romaji: String) {
        if let hiragana = Kana.toHiragana(of: romaji, in: .romaji) {
            self.romaji = romaji
            self.hiragana = hiragana
            self.katakana = Kana.toKatakana(of: romaji, in: .romaji)
        } else {
            self.romaji = nil
            self.hiragana = nil
            self.katakana = nil
        }
    }

    public init(katakana: String) {
        let romaji = Kana.toRomaji(of: katakana, in: .katakana) ?? ""
        self.init(romaji: romaji)
    }

    public init(hiragana: String) {
        let romaji = Kana.toRomaji(of: hiragana, in: .hiragana) ?? ""
        self.init(romaji: romaji)
    }


    // MARK: - Static methods and properties

    static let romajiChart: [[String]] = [
        ["a", "ka", "ga", "sa", "za", "ta", "da", "na", "ha", "ba", "pa", "ma", "ya", "ra", "wa", "n", "kya", "gya", "ja", "sha", "cha", "nya", "hya", "bya", "pya", "mya", "rya"],
        ["i", "ki", "gi", "shi", "ji", "chi", "ji", "ni", "hi", "bi", "pi", "mi", "", "ri", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["u", "vu", "ku", "gu", "su" , "zu", "tsu", "zu", "nu", "fu", "bu", "pu", "mu", "yu", "ru", "", "", "kyu", "gyu", "ju", "shu", "chu", "nyu", "hyu", "byu", "pyu", "myu", "ryu"],
        ["e", "ke", "ge", "se", "ze", "te", "de", "ne", "he", "be", "pe", "me", "", "re", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["o", "ko", "go", "so", "zo", "to", "do", "no", "ho", "bo", "po", "mo", "yo", "ro", "wo", "", "kyo", "gyo", "jo", "sho", "cho", "nyo", "hyo", "byo", "pyo", "myo", "ryo"],
    ]

    static let hiraganaChart: [[String]] = [
        ["あ", "か", "が", "さ", "ざ", "た", "だ", "な", "は", "ば", "ぱ", "ま", "や", "ら", "わ", "ん", "きゃ", "ぎゃ", "じゃ", "しゃ", "ちゃ", "にゃ", "ひゃ", "びゃ", "ぴゃ", "みゃ", "りゃ"],
        ["い", "き", "ぎ", "し", "じ", "ち", "ぢ", "に", "ひ", "び", "ぴ", "み", "", "り", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["う", "ゔ", "く", "ぐ", "す", "ず", "つ", "づ", "ぬ", "ふ", "ぶ", "ぷ", "む", "ゆ", "る", "", "", "きゅ", "ぎゅ", "じゅ", "しゅ", "ちゅ", "にゅ", "ひゅ", "びゅ", "ぴゅ", "みゅ", "りゅ"],
        ["え", "け", "げ", "せ", "ぜ", "て", "で", "ね", "へ", "べ", "ぺ", "め", "", "れ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["お", "こ", "ご", "そ", "ぞ", "と", "ど", "の", "ほ", "ぼ", "ぽ", "も", "よ", "ろ", "を", "", "きょ", "ぎょ", "じょ", "しょ", "ちょ", "にょ", "ひょ", "びょ", "ぴょ", "みょ", "りょ"],
    ]

    static let katakanaChart: [[String]] = [
        ["ア", "カ", "ガ", "サ", "ザ", "タ", "ダ", "ナ", "ハ", "バ", "パ", "マ", "ヤ", "ラ", "ワ", "ン", "キャ", "ギャ", "ジャ", "シャ", "チャ", "ニャ", "ヒャ", "ビャ", "ピャ", "ミャ", "リャ"],
        ["イ", "キ", "ギ", "シ", "ジ", "チ", "ヂ", "ニ", "ヒ", "ビ", "ピ", "ミ", "", "リ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["ウ", "ヴ", "ク", "グ", "ス", "ズ", "ツ", "ヅ", "ヌ", "フ", "ブ", "プ", "ム", "ユ", "ル", "", "", "キュ", "ギュ", "ジュ", "シュ", "チュ", "ニュ", "ヒュ", "ビュ", "ピュ", "ミュ", "リュ"],
        ["エ", "ケ", "ゲ", "セ", "ゼ", "テ", "デ", "ネ", "ヘ", "ベ", "ペ", "メ", "", "レ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["オ", "コ", "ゴ", "ソ", "ゾ", "ト", "ド", "ノ", "ホ", "ボ", "ポ", "モ", "ヨ", "ロ", "ヲ", "", "キョ", "ギョ", "ジョ", "ショ", "チョ", "ニョ", "ヒョ", "ビョ", "ピョ", "ミョ", "リョ"],
    ]

    static let smallCharsHiragana: [String] = ["ぁ", "ぃ", "ぅ", "ぇ", "ぉ"]
    static let smallCharsKatakana: [String] = ["ァ", "ィ", "ゥ", "ェ", "ォ"]
    static let smallCharsRomaji: [String] = ["a", "i", "u", "e", "o"]

    public static func getTable(with keys: [KanaColumns.Keys]) -> KanaTable {
        let columns: [Int] = keys.map { $0.rawValue }

        var kanaTable: [[Kana]] = []
        for i in 0..<romajiChart.count {
            kanaTable.append([])
            for j in columns {
                let romaji = romajiChart[i][j]
                let kana = Kana(romaji: romaji)
                kanaTable[i].append(kana)
            }
        }

        return KanaTable(values: kanaTable)
    }

    public static func toRomaji(of character: String, in type: KanaType) -> String? {
        if !character.isEmpty {
            let chart = type == .hiragana
                ? hiraganaChart
                : katakanaChart

            let smallChart = type == .hiragana
                ? smallCharsHiragana
                : smallCharsKatakana

            for row in 0..<chart.count {
                if let col = chart[row].firstIndex(of: character) {
                    return romajiChart[row][col]
                }
            }

            if smallChart.firstIndex(of: String(character.suffix(1))) != nil {
                let small = smallCharsRomaji[smallChart.firstIndex(of: String(character.suffix(1)))!]

                let newChar = toRomaji(of: String(character.prefix(character.count - 1)), in: type)!

                if ["fu", "vu", "shi", "ji", "chi", "tsu"].firstIndex(of: newChar) != nil {
                    return newChar.prefix(newChar.count - 1) + small
                } else if newChar.hasSuffix("u") {
                    return newChar.prefix(newChar.count - 1) + "w" + small
                } else if newChar.hasSuffix("i") {
                    return newChar.prefix(newChar.count - 1) + "y" + small
                }

                return newChar + small
            }
        }

        return nil
    }

    public static func toKatakana(of character: String, in type: KanaType) -> String? {
        if !character.isEmpty {
            let chart = type == .hiragana
                ? hiraganaChart
                : romajiChart

            for row in 0..<chart.count {
                if let col = chart[row].firstIndex(of: character) {
                    return katakanaChart[row][col]
                }
            }
        }

        return nil
    }

    public static func toHiragana(of character: String, in type: KanaType) -> String? {
        if !character.isEmpty {
            let chart = type == .katakana
                ? katakanaChart
                : romajiChart

            for row in 0..<chart.count {
                if let col = chart[row].firstIndex(of: character) {
                    return hiraganaChart[row][col]
                }
            }
        }

        return nil
    }
    
    private static func addProlongedSoundMark(char: String.SubSequence) -> String {
        switch char {
            case "a":
                return "ā"

            case "i":
                return "ī"

            case "u":
                return "ū"

            case "e":
                return "ē"

            case "o":
                return "ō"

            case "A":
                return "Ā"

            case "I":
                return "Ī"

            case "U":
                return "Ū"

            case "E":
                return "Ē"

            case "O":
                return "Ō"

            default:
                return String(char)
        }
    }

    public static func convert(_ input: String, to kana: Kana.KanaType, useProlongedSoundMark: Bool = false, romajiKatakanaUppercase: Bool = false) -> String {
        let trimmed: String = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let tokenizer: CFStringTokenizer =
            CFStringTokenizerCreate(kCFAllocatorDefault,
                                    trimmed as CFString,
                                    CFRangeMake(0, trimmed.utf16.count),
                                    kCFStringTokenizerUnitWordBoundary,
                                    Locale(identifier: "ja") as CFLocale)

        switch kana {
            case .hiragana:
                return tokenizer.hiragana
            case .katakana:
                return tokenizer.katakana
            case .romaji:
                var text = Array(trimmed)
                
                if !useProlongedSoundMark && !romajiKatakanaUppercase {
                    text = Array(tokenizer.hiragana)
                }
                
                var translated: String = ""
                var doubleConsonants = false

                let smallChars: [String.Element] = ["ゃ", "ょ", "ゅ", "ぁ", "ぃ", "ぅ", "ぇ", "ぉ",
                                                    "ャ", "ュ", "ョ", "ァ", "ィ", "ゥ", "ェ", "ォ"]

                for i in 0..<text.count {
                    if ["ッ", "っ"].firstIndex(of: text[i]) != nil {
                        doubleConsonants = true
                        continue
                    }

                    if smallChars.firstIndex(of: text[i]) != nil {
                        continue
                    }
                    
                    if useProlongedSoundMark {
                        if text[i] == "ー" && translated.count > 0 {
                            translated = translated.prefix(translated.count - 1) + addProlongedSoundMark(char: translated.suffix(1))
                            continue
                        }
                        
                        if ["あ", "い", "う", "え", "お"].firstIndex(of: text[i]) != nil {
                            let char = translated.suffix(1)
                            if  (char == "a" && text[i] == "あ") ||
                                (char == "i" && text[i] == "い") ||
                                (char == "u" && text[i] == "う") ||
                                (char == "e" && (text[i] == "え" || text[i] == "い")) ||
                                (char == "o" && (text[i] == "お" || text[i] == "う")) {
                                translated = translated.prefix(translated.count - 1) + addProlongedSoundMark(char: translated.suffix(1))
                                continue
                            }
                        }
                    } else if text[i] == "ー" && translated.count > 0 {
                        translated = translated + translated.suffix(1)
                        continue
                    }
                    
                    var gyon: String = String(text[i])
                    if i + 1 < text.count && smallChars.firstIndex(of: text[i + 1]) != nil {
                        gyon = "\(text[i])\(text[i + 1])"
                    }

                    var romaji = Kana.toRomaji(of: gyon, in: .hiragana) ?? (romajiKatakanaUppercase ? Kana.toRomaji(of: gyon, in: .katakana)?.uppercased() : Kana.toRomaji(of: gyon, in: .katakana)) ?? gyon
                    
                    if doubleConsonants {
                        romaji = romaji.prefix(1) + romaji
                    }
                    translated += romaji
                    doubleConsonants = false
                }
                return translated
        }
    }

    public static func random(in table: KanaTable) -> Kana {
        var randomKana: Kana?

        while true {
            let row = Int.random(in: 0..<table.count)
            let col = Int.random(in: 0..<table[row].count)

            if table[row][col].isValid {
                randomKana = table[row][col]
                break
            }
        }

        return randomKana!
    }

    public static func random(with columns: [KanaColumns.Keys]) -> Kana {
        let table = getTable(with: columns)
        return self.random(in: table)
    }

    public static func random(in table: KanaTable, count number: Int, uniq repeatable: Bool = false) -> [Kana] {
        if repeatable {
            return (0..<number).map { _ in
                Kana.random(in: table)
            }
        }

        var randomItems = Set<Kana>()
        while randomItems.count < number {
            randomItems.insert(Kana.random(in: table))
        }

        return Array(randomItems)
    }

    public static func random(with columns: [KanaColumns.Keys], count number: Int, uniq repeatable: Bool = false) -> [Kana] {
        let table = getTable(with: columns)
        return self.random(in: table, count: number, uniq: repeatable)
    }
}

fileprivate extension CFStringTokenizer {
    var hiragana: String { string(to: kCFStringTransformLatinHiragana) }
    var katakana: String { string(to: kCFStringTransformLatinKatakana) }

    private func string(to transform: CFString) -> String {
        var output: String = ""
        while !CFStringTokenizerAdvanceToNextToken(self).isEmpty {
            output.append(letter(to: transform))
        }
        return output
    }

    private func letter(to transform: CFString) -> String {
        let mutableString: NSMutableString =
            CFStringTokenizerCopyCurrentTokenAttribute(self, kCFStringTokenizerAttributeLatinTranscription)
                .flatMap { $0 as? NSString }
                .map { $0.mutableCopy() }
                .flatMap { $0 as? NSMutableString } ?? NSMutableString()

        CFStringTransform(mutableString, nil, transform, false)

        return mutableString as String
    }
}
