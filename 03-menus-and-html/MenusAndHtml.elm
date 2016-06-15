module HelloWebWorld exposing (..)

import AnimationFrame
import Collage exposing (..)
import Color exposing (..)
import Element exposing (..)
import Html exposing (Html, div, text, p, img)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick)
import Html.App as App
import Keyboard.Extra
import Task.Extra
import Text
import Time exposing (..)
import Window

type alias Model =
    { playerScore : Float
    , windowSize : Window.Size
    , phase : GamePhase
    }

type GamePhase -- it needed to include '-Phase' because having Main.Menu produces odd errors
    = MenuPhase
    | GamePhase
    | GameOverPhase

type Msg
    = WindowSize Window.Size
    | KeyboardExtraMsg Keyboard.Extra.Msg
    | Tick Time.Time
    | Play
    | GameOver

init : ( Model, Cmd Msg )
init =
    let
        model =
          { playerScore = 0
          , windowSize = Window.Size 0 0
          ,phase = MenuPhase
            }
        cmd =
            Cmd.batch
                -- Normally We'd have to handle success and failure cases for the task, but here
                -- we can use performFailproof as we know this will never fail.
                [ Window.size |> Task.Extra.performFailproof WindowSize
                -- , Cmd.map KeyboardExtraMsg keyboardCmd
                ]
    in
        ( model, cmd )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play ->
            ( { model | phase = GamePhase }
            , Cmd.none )

        GameOver ->
            ( { model | phase = GameOverPhase }
            , Cmd.none )

        WindowSize newSize ->
            ( { model | windowSize = newSize }, Cmd.none )

        KeyboardExtraMsg keyMsg ->
             ( model, Cmd.none )

        Tick delta ->
              (step delta model, Cmd.none)

step : Float -> Model -> Model
step delta model =
  model

view : Model -> Html Msg
view model =
    case model.phase of
        GamePhase ->
            div []
                [ (div [] [ txt (Text.height 40) "The Joy of cats" ])
                , (div [] [ Html.text ("Score " ++ ((round model.playerScore) |> toString)) ])
                , (div [] [ renderGame model ])
                , (div [] [ Html.text "Footer here | (c) Cats united of the world" ])
                ]
        MenuPhase ->
            div [] [ ( renderMenu model ) ]

        GameOverPhase ->
            div [] [ ( renderGameOver model ) ]

renderMenu : Model -> Html Msg
renderMenu model =
    div [ attribute "style" centeredDivStyle ]
        [ p [ attribute "style" titleStyle ] [ Html.text "The joy of cats!" ]
        , img [ attribute "src" "../images/splash.jpg"
              , attribute "width" "300px"
              , attribute "height" "300px"
              ] []
        , Html.button [ onClick Play, attribute "style" menuButtonStyle ] [ Html.text "Play"]
        ]

renderGameOver : Model -> Html Msg
renderGameOver model =
    div [ attribute "style" centeredDivStyle ]
        [ p [ attribute "style" titleStyle ] [ Html.text "GAME OVER!" ]
        , img [ attribute "src" "images/gameover.jpg"
              , attribute "width" "300px"
              , attribute "height" "300px"
              ] []
        , p [] [Html.text ("Your score is " ++ (toString model.playerScore))]
        ]

titleStyle : String
titleStyle = "font-size: 60px; width: 300px; font-style:italic; font-weight:bold; font-family:Arial; color: #3366ff; text-shadow:0px 1px 0px #0033cc; text-align: center; margin-left: auto; margin-right: auto;"

menuButtonStyle : String
menuButtonStyle = "width: 300px; background-color:#44c767;-moz-border-radius:28px;-webkit-border-radius:28px;border-radius:28\
px;border:1px solid #18ab29;display:inline-block;cursor:pointer;color:#ffffff;font-family:Arial;font-size:17px;font-weight:bold;font-style:italic;padding:16px 31px;text-decoration:none;text-shadow:0px 1px 0px #2f6627"

centeredDivStyle : String
centeredDivStyle = "width: 300px; margin-left: auto; margin-right: auto;"

renderGame : Model -> Html Msg
renderGame model =
    let
        imagePath =
            "../images/cat-running-left.gif"

        _ = Debug.log "Path " imagePath
    in
        div []
            [ collage  640 480
                [ image 70 70 imagePath
                      |> toForm
                ]
                |> Element.toHtml
            ]

textGreen : Color
textGreen =
    rgb 160 20 190

txt : (Text.Text -> Text.Text) -> String -> Html string
txt f string =
    Text.fromString string
        |> Text.color textGreen
        |> Text.monospace
        |> f
        |> leftAligned
        |> toHtml

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes WindowSize
        , Sub.map KeyboardExtraMsg Keyboard.Extra.subscriptions
        , AnimationFrame.diffs (Tick << inSeconds)
        ]

main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
