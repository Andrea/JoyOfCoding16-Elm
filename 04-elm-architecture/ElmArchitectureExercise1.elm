{-| Change the Int message to a nicer string
-}

import Html
import Html.App


type alias Model =
    -- First change this type to a String and compile, and see what happens
    { message : Int }


type Msg
    = Nothing

model : Model
model =
    -- Next change this to a nice message :)
    { message = 0 }


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html.Html Msg
view model =
    -- Hint: You don't need the toString any more if you have a string message
    -- But you do need the Html.text :)
    Html.h1 [] [ Html.text (toString model.message) ]


main : Program Never
main =
    Html.App.beginnerProgram
        { model = model
        , update = update
        , view = view
        }
