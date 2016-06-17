import Collage exposing (..)
import Color
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

type alias Model =
    { x : Float
    , y : Float
    , direction : Direction
    , velocityX: Float
    , velocityY : Float
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
            { x = 0 
            , y = 0 
            , direction = Right
            , velocityX = 0 
            , velocityY = 0            
            , windowSize = Window.Size 0 0
            , keyboardModel = keyboardModel
            }

        cmd =
            Cmd.batch
                -- Normally We'd have to handle success and failure cases for the task, 
                -- but here we can use performFailproof as we know this will never fail.
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
              _ -> model.direction
  in
       { model
          | keyboardModel = keyboardModel
          , direction = direction
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

walk : Model -> Model
walk model =
  let    
    walkMulti = 300
    keyz = Keyboard.Extra.arrows model.keyboardModel
    velX =  (toFloat keyz.x) * walkMulti
    dir  = case Keyboard.Extra.arrowsDirection model.keyboardModel of
               Keyboard.Extra.West -> Left
               Keyboard.Extra.East -> Right
               _ -> model.direction                   
  in
    { model |
         velocityY = velX
       , direction = dir       
    }

view : Model -> Html Msg
view model =
    div [] [ Collage.collage 500 500 
        -- Hint: change this so that instead of a box, we use an image (from Element)
        -- path is "assets/obj_box001.png"
        
        --[  Collage.rect 100 100
        --        |> Collage.filled Color.red 
        --]
          
            [ image 70 70 "/assets/obj_box001.png"
                  |> toForm
                  |> move (model.x, model.y)
            ]

          -- hint : image returns an element, you can convert it to a form with
          -- Collage.toForm, why should you do that?
          -- Hint: We know that the model is updated in update, so x and y change
          -- Collage has a nice function called move that can be used to move
          --  a form, maybe you should use it
          --  the signature for move is : 
          --   (Float, Float) -> Collage.form -> Collage.form
        |> Element.toHtml ]

renderGame : Model -> Html Msg
renderGame model =
    div []
        [ collage  640 480
            [ image 70 70 "/assets/obj_box001.png"
                  |> toForm
                  |> move (model.x, model.y)
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
