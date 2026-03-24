# NeuroKit Documentation

## Overview

NeuroKit is an AI SDK designed to simplify integration of conversational AI into iOS applications using modern Swift concurrency.

---

## Core Concepts

### 1. NeuroKit (Actor)

The main entry point responsible for:

* Managing chat state
* Ensuring thread safety
* Coordinating services

---

### 2. NeuroService

Handles:

* API communication
* Request building
* Response parsing

Stateless and Sendable.

---

### 3. NeuroStreamService

Handles:

* Streaming responses via SSE
* Real-time text updates

---

### 4. Message Model

```swift
struct Message {
    let role: Role
    let content: String
}
```

Roles:

* system
* user
* assistant

---

## Data Flow

```
User Input
   ↓
NeuroKit (actor)
   ↓ snapshot
NeuroService / StreamService
   ↓
OpenAI API
   ↓
Response
   ↓
NeuroKit updates state
```

---

## Concurrency Design

* Actor used for state isolation
* Services are Sendable
* No MainActor usage in networking
* Safe snapshot passing

---

## Streaming Flow

1. User sends message
2. Stream starts
3. SSE chunks received
4. UI updates incrementally

---

## Error Handling

Errors handled at:

* Network layer (HTTPClient)
* Service layer
* ViewModel layer

---

## Extending NeuroKit

You can extend:

### Add New AI Mode

```swift
extension NeuroConfiguration {
    static let finance = NeuroConfiguration(
        systemPrompt: "You are a finance advisor"
    )
}
```

---

### Custom Storage

Implement:

```swift
protocol ChatStorage {
    func save(_ messages: [Message])
    func load() -> [Message]
}
```

---

### Add Plugins (Future)

* Weather API
* Location services
* Calendar integration

---

## Best Practices

* Do not block MainActor
* Use streaming for better UX
* Keep services stateless
* Use backend for API keys in production

---

## Testing

Use mock services:

```swift
class MockService: NeuroService {
    override func send(...) -> String {
        return "Mock response"
    }
}
```

---

## Performance Tips

* Use streaming for long responses
* Avoid large message history
* Cache previous responses if needed

---

## Future Improvements

* Multi-agent AI
* Function calling
* Offline models
* Edge AI (CoreML)

---

## Conclusion

NeuroKit provides a clean, scalable, and modern approach to integrating AI into iOS apps using Swift concurrency.
