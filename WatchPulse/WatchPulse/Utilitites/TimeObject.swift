struct TimeObject {
    private let _totalSeconds: Int
    
    var hours: Int {
        _totalSeconds / 3600
    }
    
    var minutes: Int {
        (_totalSeconds % 3600) / 60
    }
    
    var seconds: Int {
        _totalSeconds % 60
    }
    
    init(seconds: Int) {
        self._totalSeconds = seconds
    }
}
