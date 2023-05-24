import SwiftUI

extension Date {

    func defaultFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: self)
    }
}

extension String {

    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.date(from: self)
    }
}

extension Notification.Name {
    
    static let coreDataUpdate = Notification.Name("CoreDataUpdated")
}

extension Color {
    
    static let tableBackground = Color(#colorLiteral(red: 0.9370916486, green: 0.9369438291, blue: 0.9575446248, alpha: 1))
}

extension LocalizedStringKey {

    var asString: String {
        let mirror = Mirror(reflecting: self)
        let attributeLabelAndValue = mirror.children.first {
            let (label, _) = $0
            return label == "key"
        }
        if attributeLabelAndValue != nil {
            return String.localizedStringWithFormat(NSLocalizedString(attributeLabelAndValue!.value as? String ?? "", comment: ""));
        } else {
            return ""
        }
    }
}
