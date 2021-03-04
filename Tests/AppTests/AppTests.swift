@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testWeb() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "http://127.0.0.1:8080/users/me",headers: ["Content-Type": "application/json", "Authorization": " IjB9ejawWut9jdKHrBPX3g=="], afterResponse:{ res in
            XCTAssertEqual(res.status, .notFound)
        })

        try app.test(.POST, "http://127.0.0.1:8080/users/login",headers: ["Content-Type": "application/json", "Authorization": " IjB9ejawWut9jdKHrBPX3g=="], afterResponse:{ res in
            XCTAssertEqual(res.status, .notFound)
        })

        try app.test(.POST, "http://127.0.0.1:8080/users/logout",headers: ["Content-Type": "application/json", "Authorization": " IjB9ejawWut9jdKHrBPX3g=="], afterResponse:{ res in
            XCTAssertEqual(res.status, .notFound)
        })


        let aloc = ByteBufferAllocator()
        var buf = aloc.buffer(capacity: 200)
        buf.setString("{\n    \"user\": {\n        \"username\": \"NatanTheChef\",\n        \"id\": \"B2FE0C9B-D9B3-486E-9576-46682A36DB92\",\n        \"updatedAt\": \"2020-12-13T17:14:59Z\",\n        \"createdAt\": \"2020-12-13T17:14:59Z\"\n    },\n    \"body\": \"i want a baloon\"\n}",at: 0)


        try app.test(.POST, "http://127.0.0.1:8080/notes/create",headers: ["Content-Type": "application/json", "Authorization": " IjB9ejawWut9jdKHrBPX3g=="], body: buf, afterResponse:{ res in
            XCTAssertEqual(res.status, .notFound)
        })

        try app.test(.GET, "http://127.0.0.1:8080/notes/get",headers: ["Content-Type": "application/json", "Authorization": " IjB9ejawWut9jdKHrBPX3g=="], afterResponse:{ res in
            XCTAssertEqual(res.status, .notFound)
        })

        try app.test(.POST, "http://127.0.0.1:8080/notes/delete",headers: ["Content-Type": "application/json", "Authorization": " IjB9ejawWut9jdKHrBPX3g=="], body: buf, afterResponse:{ res in
            XCTAssertEqual(res.status, .notFound)
        })

        try app.test(.PUT, "http://127.0.0.1:8080/users/logout",headers: ["Content-Type": "application/json", "Authorization": " IjB9ejawWut9jdKHrBPX3g=="], body: buf, afterResponse:{ res in
            XCTAssertEqual(res.status, .notFound)
        })
    }
}
