module Main exposing (..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (..)
import About
import Route
import Navigation
import Topic
import Helpers


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
            , navigationView model
            , body
            ]


navigationView : Model -> Html Msg
navigationView model =
    let
        linkListItem linkData =
            li [] [ link model.route linkData ]
    in
        nav []
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
