module Styles exposing (css, navbarNamespace, compile, CssIds(..), CssClasses(..))

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Css.Elements
import Html.CssHelpers exposing (withNamespace)
import Styles.Variables as V


type CssIds
    = Navbar


type CssClasses
    = Active
    | Container
    | CardList


compile =
    Css.compile


navbarNamespace : Html.CssHelpers.Namespace String class id msg
navbarNamespace =
    withNamespace "navbar"


css : Css.Stylesheet
css =
    (stylesheet << namespace navbarNamespace.name)
        [ Css.Elements.body
            [ fontFamily sansSerif
            ]
        , (#) Navbar
            [ backgroundColor V.primaryColor
            , property "box-shadow" "0 0 4px rgba(0, 0, 0, 0.5)"
            , descendants
                [ Css.Elements.ul
                    [ margin (Css.px 0)
                    , padding (Css.px 0)
                    ]
                , Css.Elements.li
                    [ display inlineBlock
                    , children
                        [ Css.Elements.a
                            [ display inlineBlock
                            , V.defaultPadding
                            , textDecoration none
                            , color V.primaryTextColor
                            , textTransform uppercase
                            , backgroundColor (rgba 0 0 0 0.1)
                            , (withClass Active)
                                [ fontWeight bold
                                , backgroundColor (rgba 0 0 0 0.3)
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , (.) Container
            [ V.defaultPadding
            ]
        , (.) CardList
            [ margin zero
            , padding zero
            , children
                [ Css.Elements.li
                    [ display inlineBlock
                    , property "list-style-type" "none"
                    , backgroundColor V.primaryColor
                    , children
                        [ Css.Elements.a
                            [ display inlineBlock
                            , V.defaultPadding
                            , color <| rgb 255 255 255
                            , textDecoration none
                            , hover
                                [ backgroundColor (rgba 0 0 0 0.1)
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
