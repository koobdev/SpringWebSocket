<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<%@ page import="com.Kcompany.Kboard.vo.MemberVO"%>
<%@ page import="java.util.UUID"%>

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
	<h2> 채팅합시다! </h2>
	<div class="text-right">
		<form>
			<%
				MemberVO member = (MemberVO)session.getAttribute("member");
				String sessionId = member.getMemId();
				String UUid = UUID.randomUUID().toString(); 
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
				<!-- 작성글 헤더 -->
				<div class="card-header" >
					<h3 class="text-center">채팅방 목록</h3>
				</div>
				<!-- 작성글 바디(채팅방 목록) -->
				<div class="card-body" style="height:500px;overflow:auto;">
					<div class="text-right">
						<button onclick="createRoom()" type="submit" class="btn btn-primary">채팅방 생성</button>
					</div><br/>
					<c:forEach items="${rooms}" var="rooms">
						<ul class="list-group" onclick="selectRow('${rooms.id}')">
							<li class="list-group-item" style="cursor:pointer;">
								<div class="row">
									<div class="col-sm-9" style="border-right: 1px solid #333;">
										${rooms.name}
									</div>
									<div class="col-sm-3">
										${rooms.creater}
									</div>
								</div>
							</li>
						</ul>
					</c:forEach>
				</div>
			</div>
		</div>
		<div class="col-sm-1"></div>
	</div>
</div>
</body>
<script>

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
	socket.subscribe("/sub/message", function(response){
		console.log("Receive Msg >> ", response);
	});
}

// 연결 시 에러발생 되었을 때
function onError(error){
	console.log("Error :::::::::: ", error);
}

// 연결이 끊겼을 때
function disconnectStomp(){
	socket.send("/disConn", {}, "DisConn Succ");
	socket.disconnect();
	console.log("BBBBBByeeeeeee~~~~");
}


//채팅방 row누르면 페이지 이동
function selectRow(roodId){
	window.location.href = "chat/" + roodId;
}

//채팅방 생성
function createRoom(){
	var roomName = prompt("채팅방 이름을 입력하세요.");
	var rn = String(roomName);
	
	if(rn != ''){
		var form = document.createElement('form');
		form.setAttribute('method', 'Post');
		form.setAttribute('action', "createChat");
		
		var id = document.createElement("input");
		id.setAttribute("type", "hidden");
		id.setAttribute("name", "id");
		id.setAttribute("value", "<%=UUid%>");
		form.appendChild(id);
		
		var name = document.createElement("input");
		name.setAttribute("type", "hidden");
		name.setAttribute("name", "name");
		name.setAttribute("value", rn);
		form.appendChild(name);
		
		var creater = document.createElement("input");
		creater.setAttribute("type", "hidden");
		creater.setAttribute("name", "creater");
		creater.setAttribute("value", "<%=sessionId%>");
		form.appendChild(creater);
		
		var date = document.createElement("input");
		date.setAttribute("type", "hidden");
		date.setAttribute("name", "date");
		date.setAttribute("value", "d");
		form.appendChild(date);
		
		document.charset = "utf-8";
		document.body.appendChild(form);
		form.submit();
	}
}

</script>
</html>