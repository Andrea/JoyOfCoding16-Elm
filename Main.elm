module Main exposing (..)

import AnimationFrame
import Char
import Collage exposing (..)
import Color exposing (..)
import Element exposing (..)
import Html exposing (Html, div, text, p, img)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick)
import Html.App as App
import Keyboard
import Keyboard.Extra
import List exposing (map, concat, indexedMap, head, drop)
import Task.Extra
import Text
import Time exposing (..)
import Transform
import Window

type Direction
    = None
    | Right
    | Left

type alias Cat =
    { x : Float
    , y : Float
    , dir : Direction
    , velocityX: Float
    , velocityY : Float
    }

type alias Level =
    {}

type alias Model =
    { cat : Cat
    , level : Level
    , playerScore : Float
    , windowSize : Window.Size
    , keyboardModel : Keyboard.Extra.Model
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

init : ( Model, Cmd Msg )
init =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.Extra.init

        model =
            -- For brevity use the model constructors instead of {} for Cat and Window.Size
            { cat = Cat 0 0 Right 0 0
            , level = Level
            , playerScore = 0
            , windowSize = Window.Size 0 0
            , keyboardModel = keyboardModel
            , phase = MenuPhase
            }

        cmd =
            Cmd.batch
                -- Normally We'd have to handle success and failure cases for the task, but here
                -- we can use performFailproof as we know this will never fail.
                [ Window.size |> Task.Extra.performFailproof WindowSize
                , Cmd.map KeyboardExtraMsg keyboardCmd
                ]
    in
        ( model, cmd )

updateKeys : Keyboard.Extra.Msg -> Model -> Model
updateKeys keyMsg model=
  let
      ( keyboardModel, keyboardCmd ) =
          Keyboard.Extra.update keyMsg model.keyboardModel
      direction =
          case Keyboard.Extra.arrowsDirection keyboardModel of
              Keyboard.Extra.West -> Left
              Keyboard.Extra.East -> Right
              _ -> model.cat.dir

      cat = model.cat
      newCat =
          { cat | dir = direction }
  in
       { model
          | keyboardModel = keyboardModel
          , cat = newCat
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play ->
            ( { model | phase = GamePhase }
            , Cmd.none )

        WindowSize newSize ->
            ( { model | windowSize = newSize }, Cmd.none )

        KeyboardExtraMsg keyMsg ->
            (updateKeys keyMsg model, Cmd.none)

        Tick delta ->
              (step delta model, Cmd.none)

            --( { model | playerScore = model.playerScore + delta }, Cmd.none )

step : Float -> Model -> Model
step delta model =
  model
    |> gravity delta
--    |> jump
    |> walk
    |> physics delta


gravity : Float -> Model -> Model
gravity dt model =
  let
    cat = model.cat
    newCat = { cat |
                velocityY = if cat.y > 0 then cat.velocityY - dt/40 else 0
             }
  in
  { model |
      cat = newCat
  }


physics : Float -> Model -> Model
physics dt model =
  let
    cat = model.cat
    newCat = { cat |
                x = cat.x + dt * cat.velocityX,
                y = max 0 (cat.y  + dt/10 * cat.velocityY)
             }
  in
    { model |
       cat = newCat
    }

walk : Model -> Model
walk model =
  let
    cat = model.cat
    keyz = Keyboard.Extra.arrows model.keyboardModel
    newCat = {cat |
                velocityX =  (toFloat keyz.x)/5
                , dir =
                         case Keyboard.Extra.arrowsDirection model.keyboardModel of
                             Keyboard.Extra.West -> Left
                             Keyboard.Extra.East -> Right
                             _ -> model.cat.dir
                   }
  in
    { model |
       cat = newCat
    }

view : Model -> Html Msg
view model =
    case model.phase of
        GamePhase ->
            div []
                [ (div [] [ txt (Text.height 50) "The Joy of cats" ])
                , (div [] [ Html.text ("Score " ++ ((round model.playerScore) |> toString)) ])
                , (div [] [ renderGame model ])
                , (div [] [ Html.text "Footer here | (c)Cats united of the world" ])
                ]
        MenuPhase ->
            div [] [ ( renderMenu model ) ]

        GameOverPhase ->
            div [] [ Html.text "GameOver" ]

renderMenu : Model -> Html Msg
renderMenu model =
    div [ attribute "style" "width: 300px; margin-left: auto; margin-right: auto;"]
        [ p [ attribute "style" "font-size: 60px; width: 300px; font-style:italic; font-weight:bold; font-family:Arial; color: #3366ff; text-shadow:0px 1px 0px #0033cc; text-align: center; margin-left: auto; margin-right: auto;" ]
              [ Html.text "CAT RUN!" ]
        , img [ attribute "src" "images/splash.jpg"
              , attribute "width" "300px"
              , attribute "height" "300px"
              ] []
        , Html.button [ onClick Play
                      , attribute "style" "width: 300px; background-color:#44c767;-moz-border-radius:28px;-webkit-border-radius:28px;border-radius:28px;border:1px solid #18ab29;display:inline-block;cursor:pointer;color:#ffffff;font-family:Arial;font-size:17px;font-weight:bold;font-style:italic;padding:16px 31px;text-decoration:none;text-shadow:0px 1px 0px #2f6627"
                      ]
            [ Html.text "Play"]
        ]

renderGame : Model -> Html Msg
renderGame model =
    let
        transformation =
            case model.cat.dir of
                Left ->
                    Transform.identity
                Right ->
                    -- flip it
                    Transform.matrix -1 0 0 1 0 0
                None ->
                  Transform.identity
    in
        div []
            [ Collage.collage 150
                150
                [ Collage.groupTransform transformation
                    [ Element.image 150 150 "animated-kitty.gif" |> Collage.toForm
                    ]
                ]
                |> Element.toHtml
            ]


textGreen : Color
textGreen =
    rgb 160 200 160

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
