<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String[] nameArr = (String[])request.getAttribute("friend");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSTL; 6ArrayTestView: 우리반 사람들 명단 출력; java 스크립틀릿 사용</title>
</head>
<body>
	<h2>우리반 친구들</h2>
	<br/>
	<ol style="list-style-type: decimal;">
	<%	for(int i=0; i<nameArr.length; i++){
	%>		<li><%=nameArr[i]%></li>
	<%	
		}
	%>
	</ol>
</body>
</html>