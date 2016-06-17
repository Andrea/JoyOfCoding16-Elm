import Collage
import Color
import Element
import Html

main : Html.Html a
main =
    let
        element1 = Collage.collage 100 100
            [ Collage.rect 100 100
                |> Collage.filled Color.red
            ]
            |> Element.container 800 600
                (Element.bottomLeftAt
                    (Element.absolute (floor 10))
                    (Element.absolute (floor 15))
                )
        element2 = Collage.collage 100 100
            [ Element.image 100 100 ("/assets/obj_box001.png")
                |> Collage.toForm
            ]
            |> Element.container 800 600
                (Element.bottomLeftAt
                    (Element.absolute (floor 120))
                    (Element.absolute (floor 150))
                )
    in
        Html.div [] [ Element.layers [element1, element2] |> Element.toHtml ]
