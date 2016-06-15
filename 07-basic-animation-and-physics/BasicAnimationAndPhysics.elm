module HelloCatWorld exposing (..)

{-| Gluing all the bits together :)
-}

import Element
import Html
import Html.App

type alias Model = { cat : String}

type Msg = Nothing -- TODO:  get rid of this?

view : Model -> Html.Html Msg
view model =
        Html.div []
            [ Element.layers
                [ Element.tiledImage 150 160 model.cat
                ]
                |> Element.toHtml
            ]

init :  Model
init =
    let
        model =
            { cat = "images/cat-standing-left.gif"
            }
    in
        model

update : Msg -> Model -> Model
update msg model =    
      model

main : Program Never
main =
    Html.App.beginnerProgram
        { model = init
        , update = update
        , view = view
        }
