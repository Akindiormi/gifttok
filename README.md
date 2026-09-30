# GiftTok

Flutter app: live TikTok creator board, creator profiles, gift leaders, and follows.

## Run
```
flutter create .
flutter run
```

## Backend
All data goes through `GiftTokRepository` (`lib/repository.dart`). It currently uses `MockRepository`.
Implement an `ApiRepository` for your backend and swap it in `lib/main.dart`.

## Brand assets
Put `gifttok-mark.png` and `gifttok-logo-wide.png` in `assets/brand/`.
