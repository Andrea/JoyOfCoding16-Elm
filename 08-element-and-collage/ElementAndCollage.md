# More on Elements and Collages

---

## Positioning

- Collage has its origin (0,0) in the centre of the screen.
- Element follows the normal HTML placement rules

---

## Putting the Origin in the Bottom Left

---
```elm
Element.container width height
    (Element.bottomLeftAt
        (Element.absolute (floor model.x))
        (Element.absolute (floor model.y))
    )
    myElement
```

```html
<div style="...; width: 800px; height: 600px;">
  <div style="...; width: 100px; height: 100px; left: 10px; bottom: 15px;">
    <canvas style="...; width: 100px; height: 100px; ..." width="200" height="200"></canvas>
  </div>
</div>
```

---

### Yes, even for img

---
```elm
element =
    Collage.collage 100 100
        [ Element.image 100 100 ("images/obj_box001.png")
            |> Collage.toForm
        ]
        |> Element.container levelWidth levelHeight
            (Element.bottomLeftAt
                ( Element.absolute model.x )
                ( Element.absolute 0 )
            )
```


```html
<div style="...; width: 800px; height: 600px;">
  <div style="...; width: 100px; height: 100px; left: 0; bottom: 0;">
      <img style="...; width: 100px; height: 100px; ...; 
        opacity: 1; transform: matrix(1, 0, 0, 1, 0, 0);" 
        src="../images/obj_box001.png" name="../images/obj_box001.png">
  </div>
</div>
```

^ Note the use of CSS transforms, many transformations are handled via CSS

---
## Layering Content

You can render layers separately, which makes it much easier to combine parts of your app.

```elm
Element.layers
    [ Element.tiledImage w h "images/Wall.png"  -- Background
    , Map.renderMap model.map  -- The map (with boxes in our examples)
    , renderCat w h model
    , kid w h model
    ]
    |> Element.toHtml
```
---
## Example

See ElementAndCollage.elm
