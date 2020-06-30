<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="com.Kcompany.Kboard.vo.MemberVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%String cp = request.getContextPath(); %>
<!-- 부트스트랩 cdn -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<!-- 커스텀 css -->
<link rel="stylesheet" href="<%=cp%>/resources/css/boardStlye.css" >
<!-- sockjs, stomp cdn -->
<script	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.4.0/sockjs.min.js"></script>
<script	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<!-- jquery cnd -->
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>

<title>Insert title here</title>
</head>
<body>


<!-- 상단 버튼 모음 -->
<div class="container text-center">
	<h2> 자유 게시판 </h2>
	<div class="text-right">
		<form>
			<%
				MemberVO member = (MemberVO)session.getAttribute("member");
				String sessionId = member.getMemId();
			%>
			<%=sessionId%>님 &nbsp;&nbsp;<span class="bar">|</span> &nbsp;&nbsp;
			<button onclick="location.href='openList'" type="button" class="btn btn-primary"> 글 목록 </button>
			<button onclick="location.href='memLogout'" type="button" class="btn btn-danger"> 로그아웃 </button>
		</form>
	</div><br/><br/>
</div>

<!-- 채팅 카드 -->
<div class="container">
	<div class="row">
		<div class="col-sm-1"></div>
		<div class="col-sm-10">
			<div class="card">
				<div class="row">
				<!-- 8:4으로 나누기 -->
				<div class="col-sm-8" style="border-right: 1px solid #333;">
					<!-- 작성글 헤더 -->
					<div class="card-header" >
						<h3 class="text-center">채팅방 목록</h3>
					</div>
					<!-- 작성글 바디(채팅방 목록) -->
					<div class="card-body" style="height:400px;">
						<%-- <c:forEach items="" var=""></c:forEach> --%>
						
						<button onclick="connect()">SockJS connect</button><br/>
						<button onclick="connectStomp()">Stomp connect</button><br/>
						<button onclick="disconnectStomp()">Stomp Disconnect</button><br/>
						<input id="msg" type="text"><button id="btnSend"> Send Message </button><br/>
					</div>
					
					<div class="well"></div>
					
					<!-- 댓글 표시(메세지 입력, 전송창) -->
					<div class="card-footer" >
						<div class="row">
							<div class="col-sm-10">
								<input type="text" id="chatText" style="width:100%;">
							</div>
							<div class="col-sm-2">
								<button class="btn btn-warning" id="chatBtn" style="float:right">전송</button>
							</div>
						</div>
					</div>
				</div>
				
				<div class="well"></div>
				<div class="col-sm-4">
					<!-- 참여자 부분 -->
					<div class="card-header">
						<h3 class="text-center">참여자</h3>
					</div>
					<div class="card-body" style="height:400px;">
					</div>
				</div>
				</div>
			</div>
		</div>
		<div class="col-sm-1"></div>
	</div>
</div>

</body>
<script>
var socket = null;

function connect(){
	var ws = new SockJS("<%=cp%>/ws");

	ws.onopen = function(){
		console.log('Info : connection opend');
	}	
	
	ws.onmessage = function(event){
		console.log(event.data + '\n');
	}
	
	ws.onclose = function(event){ 
		console.log('Info : connection closed');
		/* setTimeout(() => {
			connect();
		}, 1000); */
	}
	ws.onerror = function(err) { console.log('Error : ', err);}
}

function connectStomp(){
	var ws = new SockJS("<%=cp%>/stomp");
	var client = Stomp.over(ws);
	socket = client;
	
	socket.connect({}, onConnected, onError);
}

function onConnected(){
	socket.send("/TTT", {}, "Connect Success!!!!!!!!!!");
	socket.subscribe("/topic/message", function(event){
		console.log("Receive Msg >> ", event);
	});
}

function onError(error){
	console.log("Error :::::::::: ", error);
}

function disconnectStomp(){
	socket.send("/disConn", {}, "DisConn Succ");
	socket.disconnect();
	console.log("BBBBBByeeeeeee~~~~");
}

$("#btnSend").click(function(){
	var msg = $("input#msg").val();
	socket.send("/TTT", {}, msg);
	
	console.log("Send Msg >> ", msg);
});









</script>
</html>