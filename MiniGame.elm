module MiniGame exposing (..)

{-| Cut down game, with level and basic collision detection

Main character is an exciting box
-}

import Collage
import Collision
import Color
import Element
import Html
import Html.App
import Keyboard.Extra
import Map


type alias Cat =
    { x : Float, y : Float }


type alias Model =
    { cat : Cat
    , map : Map.Map
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
            { cat = Cat 0 0
            , map = Map.init
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

                newX =
                    cat.x + toFloat arrows.x * 10

                newY =
                    cat.y + toFloat arrows.y * 10

                _ =
                    Debug.log "old -> new" ( ( cat.x, cat.y ), ( newX, newY ) )

                collisionX =
                    Collision.checkCollision model.map ( newX, cat.y )

                collisionY =
                    Collision.checkCollision model.map ( cat.x, newY )

                newCat =
                    case ( collisionX, collisionY ) of
                        ( Nothing, Nothing ) ->
                            { cat | x = newX, y = newY }

                        ( Just _, Nothing ) ->
                            { cat | y = newY }

                        ( Nothing, Just _ ) ->
                            { cat | x = newX }

                        _ ->
                            cat
            in
                { model | cat = newCat, keyboardModel = keyboardModel } ! [ Cmd.map KeyboardExtraMsg keyboardCmd ]


renderCat : Int -> Int -> Model -> Element.Element
renderCat levelWidth levelHeight model =
    let
        element =
            Collage.collage 100
                100
                [ Collage.rect 100 100
                    |> Collage.filled Color.red
                ]
    in
        Element.container levelWidth
            levelHeight
            (Element.bottomLeftAt (Element.absolute (floor model.cat.x))
                (Element.absolute (floor model.cat.y))
            )
            element


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
    Html.App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
