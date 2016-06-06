module Cat exposing (..)

{-| Cut down game, with level and basic collision detection

Main character is an exciting box
-}

import Element
import Html
import Html.App
import Keyboard.Extra


type Direction
    = Right
    | Left


type State
    = Standing
    | Running
    | Jumping


type alias Cat =
    { state : State
    , direction : Direction
    }


type alias Model =
    { cat : Cat
    , keyboardModel : Keyboard.Extra.Model
    }


type Msg
    = KeyboardExtraMsg Keyboard.Extra.Msg


init : ( Model, Cmd Msg )
init =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.Extra.init

        model =
            { cat = Cat Standing Right
            , keyboardModel = keyboardModel
            }
    in
        model
            ! [ Cmd.map KeyboardExtraMsg keyboardCmd
              ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardExtraMsg keyboardMsg ->
            let
                ( keyboardModel, keyboardCmd ) =
                    Keyboard.Extra.update keyboardMsg model.keyboardModel

                arrows =
                    Keyboard.Extra.arrows keyboardModel
                        |> Debug.log "arrows"

                cat =
                    model.cat

                -- Note: Inferring the animation state directly from keyboard presses is kinda clunky.
                -- Better to update a model (e.g. direction and velocity) and render based on that.
                ( runningState, direction ) =
                    case Keyboard.Extra.arrowsDirection keyboardModel of
                        Keyboard.Extra.East ->
                            ( Running, Right )

                        Keyboard.Extra.West ->
                            ( Running, Left )

                        _ ->
                            ( Standing, cat.direction )

                -- In particular here, if we're mid air and let go of space the cat returns to a
                -- running or standing state.
                jumpingState =
                    case Keyboard.Extra.isPressed Keyboard.Extra.Space keyboardModel of
                        True ->
                            Jumping

                        False ->
                            Standing

                state =
                    case ( runningState, jumpingState ) of
                        ( Standing, Jumping ) ->
                            Jumping

                        ( Running, Standing ) ->
                            Running

                        ( Running, Jumping ) ->
                            Jumping

                        ( _, _ ) ->
                            Standing

                newCat =
                    { cat | direction = direction, state = state }
            in
                { model | cat = newCat, keyboardModel = keyboardModel } ! [ Cmd.map KeyboardExtraMsg keyboardCmd ]


renderCat : Model -> Element.Element
renderCat model =
    let
        state =
            case model.cat.state of
                Running ->
                    "running"

                Standing ->
                    "standing"

                Jumping ->
                    "jumping"

        direction =
            case model.cat.direction of
                Left ->
                    "left"

                Right ->
                    "right"
    in
        Element.image 100 100 ("images/cat-" ++ state ++ "-" ++ direction ++ ".gif")


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ renderCat model |> Element.toHtml
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyboardExtraMsg Keyboard.Extra.subscriptions
        ]


main : Program Never
main =
    Html.App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
