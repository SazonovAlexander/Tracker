import UIKit


extension UIColor {
    
    static func colorFromString(_ hexString: String) -> UIColor? {
        var formattedString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedString = formattedString.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: formattedString).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func hexStringFromColor(_ color: UIColor) -> String {
            let components = color.cgColor.components
            let r = components?[0] ?? 0.0
            let g = components?[1] ?? 0.0
            let b = components?[2] ?? 0.0

            let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
            return hexString
        }
}
