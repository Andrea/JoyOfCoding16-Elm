import Html
import Html.App

type alias Model =
    { message : String }

type Msg = Nothing

init : (Model, Cmd Msg)
init =
    ({ message = "Hello World!" }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    (model, Cmd.none)
    -- Alternative shorthand:
    -- model ! []

view : Model -> Html.Html Msg
view model =
    Html.h1 [] [ Html.text model.message ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program Never
main =
    Html.App.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
    }
