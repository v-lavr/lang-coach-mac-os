import AppKit
import ApplicationServices

@MainActor
final class AccessibilityService {
    struct EditableField { let element: AXUIElement; let value: String }
    var hasPermission: Bool { AXIsProcessTrusted() }
    func requestPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }
    func focusedEditableField() -> EditableField? {
        guard hasPermission else { return nil }
        let system = AXUIElementCreateSystemWide()
        var focused: CFTypeRef?
        guard AXUIElementCopyAttributeValue(system, kAXFocusedUIElementAttribute as CFString, &focused) == .success, let focused else { return nil }
        let element = focused as! AXUIElement
        // A secure text field is identified by its AX subrole. Check this before
        // requesting AXValue so password contents are never read by LangCoach.
        guard !isSecure(element) else { return nil }
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &value) == .success, let text = value as? String else { return nil }
        return EditableField(element: element, value: text)
    }
    func replace(_ original: String, with corrected: String, in element: AXUIElement) -> Bool {
        guard let current = attribute(kAXValueAttribute, from: element) as? String, let range = current.range(of: original, options: .backwards) else { print("LangCoach: replacement failed; text changed"); return false }
        var selection = NSRange(range, in: current)
        guard let value = AXValueCreate(.cfRange, &selection), AXUIElementSetAttributeValue(element, kAXSelectedTextRangeAttribute as CFString, value) == .success else { print("LangCoach: replacement failed; range unavailable"); return false }
        let result = AXUIElementSetAttributeValue(element, kAXSelectedTextAttribute as CFString, corrected as CFTypeRef)
        if result != .success { print("LangCoach: replacement failed with AX error \(result.rawValue)") }
        return result == .success
    }
    private func isSecure(_ element: AXUIElement) -> Bool {
        (attribute(kAXSubroleAttribute, from: element) as? String) == kAXSecureTextFieldSubrole as String
    }
    private func attribute(_ name: String, from element: AXUIElement) -> CFTypeRef? { var value: CFTypeRef?; return AXUIElementCopyAttributeValue(element, name as CFString, &value) == .success ? value : nil }
}
