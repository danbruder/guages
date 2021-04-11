module Pages.Top exposing (Model, Msg, Params, page)

import Browser.Navigation exposing (Key)
import Css.Global
import Dict exposing (Dict)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src, style, type_, value)
import Html.Styled.Events exposing (..)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Tailwind.Breakpoints exposing (..)
import Tailwind.Utilities exposing (..)
import Task
import Time


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { psi : Float
    , direction : Maybe Direction
    , rateInput : String
    }


type Direction
    = FillUp
    | Drain


init : Url Params -> ( Model, Cmd Msg )
init _ =
    ( { psi = 0
      , direction = Nothing
      , rateInput = "1.2"
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Noop
    | Tick Time.Posix
    | ClickedFillButton
    | ClickedDrainButton
    | ClickedStopButton
    | TypedInRateInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        TypedInRateInput val ->
            ( { model | rateInput = val }, Cmd.none )

        ClickedStopButton ->
            ( { model | direction = Nothing }, Cmd.none )

        ClickedFillButton ->
            ( { model | direction = Just FillUp }, Cmd.none )

        ClickedDrainButton ->
            ( { model | direction = Just Drain }, Cmd.none )

        Tick _ ->
            case ( String.toFloat model.rateInput, model.direction ) of
                ( Just rate, Just FillUp ) ->
                    if model.psi < (800 - rate) then
                        ( { model | psi = model.psi + rate }, Cmd.none )

                    else
                        ( { model | psi = 800 }, Cmd.none )

                ( Just rate, Just Drain ) ->
                    if model.psi > rate then
                        ( { model | psi = model.psi - rate }, Cmd.none )

                    else
                        ( { model | psi = 0 }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 10 Tick



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Top"
    , body =
        [ body model
        ]
    }


body model =
    div []
        [ Css.Global.global globalStyles
        , p
            [ css
                [ flex
                , uppercase
                , text_gray_700
                , text_sm
                , p_3
                , font_bold
                , bg_gray_100
                , border_b
                , border_gray_300
                ]
            ]
            [ text "Gauges By Paul" ]
        , div
            [ css
                [ w_full
                , flex
                , items_center
                , p_4
                , justify_center
                , relative
                ]
            ]
            [ viewGauge model
            , div
                [ css
                    [ absolute
                    , left_0
                    , top_0
                    , m_5
                    ]
                ]
                [ button [ onClick ClickedFillButton, css [ p_3, py_2, bg_gray_200, rounded, mr_2 ] ] [ text "Fill Up" ]
                , button [ onClick ClickedDrainButton, css [ p_3, py_2, bg_gray_200, rounded, mr_2 ] ] [ text "Drain" ]
                , button [ onClick ClickedStopButton, css [ p_3, py_2, bg_gray_200, rounded ] ] [ text "Stop" ]
                , div [ css [ text_3xl, p_4 ] ] [ text (String.fromFloat model.psi) ]
                , div []
                    [ div [ css [ font_bold ] ] [ text "Rate" ]
                    , input
                        [ css [ border, rounded, p_5 ]
                        , type_ "number"
                        , onInput TypedInRateInput
                        , value model.rateInput
                        ]
                        []
                    ]
                ]
            ]
        ]


viewGauge model =
    div [ style "width" "700px" ]
        [ div [ css [ absolute, w_full ], style "width" "700px" ] [ img [ src "/img/gauge.png" ] [] ]
        , div [ css [ absolute, w_full, flex, justify_center, items_center ], style "top" "202px", style "left" "0px" ]
            [ div
                [ style "transform" ("rotate(" ++ String.fromFloat (psiToDeg model.psi) ++ "deg)")
                , style "width" "55px"
                ]
                [ img [ src "/img/arrow.png" ] [] ]
            ]
        ]


psiToDeg : Float -> Float
psiToDeg psi =
    let
        res =
            if psi < 0 then
                0

            else if psi > 800 then
                800

            else
                psi
    in
    (res * 0.3) - 120
