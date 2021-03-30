// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


// paste in doc ready for video player from js
// let videoPlayer=videojs(document.getElementById('my-video'),{
//     controls: true,
//     playbackRates: [0.5, 1, 1.5, 2],
//     autoplay: false,
//     fluid: true,
//     preload: false,
//     liveui: true,
//     responsive: true,
//     loop: false
// })
// videoPlayer.addClass('video-js')
// videoPlayer.addClass('vjs-big-play-centered')

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import "../stylesheets/application"
import "@fortawesome/fontawesome-free/js/all";


Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("trix")
require("@rails/actiontext")

require("chartkick")
require("chart.js")

// require("jquery")
require("jquery-ui")

require("selectize")
// require("jquery-ui-dist/jquery-ui")

import '../trix-editor-override'

import videojs from 'video.js'
import 'video.js/dist/video-js.css'


$( function() {
    $( ".sortable" ).sortable();
    $( ".sortable" ).disableSelection();
    $('.datepicker').datepicker();
});

$(document).on('turbolinks:load', function(){
    $('.lesson_sortable').sortable({
        cursor: "grabbing",
        cursorAt: {left:10},
        placeholder: "ui-state-highlight",
        update: function(e,ui){
            let item = ui.item;
            let item_data = item.data();
            let params = {_method: 'put'};
            params[item_data.modelName] = { row_order_position: item.index()} 
            $.ajax({
                type: 'POST',
                url: item_data.updateUrl,
                dataType: 'json',
                data:params
            });
        }, 
        stop: function(e, ui){
            console.log("stop called when finishing sort of cards")
        }
    });

    $("video").bind("contextmenu",function(){
        return false;
    });

    if($('.selectize')){
        $('.selectize').selectize({
            sortField: 'text'
        });
    }
    
});