module Exercise0201 exposing (..)

{-| Fill in the blanks
-}

import Html
import Html.App


type alias Model =
    { message :  }


type Msg
    = Nothing


model =
    { message = "Hello!" }


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html.Html Msg
view model =
    Html.h1 [] [ Html.text model. ]


main : Program Never
main =
    Html.App.beginnerProgram
        { model = model
        , update = update
        , view = view
        }
