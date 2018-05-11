import Foundation

protocol ESPTouchControllerDelegate {
    func handleConnectionTimeoutAlert(resultCount: Int);
    func handleAddedResult(resultCount: Int, bssid: String!, ip: String!)
}
