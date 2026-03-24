# 🧠 NeuroKit

**NeuroKit** is a lightweight, production-ready AI SDK for iOS built with Swift Concurrency.

It allows developers to integrate powerful AI chat experiences into their apps with minimal setup.

---

## ✨ Features

* ⚡ Async/Await based API
* 🧠 Actor-based architecture (thread-safe)
* 💬 Chat-based AI interaction
* 🔄 Streaming responses (real-time typing)
* 🔐 Secure API key handling
* 📦 Swift Package Manager support
* 🧩 Clean & scalable architecture

---

## 📦 Installation

### Swift Package Manager

Add this to your project:

```
https://github.com/codehub-prog/NeuroKit
```

---

## 🚀 Getting Started

### 1. Setup API Key

Add your API key in **Info.plist**:

```
OPENAI_API_KEY = sk-xxxx
```

---

### 2. Create API Key Provider

```swift
struct APIKeyProviderImpl: APIKeyProvider {
    func getAPIKey() -> String {
        Bundle.main.object(
            forInfoDictionaryKey: "OPENAI_API_KEY"
        ) as? String ?? ""
    }
}
```

---

### 3. Initialize NeuroKit

```swift
let neuro = NeuroKit(
    configuration: .travel,
    apiKeyProvider: APIKeyProviderImpl()
)
```

---

### 4. Send Message

```swift
let response = try await neuro.send("Suggest places in Himachal")
print(response)
```

---

## ⚡ Streaming (Real-Time Response)

```swift
for try await chunk in neuro.stream("Hello") {
    print(chunk, terminator: "")
}
```

---

## 🧠 Configuration

Predefined AI personalities:

```swift
.travel
.dating
.fitness
```

Custom configuration:

```swift
let custom = NeuroConfiguration(
    systemPrompt: "You are a finance advisor"
)
```

---

## 🏗️ Architecture

```
NeuroKit (actor)
   ↓
NeuroService (Sendable)
   ↓
HTTPClient (Sendable)
```

* Actor ensures thread safety
* Services remain stateless
* Fully Swift 6 concurrency compliant

---

## 📱 SwiftUI Integration

```swift
@StateObject var vm = NeuroViewModel(neuro: neuro)
```

Supports:

* Chat UI
* Streaming updates
* Typing indicators

---

## 🔐 Security

⚠️ Do NOT store API keys in production apps.

Recommended:

```
iOS App → Backend → OpenAI
```

---

## 🧪 Requirements

* iOS 15+
* Swift 5.9+
* Xcode 15+

---

## 🚀 Roadmap

* [ ] Retry & exponential backoff
* [ ] Token usage tracking
* [ ] Tool / plugin system
* [ ] Voice integration
* [ ] Local AI support

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first.

---

## 📄 License

MIT License

---

## 👨‍💻 Author

Built with ❤️ by Anshul
