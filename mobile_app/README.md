# hotel_access_app

## update dot_env
Before running, make sure to copy the content of .env.example into a new .env file with the right values.

## build dev

iOS: `flutter build ipa --flavor dev -t lib/main_dev.dart --release`\
Android: `flutter build apk --flavor dev -t lib/main_dev.dart --release`

## build prod

iOS: `flutter build ipa --flavor prod -t lib/main_prod.dart --release`\
Android: `flutter build apk --flavor prod -t lib/main_prod.dart --release`