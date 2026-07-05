struct Status
{
    static let ok = 200
    static let success = "SUCCESS"
    static let expired = "EXPIRED"
    static let error = "BAD_REQUEST"
    struct invalidCredentials
    {
        static let key = "INCORRECT_CREDENTIALS"
        static let message = "ERROR: Invalid Credentials!"
    }
    static let invalidArgumentType = "INVALID_ARGUMENT_TYPE"
    static let unauthorized  = "UNAUTHORIZED"
    static let unknownError  = "UNKNOWN_ERROR"
    static let unknown       = "UNKNOWN"
    static let malformedJson = "MALFORMED_JSON"
    static let databaseError = "DB_ERROR"
    static let notFound      = "NOT_FOUND"
}
