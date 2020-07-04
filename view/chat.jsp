<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="com.Kcompany.Kboard.vo.MemberVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%String cp = request.getContextPath(); %>
<!-- ��Ʈ��Ʈ�� cdn -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css"/>
<!-- Ŀ���� css -->
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


<!-- ��� ��ư ���� -->
<div class="container text-center">
	<h2> ä���սô�! </h2>
	<div class="text-right">
		<form>
			<%
				MemberVO member = (MemberVO)session.getAttribute("member");
				String sessionId = member.getMemId();
			%>
			<%=sessionId%>�� &nbsp;&nbsp;<span class="bar">|</span> &nbsp;&nbsp;
			<button onclick="location.href='openList'" type="button" class="btn btn-primary"> �� ��� </button>
			<button onclick="location.href='memLogout'" type="button" class="btn btn-danger"> �α׾ƿ� </button>
		</form>
	</div><br/><br/>
</div>

<!-- ä�� ī�� -->
<div class="container">
	<div class="row">
		<div class="col-sm-1"></div>
		<div class="col-sm-10">
			<div class="card">
				<div class="row">
				<!-- 8:4���� ������ -->
				<div class="col-sm-8" style="border-right: 1px solid #333;">
					<!-- �ۼ��� ��� -->
					<div class="card-header" >
						<h3 class="text-center">ä�ù� ���</h3>
					</div><br/>
					
					<div class="text-right">
						<button onclick="disconnectStomp()" class="btn btn-danger">ä�ù� ������</button><br/>
					</div><br/>
					<!-- �ۼ��� �ٵ�(ä�ù� ���) -->
					<div class="card-body" style="height:400px;overflow:auto;">
						<div id="chatArea">
							<ul class="list-group" id="messageArea">
								<!-- �޼��� ǥ�� �κ� -->
							</ul>
						</div>
					</div>
					<div class="well"></div>
					
					<!-- ��� ǥ��(�޼��� �Է�, ����â) -->
					<div class="card-footer" >
						<div class="row">
							<div class="col-sm-10">
								<input type="text" id="msg" style="width:100%;">
							</div>
							<div class="col-sm-2">
								<button class="btn btn-warning" id="btnSend" style="float:right">����</button>
							</div>
						</div>
					</div>
				</div>
				
				<div class="well"></div>
				<div class="col-sm-4">
					<!-- ������ �κ� -->
					<div class="card-header">
						<h3 class="text-center">������</h3>
					</div>
					<div class="card-body" style="height:485px;overflow:auto;">
						<div id="userArea">
							<ul class="list-group" id="chatUser">
								<!-- ä�������� ǥ�� �κ� -->
							</ul>
						</div>
					</div>
					<!-- ������ �˻��κ� -->
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

//stomp����
function connectStomp(){
	var ws = new SockJS("<%=cp%>/stomp");
	var client = Stomp.over(ws);
	socket = client;
	
	socket.connect({}, onConnected, onError);
}

// ������ �Ϸ�Ǿ��� ��
function onConnected(frame){
	console.log("Connect Success >>>> " + frame);
	socket.subscribe("/sub/message/" + "${roomId}", onReceived);
	socket.send("/pub/TTT", {}, 
			JSON.stringify({roomId: "${roomId}", sender: "<%=sessionId%>", 
				message: "<%=sessionId%> ���� �����Ͽ����ϴ�.",  type: 'JOIN'}));
}

// ���� �� �����߻� �Ǿ��� ��
function onError(error){
	console.log("Error :::::::::: ", error);
}

// ������ ������ ��
function disconnectStomp(){
	socket.send("/pub/TTT", {}, 
			JSON.stringify({roomId: "${roomId}", sender: "<%=sessionId%>", 
				message: "<%=sessionId%> ���� �����Ͽ����ϴ�.",  type: 'LEAVE'}));
	socket.disconnect();
	window.location.href = "<%=cp%>/chatList";
}

// ������� �޼���
function onReceived(payload){
	var message = JSON.parse(payload.body);
	console.log("Received Message >>>>>>>>>>>>>>>>>>>>>> " , message.message);
	var messageElement = document.createElement('li');
	
	if(message.type == 'JOIN'){
		messageElement.classList.add("list-group-item");
		
		var chatUserElement = document.createElement('li');
		chatUserElement.classList.add("list-group-item");
		
		// �����Ҷ� ������ ���������̴�.. ���Ŀ� ���⼭ ����־������? ���ο� ������ �����ϸ� ��� ���� �ٽ� ����־�� ����?
		// �ƴϸ� foreach�� �� ������ Ÿ���� �����̸� �Ѱ��� �߰����ְ�(����Ʈ��), Ÿ���� ����� �Ѱ��� ������ �ٱ�?
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

		/* �ձ��� �빮�� ���� */
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

// �������� ��� ���� �Լ�
function getAvatarColor(messageSender) {
    var hash = 0;
    for (var i = 0; i < messageSender.length; i++) {
        hash = 31 * hash + messageSender.charCodeAt(i);
    }
    var index = Math.abs(hash % colors.length);
    return colors[index];
}

// ���۹�ư�� ������ ��
$("#btnSend").click(function(){
	var msg = $("input#msg").val();
	socket.send("/pub/TTT", {}, 
			JSON.stringify({roomId: "${roomId}" , sender: "<%=sessionId%>", message: msg, type: 'CHAT'}));
});

// ä�ù� row������ ������ �̵�
function selectRow(roodId){
	window.location.href = "chat?id=" + roodId;
}

connectStomp();
</script>
</html>