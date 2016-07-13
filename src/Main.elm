module Main exposing (..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (..)
import About
import Route
import Navigation
import Topic
import Helpers


-- We'll import the Css module and expose everything

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Css.Elements


-- We will also import Html.CssHelpers, exposing the `withNamespace` function

import Html.CssHelpers exposing (withNamespace)


type CssClasses
    = Navbar


type alias Model =
    { route : Route.Model
    }


type Msg
    = NoOp


init : Maybe Route.Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            Route.init location
    in
        { route = route
        }
            ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    let
        -- First, we'll compile our stylesheet to produce the string of css we want to
        -- add to the browser.
        compiled =
            compile css

        body =
            case model.route of
                Just (Route.Home) ->
                    About.view

                Just (Route.Topics) ->
                    Topic.view Topic.fakeTopics

                Just (Route.Topic slug) ->
                    Topic.viewTopic slug Topic.fakeTopics

                Nothing ->
                    text "Not found!"
    in
        div []
            [ node "style" [ type' "text/css" ] [ text styles ]
              -- Then we'll add a style node that contains that string
            , node "style" [ type' "text/css" ] [ text compiled.css ]
            , navigationView model
            , body
            ]


navbarNamespace : Html.CssHelpers.Namespace String class id msg
navbarNamespace =
    withNamespace "navbar"


css : Css.Stylesheet
css =
    (stylesheet << namespace navbarNamespace.name)
        [ (#) Navbar
            [ padding (Css.em 1)
            , backgroundColor (rgb 230 230 230)
            , descendants
                [ Css.Elements.li
                    [ display inlineBlock
                    , marginRight (Css.em 1)
                    ]
                ]
            ]
        ]


navigationView : Model -> Html Msg
navigationView model =
    let
        { id } =
            navbarNamespace

        linkListItem linkData =
            li [] [ link model.route linkData ]
    in
        nav [ id Navbar ]
            [ ul []
                (List.map linkListItem links)
            ]


links : List ( Route.Location, String )
links =
    [ ( Route.Home, "Home" )
    , ( Route.Topics, "Topics" )
    ]


main : Program Never
main =
    Navigation.program (Navigation.makeParser Route.locFor)
        { init = init
        , update = update
        , urlUpdate = updateRoute
        , subscriptions = subscriptions
        , view = view
        }


updateRoute : Maybe Route.Location -> Model -> ( Model, Cmd Msg )
updateRoute route model =
    { model | route = route } ! []


styles : String
styles =
    "a.active { font-weight: bold; }"


link : Maybe Route.Location -> ( Route.Location, String ) -> Html msg
link currentRoute linkData =
    let
        ( loc, _ ) =
            linkData

        isActive =
            case currentRoute of
                Nothing ->
                    False

                Just route ->
                    case route of
                        Route.Topic _ ->
                            loc == Route.Topics || loc == route

                        _ ->
                            route == loc
    in
        Helpers.link isActive linkData
