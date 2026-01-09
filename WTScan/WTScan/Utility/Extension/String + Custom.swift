//
//  String + Custom.swift
//  WTScan
//
//  Created by iMac on 12/11/25.
//


import Foundation
import UIKit

extension Character {
    var isEmoji: Bool {
        unicodeScalars.contains { $0.properties.isEmoji && ($0.value > 0x238C || unicodeScalars.count > 1) }
    }
}

// MARK: - Text Style Extensions

extension String {

    func sentenceCased() -> String {
        var result = ""
        var shouldCapitalizeNextLetter = true
        
        let sentenceTerminators: Set<Character> = [".", "!", "?"]
        
        for char in self {
            if char.isLetter {
                if shouldCapitalizeNextLetter {
                    result.append(contentsOf: String(char).uppercased())
                    shouldCapitalizeNextLetter = false
                } else {
                    result.append(contentsOf: String(char).lowercased())
                }
            } else {
                result.append(char)
                if sentenceTerminators.contains(char) {
                    shouldCapitalizeNextLetter = true
                }
            }
        }
        
        return result
    }
    
    /// Capitalizes only the first letter of the string.
    func capitalizingFirstLetter() -> String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
    
    /// Converts text into alternating case: hElLo WoRlD
    func alternatingCase() -> String {
        var result = ""
        var index = 0
        
        for char in self {
            if char.isLetter {
                let converted = index % 2 == 0
                ? char.lowercased()
                : char.uppercased()
                
                result.append(converted)
                index += 1
            } else {
                result.append(char)
            }
        }
        
        return result
    }
    
    /// Toggles the case of each letter: HeLLo -> hEllO
    func toggleCase() -> String {
        return self.map { char -> String in
            if char.isUppercase {
                return char.lowercased()
            }
            if char.isLowercase {
                return char.uppercased()
            }
            return String(char)
        }
        .joined()
    }

    // 1. Bold Style
    func toBold() -> String {
        let base = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let bold = Array("𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘵𝘶𝘷𝘄𝘅𝘺𝘇𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭𝟬𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵")
        return String(self.map { base.firstIndex(of: $0).map { bold[$0] } ?? $0 })
    }

    // 2. Italic Style
    func toItalic() -> String {
        let base = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let italic = Array("𝘢𝘣𝘤𝘥𝘦𝘧𝘨𝘩𝘪𝘫𝘬𝘭𝘮𝘯𝘰𝘱𝘲𝘳𝘴𝘵𝘶𝘷𝘸𝘹𝘺𝘻𝘈𝘉𝘊𝘋𝘌𝘍𝘎𝘏𝘐𝘑𝘒𝘓𝘔𝘕𝘖𝘗𝘘𝘙𝘚𝘛𝘜𝘝𝘞𝘟𝘠𝘡")
        return String(self.map { base.firstIndex(of: $0).map { italic[$0] } ?? $0 })
    }

    // 3. Monospace Style
    func toMonospace() -> String {
        let base = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let mono = Array("𝚊𝚋𝚌𝚍𝚎𝚏𝚐𝚑𝚒𝚓𝚔𝚕𝚖𝚗𝚘𝚙𝚚𝚛𝚜𝚝𝚞𝚟𝚠𝚡𝚢𝚣𝙰𝙱𝙲𝙳𝙴𝙵𝙶𝙷𝙸𝙹𝙺𝙻𝙼𝙽𝙾𝙿𝚀𝚁𝚂𝚃𝚄𝚅𝚆𝚇𝚈𝚉𝟶𝟷𝟸𝟹𝟺𝟻𝟼𝟽𝟾𝟿")
        return String(self.map { base.firstIndex(of: $0).map { mono[$0] } ?? $0 })
    }

