module Main exposing (..)

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (..)
import Route
import Topics
import Navigation


type alias Model =
    { route : Route.Model
    , topics : Topics.Model
    }


type Msg
    = TopicsMsg Topics.Msg


init : Maybe Route.Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            Route.init location

        ( topics, tcmd ) =
            Topics.init
    in
        { route = route
        , topics = topics
        }
            ! [ Cmd.map TopicsMsg tcmd
              ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TopicsMsg sub ->
            let
                ( topics, cmd ) =
                    Topics.update sub model.topics
            in
                { model | topics = topics } ! [ Cmd.map TopicsMsg cmd ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    let
        link =
            \page caption -> Route.navItem model.route page caption

        body =
            case model.route of
                Just (Route.Topics) ->
                    App.map TopicsMsg <| Topics.view model.topics

                Just (Route.Home) ->
                    text "home"

                Nothing ->
                    Route.notfound
    in
        div []
            [ navigationView model
            , body
            ]


navigationView : Model -> Html Msg
navigationView model =
    nav []
        [ ul []
            [ li [] [ a [ href (Route.urlFor Route.Home) ] [ text "Home" ] ]
            , li [] [ a [ href (Route.urlFor Route.Topics) ] [ text "Topics" ] ]
            ]
        ]


updateRoute : Maybe Route.Location -> Model -> ( Model, Cmd Msg )
updateRoute route model =
    { model | route = route } ! []


main : Program Never
main =
    Navigation.program (Navigation.makeParser Route.locFor)
        { init = init
        , update = update
        , urlUpdate = updateRoute
        , view = view
        , subscriptions = subscriptions
        }
