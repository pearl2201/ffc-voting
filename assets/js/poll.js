import {
  Socket
} from "phoenix"

import $ from 'jquery';



$(document).ready(function () {
  let socket = new Socket("/poll-socket", {
    params: {
      token: token
    }
  })

  socket.connect()
  console.log("connect socket");
  let channel = socket.channel('poll:' + poll_id, {})
  channel.join()
    .receive("ok", resp => {
      console.log("Joined successfully", resp)
    })
    .receive("new_option", resp => {
      console.log("new option", resp)
    })
    .receive("error", resp => {
      console.log("Unable to join", resp)
    })

  channel.on("new_option", payload => {
    /* let messageItem = document.createElement("li")
    messageItem.innerText = `[${Date()}] ${payload.body}`
    messagesContainer.appendChild(messageItem) */

    console.log("new option: ");
    console.log(payload);
    if (!voted) {
      $(`<li id="${payload.option.id}">
      <div class="columns">
        <div class="column is-three-quarters">
      <p>${payload.option.text}</p>
    </div>
    <div class="column is-one-quarter">
    <p class="vote-count">0</p>
    </div>
    <div class="column is-one-quarter">
      <div class="button is-small button-vote">Vote</div>
    </div>
    </div>
    </li>`).appendTo($("#list-option"));
    } else {
      $(`<li id="${payload.option.id}">
      <div class="columns">
        <div class="column is-three-quarters">
      <p>${payload.option.text}</p>
    </div>
    <div class="column is-one-quarter">
    <p class="vote-count">0</p>
    </div>
    <div class="column is-one-quarter">
      <div class="button is-small" disabled>Vote</div>
    </div>
    </div>
    </li>`).appendTo($("#list-option"));
    }

  })

  channel.on("new_vote", payload => {
    $(`li#${payload.vote.option_id}`).find(".vote-count").html((parseInt($(`li#${payload.vote.option_id}`).find(".vote-count").html()) + 1).toString());
    if (payload.vote.creator_id == current_user_id) {
      voted = true;
      $(".button-vote").each(function () {
        if ($(this).closest("li").attr('id') != payload.vote.option_id) {
          $(this).attr('disabled', 'disabled');
          $(this).removeClass("button-vote");
        } else {
          $(this).addClass("is-warning button-unvote");
          $(this).removeClass("button-vote");
          $(this).html("Delete Vote");
        }


      });

    }
  })

  channel.on("delete_vote", payload => {

    if (payload.vote.creator_id == current_user_id) {
      voted = false;
    }

    $(`li#${payload.vote.option_id}`).find(".vote-count").html((parseInt($(`li#${payload.vote.option_id}`).find(".vote-count").html()) - 1).toString());


    $("li .button").each(function () {

      $(this).attr('disabled', false);
      $(this).addClass("button-vote");
      $(this).removeClass("is-warning button-unvote");
      $(this).html("Vote");
    });
  })

  $("#btn-new-option").on("click", function () {
    var text = $('#option-text-input').val();
    console.log(text);
    channel.push("create_option", {
      text: text
    })
  });

  $("#list-option").on("click", ".button-vote", function () {
    if (!voted) {
      var parent = $(this).closest("li");
      var option_id = parent.attr('id')
      console.log(option_id);
      channel.push("vote", {
        option_id: option_id
      })
    }

  });

  $("#list-option").on("click", ".button-unvote", function () {
    if (voted) {
      var parent = $(this).closest("li");
      var option_id = parent.attr('id')
      channel.push("delete_vote", {
        option_id: option_id
      })
    }

  });
});