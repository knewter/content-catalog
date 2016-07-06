module Helpers exposing (link)

import Route
import Html exposing (Html, a, text)
import Html.Attributes exposing (href)


link : ( Route.Location, String ) -> Html msg
link ( loc, label ) =
    a [ href <| Route.urlFor loc ] [ text label ]
