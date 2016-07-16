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


compile =
    Css.compile


navbarNamespace : Html.CssHelpers.Namespace String class id msg
navbarNamespace =
    withNamespace "navbar"


css : Css.Stylesheet
css =
    (stylesheet << namespace navbarNamespace.name)
        [ (#) Navbar
            [ backgroundColor V.primaryColor
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
        ]
