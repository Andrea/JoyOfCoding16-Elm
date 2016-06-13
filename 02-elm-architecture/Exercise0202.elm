module Exercise0202 exposing (..)

{-| Show the updated window size
-}

import Html
import Html.App
import Window

type alias Model =
    { window : Window.Size }

type Msg
    = Nothing
    | WindowSizeChange Window.Size

init : (Model, Cmd Msg)
init =
    ({ window = Window.Size -1 -1 }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Nothing -> (model, Cmd.none)
        -- Hint: model updates take the form { model | someField = newValue}
        WindowSizeChange newSize -> (model, Cmd.none)


view : Model -> Html.Html Msg
view model =
    -- Hint: you can use toString model.something to convert to a string
    -- Hint: ++ is used to join strings
    -- Hint: you might need to wrap calls in brackets to get right function calls
    Html.h1 [] [ Html.text ("Window size: " ++ "???") ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Window.resizes WindowSizeChange

main : Program Never
main =
    Html.App.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
    }
