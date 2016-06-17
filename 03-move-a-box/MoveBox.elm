import Collage exposing (..)
import Element exposing (..)
import Html exposing (Html, div, text, p, img)
import Html.App as App
import Keyboard.Extra
import Task.Extra
import Time exposing (..)
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

type alias Model =
    { cat : Cat
    , playerScore : Float
    , windowSize : Window.Size
    , keyboardModel : Keyboard.Extra.Model
    }

type Msg
    = WindowSize Window.Size
    | KeyboardExtraMsg Keyboard.Extra.Msg
    | Tick Time.Time
    | Play
    | GameOver

init : ( Model, Cmd Msg )
init =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.Extra.init

        model =
            -- For brevity use the model constructors instead of {} for Cat and Window.Size
            { cat = Cat 0 0 Right 0 0
            , playerScore = 0
            , windowSize = Window.Size 0 0
            , keyboardModel = keyboardModel
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
            (  model,
             Cmd.none )

        GameOver ->
            (  model
            , Cmd.none )

        WindowSize newSize ->
            ( { model | windowSize = newSize }, Cmd.none )

        KeyboardExtraMsg keyMsg ->
            (updateKeys keyMsg model, Cmd.none)

        Tick delta ->
              (step  model, Cmd.none)


step :  Model -> Model
step  model =
  model
    |> walk

walkMulti : Float
walkMulti = 300

walk : Model -> Model
walk model =
  let
    cat = model.cat
    keyz = Keyboard.Extra.arrows model.keyboardModel
    newCat = {cat |
                velocityX =  (toFloat keyz.x) * walkMulti
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
    div []
        [ (div [] [ renderGame model ])
        ]

renderGame : Model -> Html Msg
renderGame model =
    let
        cat = model.cat
    in
        div []
            [ collage  640 480
                [ image 70 70 "/assets/cat-running-right.gif"
                      |> toForm
                      |> move (cat.x, cat.y)
                ]
                |> Element.toHtml
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyboardExtraMsg Keyboard.Extra.subscriptions
        ]


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
