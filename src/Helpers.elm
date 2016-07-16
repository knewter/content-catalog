module Helpers exposing (link)

import Route
import Html exposing (Html, a, text)
import Html.Attributes exposing (href, classList)
import Styles


link : Bool -> ( Route.Location, String ) -> Html msg
link isActive ( loc, label ) =
    let
        { classList } =
            Styles.navbarNamespace
    in
        a
            [ href <| Route.urlFor loc
            , classList [ ( Styles.Active, isActive ) ]
            ]
            [ text label ]
