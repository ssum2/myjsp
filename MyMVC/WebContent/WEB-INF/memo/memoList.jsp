<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<jsp:include page="../header.jsp"/>
<%
	List<HashMap<String, String>> memoList = (List<HashMap<String, String>>)request.getAttribute("memoList");

%>
<table class="outline">
	<thead>
		<tr>
			<th width="10%" style="text-align: center;">글번호</th>
			<th width="10%" style="text-align: center;">작성자</th>
			<th width="50%" style="text-align: center;">글내용</th>
			<th width="20%" style="text-align: center;">작성일자</th>
			<th width="10%" style="text-align: center;">IP주소</th>
		</tr>
	</thead>
	
	<tbody>
	<%
		if(memoList == null){
	%>
			<tr>
				<td colspan="5">데이터가 없습니다</td>
			</tr>
	
	
	<%		
		}
		else { // DAO에서 받아온 memoList가 null이 아닐 때(리스트 내용이 존재할 때)
			for(HashMap<String, String> map : memoList){
				// >> List에 넣어둔 HashMap에서 key값으로 values 가져옴
	%>
				<tr>
					<td style="text-align:center;"><%=map.get("idx")%></td>
					<td style="text-align:center;"><%=map.get("name")%></td>
					<td style="text-align:center;"><%=map.get("msg").replaceAll("<", "&lt")%></td>
				
				<%-- HTML 에서 &nbsp; 공백     &lt; 부등호(<)  &gt; 부등호(>)    &amp; &   &quot;  " 이다.  --%>
					<td style="text-align:center;"><%=map.get("writedate")%></td>
					<td style="text-align:center;"><%=map.get("cip")%></td>
				</tr>
	<%		} // end of for
		}
	%>
	
	</tbody>
</table>

<jsp:include page="../footer.jsp"/>