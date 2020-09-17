import Foundation

public enum CustomError: Error {
    case houstonWeHaveAProblem
    case mathImpossibility
    case parsingWentWrong
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .houstonWeHaveAProblem:
            return NSLocalizedString("Houston, we have a problem!", comment: "")
        case .mathImpossibility:
            return NSLocalizedString("It's not mathematically possible!", comment: "")
        case .parsingWentWrong:
            return NSLocalizedString("Decoding of some data went wrong!", comment: "")
        }
    }
}
