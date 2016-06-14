{-| Demonstrate gravity in a game loop 
-}

import Collage
import Color
import Element
import Html
import Html.App
import AnimationFrame
import Time

type alias Model = 
    { y : Int
    , velocity : Float
    }

type Msg = Nothing | Tick Time.Time

init : (Model, Cmd Msg)
init =
    ({ y = 450, velocity = 0}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Nothing ->
            (model, Cmd.none)
        Tick delta ->
            (step delta model, Cmd.none)

step : Float -> Model -> Model
step delta model =
    model
        |> gravity delta
        |> physics delta

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

view : Model -> Html.Html Msg
view model =
    let
        element = Collage.collage 100 100
            [ Collage.rect 100 100
                |> Collage.filled Color.red
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
    AnimationFrame.diffs (Tick << Time.inSeconds)

main : Program Never
main =
    Html.App.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
    }
