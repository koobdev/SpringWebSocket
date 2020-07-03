<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
	<title>Create Success</title>
</head>
<% 
	String cp = request.getContextPath();
%>
<body>
<script type="text/javascript">
	var cp = "<%=cp%>";
	alert("채팅방이 생성되었습니다.");
	window.location.href = cp + "/chatList"
</script>
</body>
</html>
