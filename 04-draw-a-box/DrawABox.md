# Draw a Box

## Elm Graphics

The Graphics library has two main parts:

1. Element
2. Collage

(Sidenote: originally Elm was a JS graphics library.)

## Collage

Collage is used to draw primitives (boxes, polygons, etc).

To create a 100x100 red box:

```elm
Collage.rect 100 100
    |> Collage.filled Color.red
```

You can draw many primitives, transform them and then render via Collage.collage.

Typically Collage draws using a `<canvas>`.

## Element

Element is used to interact more directly with HTML. It tends to use divs and CSS transforms.

```elm
Html.div [] [ Element.image 200 200 "cat.png" |> Element.toHtml ]
```

## Combining

You normally render a Collage via an Element.

```elm
let
    element = Collage.collage 500 500
        [ Collage.rect 100 100
            |> Collage.filled Color.red
        ]
in
    Html.div [] [ element |> Element.toHtml ]
```

Places a 100x100 red box in the centre of a 500x500 div.
