# Game Loops

## Pipelines Make for Nice Loops

```elm
step : Float -> Model -> Model
step delta model =
    model
        |> gravity delta
        |> jump
        |> walk
        |> physics delta
        |> updateKid delta
        |> updateElapsedGameTime delta
        |> collision model
```

- delta is time difference since last frame
- Easy to use pipes to feed model from one function to another
- Easy to plugin more steps

## Example

See Gravity.elm
