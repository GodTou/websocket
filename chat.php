<!DOCTYPE html>
<html>
<head>
<meta charset='UTF-8' />
<style type="text/css">
<!--
.chat_wrapper {
    width: 95%;
    height: 600px;
    margin-right: auto;
    margin-left: auto;
    background: #CCCCCC;
    border: 1px solid #999999;
    padding: 10px;
    font: 12px 'lucida grande',tahoma,verdana,arial,sans-serif;
}
.chat_wrapper .message_box {
    height: 560px;
    background: #FFFFFF;
    overflow: auto;
    padding: 10px;
    border: 1px solid #999999;
}
.chat_wrapper .panel{
    float:right;
}
.chat_wrapper .panel input{
    padding: 2px 2px 2px 5px;
}
.system_msg{color: #BDBDBD;font-style: italic;}
.user_name{font-weight:bold;}
.user_message{color: #88B6E0;}
-->
</style>
</head>
<body>

<script src="./static/jquery.js"></script>

<script language="javascript" type="text/javascript">
$(document).ready(function(){
    //create a new WebSocket object.
    var wsUri = "ws://localhost:9000";
    websocket = new WebSocket(wsUri);

    websocket.onopen = function(ev) { // connection is open
        $('#message_box').append("<div class=\"system_msg\">Connected!</div>"); //notify user
    }

    $('#setFilter').change(function() {
        var name = $(this).val();
        var msg = {
            type: "setName",
            name: name
        };
        websocket.send(JSON.stringify(msg));
    });
    //$('#send-btn').click(function(){ //use clicks message send button
    //    var mymessage = $('#message').val(); //get message text
    //    var myname = $('#name').val(); //get user name
    //
    //    if(myname == ""){ //empty name?
    //        alert("Enter your Name please!");
    //        return;
    //    }
    //    if(mymessage == ""){ //emtpy message?
    //        alert("Enter Some message Please!");
    //        return;
    //    }
    //
    //    //prepare json data
    //    var msg = {
    //    message: mymessage,
    //    name: myname,
    //    color : '<?php echo $colours[$user_colour]; ?>'
    //    };
    //    //convert and send data to server
    //    websocket.send(JSON.stringify(msg)); //});

    //#### Message received from server?
    websocket.onmessage = function(ev) {
        var msg = JSON.parse(ev.data); //PHP sends Json data
        var type = msg.type; //message type
        var umsg = msg.message; //message text
        var fileName = msg.name; //user name
        var ucolor = msg.color; //color
        var time = msg.time;
        var line = msg.line;

        if(type == 'msg')
        {
            $('#message_box').append("<div><span class=\"user_name\" style=\"color:#"+ucolor+"\">"+time+fileName+" on line "+line+"</span> :<br> <span class=\"user_message\">"+umsg+"</span></div>");
        }
        if(type == 'system')
        {
            //$('#message_box').append("<div class=\"system_msg\">"+umsg+"</div>");
        }

        if (type == 'setFilter') {
            var currentFilter = $("#setFilter").val();
            var html = "<option value='all'>Filter None</option>";
            if (currentFilter != 'all') {
                html += "<option value='"+currentFilter+"' selected>"+currentFilter+"</option>"
            }
            var str = new Array();
            str = umsg.split(',');
            for (i=0;i<str.length ;i++ ) {
                if (str[i] == "all" || str[i] == currentFilter) {
                    continue;
                }
                html += "<option value='"+str[i]+"'>"+str[i]+"</option>";
            }
            $("#setFilter").html(html);
        }

        $('#message').val(''); //reset text
        $('#message_box').scrollTop($('#message_box')[0].scrollHeight);
    };

    websocket.onerror    = function(ev){$('#message_box').append("<div class=\"system_error\">Error Occurred - "+ev.data+"</div>");};
    websocket.onclose     = function(ev){$('#message_box').append("<div class=\"system_msg\">Connection Closed</div>");};
});
</script>
<div class="chat_wrapper">
<div class="message_box" id="message_box"></div>
<div class="panel">
Filter：
<select name="filter" id="setFilter">
    <option value="all">Filter None</option>
</select>
<!--<input type="text" name="searchBox" id="searchBox" placeholder="Search Info"/>
<button id="send-btn">Search</button>-->
</div>
</div>

</body>
</html>
