{-| Move the box while it falls! 
-}

import Collage
import Color
import Element
import Html
import Html.App
import AnimationFrame
import Time
import Keyboard.Extra

type alias Model = 
    { y : Int
    , velocity : Float
    , keyboard : Keyboard.Extra.Model
    }

type Msg = Nothing 
    | Tick Time.Time
    | KeyboardExtraMsg Keyboard.Extra.Msg

init : (Model, Cmd Msg)
init =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.Extra.init
        model = 
            { y = 450
            , velocity = 0
            , keyboard = keyboardModel
            }
    in
        (model, Cmd.map KeyboardExtraMsg keyboardCmd)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Nothing ->
            (model, Cmd.none)
        KeyboardExtraMsg keyMsg ->
            updateKeys keyMsg model
        Tick delta ->
            (step delta model, Cmd.none)

step : Float -> Model -> Model
step delta model =
    model
        |> gravity delta
        |> physics delta
        |> keyboard

gravity : Float -> Model -> Model
gravity delta model =
    { model
        | velocity = model.velocity - delta * 20
    }

physics : Float -> Model -> Model
physics delta model =
    { model |
        y = (toFloat model.y + delta * model.velocity * 35)
                |> max 0
                |> round
    }

keyboard : Model -> Model
keyboard model =
    -- You need to handle input here!
    model

updateKeys : Keyboard.Extra.Msg -> Model -> (Model, Cmd Msg)
updateKeys keyMsg model =
    let
        ( keyboardModel, keyboardCmd ) =
          Keyboard.Extra.update keyMsg model.keyboard
    in
        ({model | keyboard = keyboardModel}
        , Cmd.map KeyboardExtraMsg keyboardCmd)

view : Model -> Html.Html Msg
view model =
    let
        element = Collage.collage 100 100
            [ Element.image 100 100 "/assets/cat-running-right.gif"
                |> Collage.toForm
            ]
            |> Element.container 500 500
                (Element.bottomLeftAt 
                    (Element.absolute 250)
                    (Element.absolute model.y)
            )
    in
        Html.div [] [ element |> Element.toHtml ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyboardExtraMsg Keyboard.Extra.subscriptions
        , AnimationFrame.diffs (Tick << Time.inSeconds)
        ]

main : Program Never
main =
    Html.App.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
    }
