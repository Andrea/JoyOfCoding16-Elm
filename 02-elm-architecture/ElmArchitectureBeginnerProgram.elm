module ElmArchitectureBeginnerProgram exposing (..)

import Html
import Html.App


type alias Model =
    { message : String }


type Msg
    = Nothing


model : Model
model =
    { message = "Hello World!" }


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html.Html Msg
view model =
    Html.h1 [] [ Html.text model.message ]


main : Program Never
main =
    Html.App.beginnerProgram { model = model, update = update, view = view }
