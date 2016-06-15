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
    { x : Int
    , y : Int
    , width : Int
    , height : Int
    }


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
            { cat = Cat 0 0 100 100
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

                cat =
                    model.cat

                arrows =
                    Keyboard.Extra.arrows keyboardModel

                newX =
                    cat.x + arrows.x * 10

                newY =
                    cat.y + arrows.y * 10

                (newCat, _) =
                    { cat | x = newX, y = newY }
                        |> Collision.updateWithCollisionCheck model.map cat
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
            (Element.bottomLeftAt (Element.absolute model.cat.x)
                (Element.absolute model.cat.y)
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
                [ Element.tiledImage w h "/assets/wall.png"
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
