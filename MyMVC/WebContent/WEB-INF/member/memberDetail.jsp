<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp"/>
<style>
	.colums{
		background-color: #CDD4CA;
		font-weight: bold;
		padding-left: 2%;
	}
	.box {
		background-color: navy;
		color: white;
		font-weight: bold;
	}
	
	.data{
		padding-left: 3%;
	}
	tr{
		border: 0px solid navy;
		border-collapse: collapse;
		padding: 3%; 
		border-bottom: 1px solid #CDD4CA;
	}
	td{
		padding-top: 3%;
		padding-bottom: 3%;	
	}
</style>

<script>
	function historyBack(){
	    history.back();
	} 
//#회원정보 수정하기
	function goEdit(idx){
	var url = "memberEdit.do?idx="+idx;
	window.open(url, "memberEdit", "left=150px, top=50px, width=800px, height=650px");
}
</script>

<div class="row">
	<div class="col-md-3"></div>
	<div class="col-md-6">
		<h2 style="margin-bottom: 40px;">::: ${membervo.name}님의 상세 정보 :::</h2>
		<form name="memberDetailFrm">
			<div>
				<table class="outline">
					<tr>
						<td class="colums">회원번호</td>
						<td class="data">${membervo.idx}</td>
					</tr>
					<tr>
						<td class="colums">아이디</td>
						<td class="data">${membervo.userid}</td>
					</tr>
					<tr>
						<td class="colums">이름</td>
						<td class="data">${membervo.name}</td>
					</tr>
					<tr>
						<td class="colums">이메일</td>
						<td class="data">${membervo.email}</td>
					</tr>
					<tr>
						<td class="colums">연락처</td>
						<td class="data">${membervo.allHp}</td>
					</tr>
					<tr>
						<td class="colums">주소</td>
						<td class="data">${membervo.allPost}&nbsp;${membervo.allAddr}</td>
					</tr>
					<tr>
						<td class="colums">성별</td>
						<td class="data">${membervo.showGender}</td>
					</tr>
					<tr>
						<td class="colums">나이</td>
						<td class="data">${membervo.showAge}</td>
					</tr>
					<tr>
						<td class="colums">생년월일</td>
						<td class="data">${membervo.showBirthday}</td>
					</tr>
					<tr>
						<td class="colums">코인</td>
						<td class="data"><span style="color: #DA2A04;">${membervo.coin}</span>&nbsp;coin</td>
					</tr>
					<tr>
						<td class="colums">포인트</td>
						<td class="data"><span style="color: #DA2A04;">${membervo.point}</span>&nbsp;point</td>
					</tr>
					<tr>
						<td class="colums">가입일자</td>
						<td class="data">${membervo.registerday}</td>
					</tr>
					<tr>
						<td class="colums">최종 로그인 일시</td>
						<td class="data">${membervo.lastlogindate}</td>
					</tr>
					<tr>
						<td class="colums">최종 암호 변경 일시</td>
						<td class="data">${membervo.lastpwdchangedate}</td>
					</tr>
			</table>
		</div>			
		<div style="margin-bottom: 3%;">
			<span style="align:center;">
			<c:if test="${sessionScope.loginuser.userid=='admin'}">
			<button type="button" style="margin-top: 30px; background-color: navy; color: white; width: 100px; border: none;" onClick="javascript:location.href='${currentURL}'">회원목록</button>
			</c:if>
			<button type="button" style="margin-top: 30px; background-color: navy; color: white; width: 100px; border: none;" onClick="goEdit(${membervo.idx});">정보수정</button>
			</span>
		</div>

		</form>
	</div>
	<div class="col-md-3"></div>
</div>

<jsp:include page="../footer.jsp"/>