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
	<h2> ���� �Խ��� </h2>
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
					</div>
					<!-- �ۼ��� �ٵ�(ä�ù� ���) -->
					<div class="card-body" style="height:400px;">
						
						<button onclick="connectStomp()">connect</button><br/>
						<button onclick="disconnectStomp()">Disconnect</button><br/>
						
						<!-- �޼��� ǥ�� �κ� -->
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
					<div class="card-body" style="height:400px;">
						<c:if test="${userList != null}">
							<c:forEach items="${userList}" var="userList">	
								<li> ${userList }
							</c:forEach>
						</c:if>
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
	socket.subscribe("/sub/message/" + "${roomId}", function(response){
		console.log(response.sender + " >>>>> ", response.message);
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

// ���۹�ư�� ������ ��
$("#btnSend").click(function(){
	var msg = $("input#msg").val();
	socket.send("/pub/TTT", {}, JSON.stringify({roomId: "${roomId}" , sender: "<%=sessionId%>", message: msg}));
	
	console.log("Send Msg >> ", msg);
});

// ä�ù� row������ ������ �̵�
function selectRow(roodId){
	window.location.href = "chat?id=" + roodId;
}


</script>
</html>