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
        -- compiled =
        --     compile css
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
              --, node "style" [ type' "text/css" ] [ text compiled.css ]
            , navigationView model
            , body
            ]


navbarNamespace : Html.CssHelpers.Namespace name class id msg
navbarNamespace =
    withNamespace "navbar"


css : Css.Stylesheet
css =
    -- We'll start out by producing a stylesheet.  The stylesheet function takes a
    -- list of snippets.  By default it won't namespace them.  We'll apply our
    -- namespace function, which takes a namespace string and a list of snippets
    -- and produces a list of snippets, namespaced.
    (stylesheet << namespace navbarNamespace.name)
        -- then we give the argument to this function composition, which is a list of
        -- snippets.
        [ (#) Navbar
            [ padding (em 1)
            , backgroundColor (rgb 30 30 30)
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