    // 4. Bubble Style
    func toBubble() -> String {
        let base = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let bubble = Array("ⓐⓑⓒⓓⓔⓕⓖⓗⓘⓙⓚⓛⓜⓝⓞⓟⓠⓡⓢⓣⓤⓥⓦⓧⓨⓩⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ⓪①②③④⑤⑥⑦⑧⑨")
        return String(self.map { base.firstIndex(of: $0).map { bubble[$0] } ?? $0 })
    }

    // 5. Double Struck Style
    func toDoubleStruck() -> String {
        let dict: [Character: Character] = [
            "A":"𝔸","B":"𝔹","C":"ℂ","D":"𝔻","E":"𝔼","F":"𝔽","G":"𝔾","H":"ℍ","I":"𝕀","J":"𝕁",
            "K":"𝕂","L":"𝕃","M":"𝕄","N":"ℕ","O":"𝕆","P":"ℙ","Q":"ℚ","R":"ℝ","S":"𝕊","T":"𝕋",
            "U":"𝕌","V":"𝕍","W":"𝕎","X":"𝕏","Y":"𝕐","Z":"ℤ",
            "a":"𝕒","b":"𝕓","c":"𝕔","d":"𝕕","e":"𝕖","f":"𝕗","g":"𝕘","h":"𝕙","i":"𝕚","j":"𝕛",
            "k":"𝕜","l":"𝕝","m":"𝕞","n":"𝕟","o":"𝕠","p":"𝕡","q":"𝕢","r":"𝕣","s":"𝕤","t":"𝕥",
            "u":"𝕦","v":"𝕧","w":"𝕨","x":"𝕩","y":"𝕪","z":"𝕫"
        ]
        return String(self.map { dict[$0] ?? $0 })
    }

    // 6. Fraktur Style (Gothic)
    func toFraktur() -> String {
        let dict: [Character: Character] = [
            "a":"𝔞","b":"𝔟","c":"𝔠","d":"𝔡","e":"𝔢","f":"𝔣","g":"𝔤","h":"𝔥","i":"𝔦","j":"𝔧",
            "k":"𝔨","l":"𝔩","m":"𝔪","n":"𝔫","o":"𝔬","p":"𝔭","q":"𝔮","r":"𝔯","s":"𝔰","t":"𝔱",
            "u":"𝔲","v":"𝔳","w":"𝔴","x":"𝔵","y":"𝔶","z":"𝔷",
            "A":"𝔄","B":"𝔅","C":"ℭ","D":"𝔇","E":"𝔈","F":"𝔉","G":"𝔊","H":"ℌ","I":"ℑ","J":"𝔍",
            "K":"𝔎","L":"𝔏","M":"𝔐","N":"𝔑","O":"𝔒","P":"𝔓","Q":"𝔔","R":"ℜ","S":"𝔖","T":"𝔗",
            "U":"𝔘","V":"𝔙","W":"𝔚","X":"𝔛","Y":"𝔜","Z":"ℨ"
        ]
        return String(self.map { dict[$0] ?? $0 })
    }

    // 7. Small Caps Style
    func toSmallCaps() -> String {
        let dict: [Character: Character] = [
            "a":"ᴀ","b":"ʙ","c":"ᴄ","d":"ᴅ","e":"ᴇ","f":"ғ","g":"ɢ","h":"ʜ","i":"ɪ","j":"ᴊ",
            "k":"ᴋ","l":"ʟ","m":"ᴍ","n":"ɴ","o":"ᴏ","p":"ᴘ","q":"ǫ","r":"ʀ","s":"s","t":"ᴛ",
            "u":"ᴜ","v":"ᴠ","w":"ᴡ","x":"x","y":"ʏ","z":"ᴢ"
        ]
        return String(lowercased().map { dict[$0] ?? $0 })
    }

