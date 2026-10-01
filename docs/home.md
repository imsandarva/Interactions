# Home

The opening screen is an index of studies. Each study is a number. Tap a number to open that study on its own screen.

Study 01 is the payment screen. Study 02 is feedback: a sheet that asks how it felt. Study 03 is places: a card that grows into the page. With no studies in the list, the index stays on a quiet empty page so the app is never a blank white frame.

## Add a study

1. Build the screen in its own file under `lib/studies/`.
2. Append a `Study` to the list in `lib/studies/study_registry.dart`.

The home screen numbers the list from the top. Nothing else needs to change.

## How the app is wired

`lib/main.dart` only starts the app. `InteractionsApp` applies the light theme and opens the home screen. The home screen composes the masthead, the count, and the index card. Each study stays in its own screen, so one experiment cannot break another.
