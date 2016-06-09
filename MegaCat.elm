module MegaCat exposing (..)

{-| Gluing all the bits together :)
-}

import AnimationFrame
import Collage
import Collision
import Element
import Html
import Html.App
import Keyboard.Extra
import Map
import Time


type Direction
    = None
    | Right
    | Left


type alias Cat =
    { x : Float
    , y : Float
    , dir : Direction
    , velocityX : Float
    , velocityY : Float
    }


type alias Model =
    { cat : Cat
    , map : Map.Map
    , keyboardModel : Keyboard.Extra.Model
    , kidPositionX : Int
    , elapsedGameTime : Float
    }


type Msg
    = KeyboardExtraMsg Keyboard.Extra.Msg
    | Tick Time.Time


init : ( Model, Cmd Msg )
init =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.Extra.init

        model =
            { cat = Cat 0 0 Right 0 0
            , map = Map.init
            , keyboardModel = keyboardModel
            , kidPositionX = 0
            , elapsedGameTime = 0
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
            in
                { model | keyboardModel = keyboardModel } ! [ Cmd.map KeyboardExtraMsg keyboardCmd ]

        Tick delta ->
            ( step delta model, Cmd.none )


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

updateElapsedGameTime : Float -> Model -> Model
updateElapsedGameTime delta model =
    let
      gameTime = model.elapsedGameTime + delta
      _ = Debug.log "elapsed tiem" gameTime
    in
      { model
          | elapsedGameTime = gameTime
      }
updateKid : Float -> Model -> Model
updateKid delta model =
  let
    newx = if ( model.elapsedGameTime > 5 ) then model.kidPositionX +  1 else model.kidPositionX
  in
      { model
          | kidPositionX = newx
      }

gravity : Float -> Model -> Model
gravity delta model =
    let
        cat =
            model.cat

        newCat =
            { cat
                | velocityY =
                    if cat.y > 0 then
                        cat.velocityY - delta * 20
                    else
                        0
            }
    in
        { model
            | cat = newCat
        }


physics : Float -> Model -> Model
physics delta model =
    let
        cat =
            model.cat

        newCat =
            { cat
                | x = cat.x + delta * cat.velocityX
                , y = max 0 (cat.y + delta * cat.velocityY * 35)
            }
    in
        { model
            | cat = newCat
        }


jump : Model -> Model
jump model =
    let
        cat =
            model.cat

        newCat =
            { cat
                | velocityY = 15.0
            }

        keyz =
            Keyboard.Extra.isPressed Keyboard.Extra.Space model.keyboardModel
    in
        if keyz && cat.velocityY == 0 then
            { model | cat = newCat }
        else
            model


walkMulti : Float
walkMulti =
    300


walk : Model -> Model
walk model =
    let
        cat =
            model.cat
        keyz =
            Keyboard.Extra.arrows model.keyboardModel
        newCat =
            { cat
                | velocityX = (toFloat keyz.x) * walkMulti
                , dir =
                    case Keyboard.Extra.arrowsDirection model.keyboardModel of
                        Keyboard.Extra.West ->
                            Left
                        Keyboard.Extra.East ->
                            Right
                        _ ->
                            model.cat.dir
            }
    in
        { model
            | cat = newCat
        }


collision : Model -> Model -> Model
collision oldModel newModel =
    let
        cat =
            newModel.cat

        ( oldX, oldY ) =
            ( oldModel.cat.x, oldModel.cat.y )

        ( newX, newY ) =
            ( newModel.cat.x, newModel.cat.y )

        collisionX =
            Collision.checkCollision newModel.map ( newX, oldY )

        collisionY =
            Collision.checkCollision newModel.map ( oldX, newY )

        newCat =
            case ( collisionX, collisionY ) of
                ( Nothing, Nothing ) ->
                    { cat | x = newX, y = newY }

                ( Just _, Nothing ) ->
                    { cat | x = oldX, y = newY }

                ( Nothing, Just _ ) ->
                    { cat | x = newX, y = oldY }

                _ ->
                    cat
    in
        { newModel | cat = newCat }


renderCat : Int -> Int -> Model -> Element.Element
renderCat levelWidth levelHeight model =
    let
        direction =
            case model.cat.dir of
                Right ->
                    "right"

                Left ->
                    "left"

                None ->
                    "right"

        element =
            Collage.collage 100
                100
                [ Element.image 100 100 ("images/cat-running-" ++ direction ++ ".gif")
                    |> Collage.toForm
                ]
    in
        Element.container levelWidth
            levelHeight
            (Element.bottomLeftAt (Element.absolute (floor model.cat.x))
                (Element.absolute (floor model.cat.y))
            )
            element

kid : Int -> Int -> Model -> Element.Element
kid levelWidth levelHeight model =
  let
      element =
          Collage.collage 50
              50
              [ Element.image 100 100 ("images/obj_box001.png")
                  |> Collage.toForm
              ]
      _ = Debug.log "bla " model.kidPositionX
  in
    Element.container levelWidth levelHeight (Element.bottomLeftAt ( Element.absolute model.kidPositionX ) ( Element.absolute 0 )) element

view : Model -> Html.Html Msg
view model =
    let
        ( w, h ) =
            Map.mapSize model.map
    in
        Html.div []
            [ Element.layers
                [ Element.tiledImage w h "images/Wall.png"
                , Map.renderMap model.map
                , renderCat w h model
                , kid w h model
                ]
                |> Element.toHtml
            ]


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
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
