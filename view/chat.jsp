<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.4.0/sockjs.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<h1>This is chat page</h1>
<div>
	<input type="text" id="msg" class="form-contorl" value="12121221"/>
	<button id="btnSend" class="btn btn-primary"> Send Message </button>
</div>

<button onclick="connect()">연결끊기</button>

</body>
<script>
var socket = null;
$(document).ready( function() {
	connect();
	$('#btnSend').on('click', function(evt){
		evt.preventDefault();
		if(socket.readyState !== 1) return;
			let msg = $('input#msg').val();
			socket.send(msg);
	});
});

function connect(){
	var ws = new SockJS("/Kboard/chat");
	socket = ws;
	ws.onopen = function(){
		console.log('Info : connection opend');
	}	
	ws.onmessage = function(event){
		console.log("ReceiveMessage : ", event.data + '\n');
	}
	ws.onclose = function(event){ 
		console.log('Info : connection closed');
		/* setTimeout(() => {
			connect();
		}, 1000); */
	}
	ws.onerror = function(err) { console.log('Error : ', err);}
}
</script>
</html>