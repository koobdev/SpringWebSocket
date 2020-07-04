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
<!-- ��Ʈ��Ʈ�� cdn -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
<!-- Ŀ���� css -->
<link rel="stylesheet" href="<%=cp%>/resources/css/boardStlye.css" >
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
				String UUid = UUID.randomUUID().toString(); 
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
				<!-- �ۼ��� ��� -->
				<div class="card-header" >
					<h3 class="text-center">ä�ù� ���</h3>
				</div>
				<!-- �ۼ��� �ٵ�(ä�ù� ���) -->
				<div class="card-body" style="height:500px;overflow:auto;">
					<div class="text-right">
						<button onclick="createRoom()" type="submit" class="btn btn-primary">ä�ù� ����</button>
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
	socket.subscribe("/sub/message", function(response){
		console.log("Receive Msg >> ", response);
	});
}

// ���� �� �����߻� �Ǿ��� ��
function onError(error){
	console.log("Error :::::::::: ", error);
}

// ������ ������ ��
function disconnectStomp(){
	socket.send("/disConn", {}, "DisConn Succ");
	socket.disconnect();
	console.log("BBBBBByeeeeeee~~~~");
}


//ä�ù� row������ ������ �̵�
function selectRow(roodId){
	window.location.href = "chat/" + roodId;
}

//ä�ù� ����
function createRoom(){
	var roomName = prompt("ä�ù� �̸��� �Է��ϼ���.");
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