    // 8. Superscript Style
    func toSuperscript() -> String {
        let dict: [Character: Character] = [
            "a":"ᵃ","b":"ᵇ","c":"ᶜ","d":"ᵈ","e":"ᵉ","f":"ᶠ","g":"ᵍ","h":"ʰ","i":"ᶦ","j":"ʲ",
            "k":"ᵏ","l":"ˡ","m":"ᵐ","n":"ⁿ","o":"ᵒ","p":"ᵖ","q":"ᑫ","r":"ʳ","s":"ˢ","t":"ᵗ",
            "u":"ᵘ","v":"ᵛ","w":"ʷ","x":"ˣ","y":"ʸ","z":"ᶻ",
            "1":"¹","2":"²","3":"³"
        ]
        return String(lowercased().map { dict[$0] ?? $0 })
    }

    // 9. Upside Down Style
    func toUpsideDown() -> String {
        let dict: [Character: Character] = [
            "a":"ɐ","b":"q","c":"ɔ","d":"p","e":"ǝ","f":"ɟ","g":"ƃ","h":"ɥ","i":"ᴉ","j":"ɾ",
            "k":"ʞ","l":"ʃ","m":"ɯ","n":"u","o":"o","p":"d","q":"b","r":"ɹ","s":"s","t":"ʇ",
            "u":"n","v":"ʌ","w":"ʍ","x":"x","y":"ʎ","z":"z",
            "1":"Ɩ","2":"ᄅ","3":"Ɛ","4":"ㄣ","5":"ϛ","6":"9","7":"ㄥ","8":"8","9":"6","0":"0"
        ]
        return String(lowercased().reversed().map { dict[$0] ?? $0 })
    }

    // 10. Mirror Text Style
    func toMirrorText() -> String {
        let dict: [Character: Character] = [
            "a":"ɒ","b":"d","c":"ɔ","d":"b","e":"ǝ","f":"ɟ","g":"ǫ","h":"ɥ","i":"ᴉ","j":"ɾ",
            "k":"ʞ","l":"ʃ","m":"ɯ","n":"u","o":"o","p":"q","q":"p","r":"ɿ","s":"s","t":"ʇ",
            "u":"n","v":"ʌ","w":"ʍ","x":"x","y":"ʎ","z":"z"
        ]
        return String(self.map { dict[$0] ?? $0 })
    }

    // 11. Outline Style
    func toOutline() -> String {
        let dict: [Character: Character] = [
            "A":"🄰","B":"🄱","C":"🄲","D":"🄳","E":"🄴","F":"🄵","G":"🄶","H":"🄷","I":"🄸","J":"🄹",
            "K":"🄺","L":"🄻","M":"🄼","N":"🄽","O":"🄾","P":"🄿","Q":"🅀","R":"🅁","S":"🅂",
            "T":"🅃","U":"🅄","V":"🅅","W":"🅆","X":"🅇","Y":"🅈","Z":"🅉"
        ]
        return String(self.map { dict[$0] ?? $0 })
    }

    // 12. Strike-through Style
    func toStrikeThrough() -> String {
        return String(self.map { [$0, "\u{0336}"] }.joined())
    }

    // 13. Underline Style
    func toUnderline() -> String {
        return String(self.map { [$0, "\u{0332}"] }.joined())
    }

    // 14. Tiny Text Style
    func toTinyText() -> String {
        let dict: [Character: Character] = [
            "a":"ᵃ","b":"ᵇ","c":"ᶜ","d":"ᵈ","e":"ᵉ","f":"ᶠ","g":"ᵍ","h":"ʰ","i":"ᶦ","j":"ʲ",
            "k":"ᵏ","l":"ˡ","m":"ᵐ","n":"ⁿ","o":"ᵒ","p":"ᵖ","q":"ᑫ","r":"ʳ","s":"ˢ","t":"ᵗ",
            "u":"ᵘ","v":"ᵛ","w":"ʷ","x":"ˣ","y":"ʸ","z":"ᶻ"
        ]
        return String(lowercased().map { dict[$0] ?? $0 })
    }

    // 15. Inverted Case Style
    func invertedCase() -> String {
        return String(self.map {
            $0.isUppercase ? Character($0.lowercased()) :
            $0.isLowercase ? Character($0.uppercased()) : $0
        })
    }
}
