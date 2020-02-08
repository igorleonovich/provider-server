import Vapor

struct WebSockets {
    
    static func configure(_ webSocketServer: NIOWebSocketServer) {
        
        webSocketServer.get("connect", Client.parameter) { ws, req in
            ws.onText { ws, text in
                print("ws received: \(text)")
                if let newState = ClientState.init(rawValue: text) {
                    do {
                        let _ = try req.parameters.next(Client.self).flatMap { client -> Future<Client> in
                            client.state = newState.rawValue
                            return client.save(on: req)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}