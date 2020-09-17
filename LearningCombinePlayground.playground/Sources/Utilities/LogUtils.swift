import Foundation

/// Enum which maps an appropiate symbol which added as
/// prefix for each log message
public enum LogEvent: String {
    case err   = "🔥"
    case info  = "ℹ️"
    case warn  = "⚠️"
    case xmpl  = "📢"
}

/// Wrapping Swift.print() within DEBUG flag
/// Prevents security vulnerabilities
func print(_ object: Any) {
    Swift.print(object)
}

public class LogUtils {
    static var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar.autoupdatingCurrent
        df.locale = Locale.autoupdatingCurrent
        df.timeZone = TimeZone.autoupdatingCurrent
        return df
    }

    // MARK: - Loging methods

    /// Logs error messages
    public class func err(
        _ object: Any,
        filename: String = #file,
        funcName: String = #function,
        line: Int = #line
    ) {
        print(
            "\(LogEvent.err.rawValue) [\(Date().toTimeString())] " +
            "\(object)"
        )
    }

    /// Logs info messages
    public class func info(
        _ object: Any,
        filename: String = #file,
        funcName: String = #function,
        line: Int = #line
    ) {
        print(
            "\(LogEvent.info.rawValue) [\(Date().toTimeString())] " +
            "\(object)"
        )
    }

    /// Logs warnings messages
    public class func warn(
        _ object: Any,
        filename: String = #file,
        funcName: String = #function,
        line: Int = #line
    ) {
        print(
            "\(LogEvent.warn.rawValue) [\(Date().toTimeString())] " +
            "\(object)"
        )
    }
    
    /// Logs warnings messages
    public class func xmpl(
        _ object: Any,
        filename: String = #file,
        funcName: String = #function,
        line: Int = #line
    ) {
        print(
            "\n\n\n" +
            "\(LogEvent.xmpl.rawValue) [\(Date().toTimeString())] " +
            "\(object)\n" +
            "=================================================="
        )
    }

    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    private class func sourceFileName(filePath: String) -> String {
        guard let fileExt = filePath.components(separatedBy: "/").last,
            let fileName = fileExt.components(separatedBy: ".").first else {
            return ""
        }

        return fileName
    }
}

public extension DateFormatter {
    func string(for date: Date,
                dateStyle: DateFormatter.Style = .none,
                timeFormat: String? = nil) -> String {

        var dateString = ""

        self.dateStyle = dateStyle
        dateString += self.string(from: date)
        dateString += dateString.count > 0 ? " " : ""

        self.dateFormat = timeFormat
        dateString += self.string(from: date)

        return dateString
    }
}

public extension Date {
    func toDateString() -> String {
        return LogUtils.dateFormatter.string(for: self, timeFormat: "yyyy.MM.dd hh:mm:ss.SSSZ")
    }

    func toTimeString() -> String {
        return LogUtils.dateFormatter.string(for: self, timeFormat: "hh:mm:ss.SSSZ")
    }
}
