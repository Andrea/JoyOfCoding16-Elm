import Collage
import Color
import Element
import Html

main : Html.Html a
main =
    let
        element = Collage.collage 500 500
            [ Collage.rect 100 100
                |> Collage.filled Color.red
            ]
    in
        Html.div [] [ element |> Element.toHtml ]
