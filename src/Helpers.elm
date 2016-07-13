module Helpers exposing (link)

import Route
import Html exposing (Html, a, text)
import Html.Attributes exposing (href, classList)


link : Bool -> ( Route.Location, String ) -> Html msg
link isActive ( loc, label ) =
    a
        [ href <| Route.urlFor loc
        , classList [ ( "active", isActive ) ]
        ]
        [ text label ]
