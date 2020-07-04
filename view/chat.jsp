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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
<!-- 커스텀 css -->
<link rel="stylesheet" href="<%=cp%>/resources/css/boardStlye.css" >
<link rel="stylesheet" href="<%=cp%>/resources/css/chatStyle.css" >
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
	<h2> 채팅합시다! </h2>
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
					</div><br/>
					
					<div class="text-right">
						<button onclick="disconnectStomp()" class="btn btn-danger">채팅방 나가기</button><br/>
					</div><br/>
					<!-- 작성글 바디(채팅방 목록) -->
					<div class="card-body" style="height:400px;overflow:auto;">
						<div id="chatArea">
							<ul class="list-group" id="messageArea">
								<!-- 메세지 표시 부분 -->
							</ul>
						</div>
					</div>
					<div class="well"></div>
					
					<!-- 댓글 표시(메세지 입력, 전송창) -->
					<div class="card-footer" >
						<div class="row">
							<div class="col-sm-10">
								<input type="text" id="msg" style="width:100%;">
							</div>
							<div class="col-sm-2">
								<button class="btn btn-warning" id="btnSend" style="float:right">전송</button>
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
					<div class="card-body" style="height:485px;overflow:auto;">
						<div id="userArea">
							<ul class="list-group" id="chatUser">
								<!-- 채팅참여자 표시 부분 -->
							</ul>
						</div>
					</div>
					<!-- 참여자 검색부분 -->
					<div class="card-footer">
						<div class="row">
							<div class="col-sm-9">
									<input type="text" style="width:100%;">
							</div>
							<div class="col-sm-3">
								<div id="idInputGroup" class="input-group">
									<div class="input-group-prepend">	
										<span class="input-group-text">
											<i class="fas fa-search fa-fw" aria-hidden="true"></i>
										</span>
									</div>
								</div>
							</div>
						</div>
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
var chatArea = document.querySelector('#chatArea');
var userArea = document.querySelector('#userArea');

//stomp연결
function connectStomp(){
	var ws = new SockJS("<%=cp%>/stomp");
	var client = Stomp.over(ws);
	socket = client;
	
	socket.connect({}, onConnected, onError);
}

// 연결이 완료되었을 때
function onConnected(frame){
	console.log("Connect Success >>>> " + frame);
	socket.subscribe("/sub/message/" + "${roomId}", onReceived);
	socket.send("/pub/TTT", {}, 
			JSON.stringify({roomId: "${roomId}", sender: "<%=sessionId%>", 
				message: "<%=sessionId%> 님이 입장하였습니다.",  type: 'JOIN'}));
}

// 연결 시 에러발생 되었을 때
function onError(error){
	console.log("Error :::::::::: ", error);
}

// 연결이 끊겼을 때
function disconnectStomp(){
	socket.send("/pub/TTT", {}, 
			JSON.stringify({roomId: "${roomId}", sender: "<%=sessionId%>", 
				message: "<%=sessionId%> 님이 퇴장하였습니다.",  type: 'LEAVE'}));
	socket.disconnect();
	window.location.href = "<%=cp%>/chatList";
}

// 발행받은 메세지
function onReceived(payload){
	var message = JSON.parse(payload.body);
	console.log("Received Message >>>>>>>>>>>>>>>>>>>>>> " , message.message);
	var messageElement = document.createElement('li');
	
	if(message.type == 'JOIN'){
		messageElement.classList.add("list-group-item");
		
		var chatUserElement = document.createElement('li');
		chatUserElement.classList.add("list-group-item");
		
		// 조인할때 세션을 넣은상태이다.. 이후에 여기서 찍어주어야할지? 새로운 유저가 조인하면 계속 새로 다시 찍어주어야 할지?
		// 아니면 foreach로 찍어낸 다음에 타입이 조인이면 한개씩 추가해주고(리스트에), 타입이 리브면 한개씩 삭제해 줄까?
		var usernameElement = document.createElement('span');
        var usernameText = document.createTextNode(message.sender);
        usernameElement.appendChild(usernameText);
        chatUserElement.appendChild(usernameElement);
        
        chatUser.appendChild(chatUserElement);
        chatUser.scrollTop = chatUser.scrollHeight;
        
	}else if(message.type == 'LEAVE'){
		messageElement.classList.add("list-group-item");
	}else{
		messageElement.classList.add("list-group-item");
		messageElement.appendChild
		
		/* messageElement.classList.add('chatMessage'); */

		/* 앞글자 대문자 따기 */
        /*var avatarElement = document.createElement('i');
        var avatarText = document.createTextNode(message.sender[0]);
        avatarElement.appendChild(avatarText);
         avatarElement.style['background-color'] = getAvatarColor(message.sender); 

        messageElement.appendChild(avatarElement);*/

        var usernameElement = document.createElement('span');
        var usernameText = document.createTextNode(message.sender);
        usernameElement.appendChild(usernameText);
        messageElement.appendChild(usernameElement); 
	}
	var textElement = document.createElement('p');
    var messageText = document.createTextNode(message.message);
    textElement.appendChild(messageText);

    messageElement.appendChild(textElement);

    messageArea.appendChild(messageElement);
    messageArea.scrollTop = messageArea.scrollHeight; 
    
    
}

// 랜덤색을 얻기 위한 함수
function getAvatarColor(messageSender) {
    var hash = 0;
    for (var i = 0; i < messageSender.length; i++) {
        hash = 31 * hash + messageSender.charCodeAt(i);
    }
    var index = Math.abs(hash % colors.length);
    return colors[index];
}

// 전송버튼을 눌렀을 때
$("#btnSend").click(function(){
	var msg = $("input#msg").val();
	socket.send("/pub/TTT", {}, 
			JSON.stringify({roomId: "${roomId}" , sender: "<%=sessionId%>", message: msg, type: 'CHAT'}));
});

// 채팅방 row누르면 페이지 이동
function selectRow(roodId){
	window.location.href = "chat?id=" + roodId;
}

connectStomp();
</script>
</html>