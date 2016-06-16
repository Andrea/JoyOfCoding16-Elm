import Collage exposing (..)
import Color exposing (..)
import Element exposing (..)
import Html exposing (Html, div, text, p, img)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick)
import Html.App as App
import Text

type alias Model =
    { phase : Game
    }

type Game
    = MenuPhase
    | GamePhase
    | GameOverPhase

type Msg
    = Play
    | GameOver

init : ( Model, Cmd Msg )
init =
    let
        model =
          { phase = MenuPhase
            }
        cmd =
            Cmd.none
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

view : Model -> Html Msg
view model =
    case model.phase of
        GamePhase ->
            div []
                [ 
                -- Hint: this is a List of divs that will be stacked, you can add 
                --   as many as you need.
                -- Hint: you can call functions that return Html msg
                -- Hint: note the two ways to render and style text 
                  (div [] [ txt (Text.height 40) "The Joy of cats" ])
                --, (div [] [ Html.text "==> render the game here <==" ])
                , (div [] [renderGame model] )
                , (div [] [ Html.text "Footer here | (c) Cats united of the world ... meow" ])
                ]
        MenuPhase ->
            div [] [ ( renderMenu model ) ]

        GameOverPhase ->
            div [] [ ( renderGameOver model ) ]

renderGame : Model -> Html Msg
renderGame model =
    let
        imagePath =
            "/assets/cat-running-left.gif"
    in
        div []
                [ collage  640 480
                    [ image 70 70 imagePath
                          |> toForm
                    ]
                    |> Element.toHtml 
              , Html.button 
                    [ onClick GameOver, attribute "style" menuButtonStyle ] 
                    [ Html.text "GameOver"]
            ]


renderMenu : Model -> Html Msg
renderMenu model =
    div [ attribute "style" centeredDivStyle ]
        [ p [ attribute "style" titleStyle ] [ Html.text "The joy of cats!" ]
        , img [ attribute "src" "/assets/splash.jpg"
              , attribute "width" "300px"
              , attribute "height" "300px"
              ] []
        , Html.button [ onClick Play, attribute "style" menuButtonStyle ] [ Html.text "Play"]
        ]

renderGameOver : Model -> Html Msg
renderGameOver model =
    div [ attribute "style" centeredDivStyle ]
        [ p [ attribute "style" titleStyle ] [ Html.text "GAME OVER!" ]
        , img [ attribute "src" "/assets/gameover.jpg"
              , attribute "width" "300px"
              , attribute "height" "300px"
              ] []
        ]

titleStyle : String
titleStyle = "font-size: 60px; width: 300px; font-style:italic; font-weight:bold; font-family:Arial; color: #3366ff; text-shadow:0px 1px 0px #0033cc; text-align: center; margin-left: auto; margin-right: auto;"

menuButtonStyle : String
menuButtonStyle = "width: 300px; background-color:#44c767;-moz-border-radius:28px;-webkit-border-radius:28px;border-radius:28\
px;border:1px solid #18ab29;display:inline-block;cursor:pointer;color:#ffffff;font-family:Arial;font-size:17px;font-weight:bold;font-style:italic;padding:16px 31px;text-decoration:none;text-shadow:0px 1px 0px #2f6627"

centeredDivStyle : String
centeredDivStyle = "width: 300px; margin-left: auto; margin-right: auto;"

txt : (Text.Text -> Text.Text) -> String -> Html string
txt f string =
    let 
        textGreen =  rgb 160 20 190
    in            
        Text.fromString string
            |> Text.color textGreen
            |> Text.monospace
            |> f
            |> leftAligned
            |> toHtml

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }