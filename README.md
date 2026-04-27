# -iOS-CriptoViewer
iOS App that displays an exchange list from Coin Market Cap

## Setup

### API Key

This project requires a CoinMarketCap API key to run. You can get one for free at [coinmarketcap.com](https://coinmarketcap.com/api/).

Once you have your key, create the file `CryptoViewer/CryptoViewer/Secrets.swift` with the following content:

```swift
enum Secrets {
    static let apiKey = "YOUR_API_KEY_HERE"
}
```

> `Secrets.swift` is listed in `.gitignore` and must never be committed to the repository.
