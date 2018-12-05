<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header.jsp"/>

<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css" /> 
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>

<style>
 .line {
 	border: 0px solid gray;
 	border-collapse: collapse;
 	margin-top: 20px;
 	margin-bottom: 20px;
 }
 
 li{margin-bottom: 0.9%;}
</style>

<script type="text/javascript">
	$(document).ready(function() {
		// 좋아요 싫어요 수 로딩하기
		 goLikeDislikeCountShow();
		
		
	    $("#spinner").spinner( {
		   spin: function(event, ui) {
			   if(ui.value > 100) {
				   $(this).spinner("value", 100);
				   return false;
			   }
			   else if(ui.value < 0) {
				   $(this).spinner("value", 1);
				   return false;          
			   }
		   }   
		 });// end of spinner
		 
	});// end of $(document).ready();
	
//	#제품번호와 수량을 받아서 장바구니에 추가하는 메소드
	function goCart(pnum){
		var frm = document.cartOrderFrm;
		
		var oqty = frm.oqty.value;
		
		var regExp = /^[0-9]+$/;
		var bool = regExp.test(oqty);
		
		if(!bool){ // 물품 수량에 숫자가 아닌 값이 들어온 경우
			alert("1개 이상 주문하세요.");
			frm.oqty.value="1";
			frm.oqty.focus();
			return;
		}
		else { // 숫자가 들어온 경우
			oqty = parseInt(oqty);
			if(oqty<1){ // 0개 주문한 경우
				alert("1개 이상 주문하세요.");
				frm.oqty.value="1";
				frm.oqty.focus();
				return;
			}
			else{	// 1개 이상 주문한 경우
				frm.method = "POST";
				frm.action = "cartAdd.do";
				frm.submit();
			}
		}
	}


//	#주문하기 메소드
	function goOrder(pnum){
	var frm = document.cartOrderFrm;
		
		var oqty = frm.oqty.value;
		
		var regExp = /^[0-9]+$/;
		var bool = regExp.test(oqty);
		
		if(!bool){ // 물품 수량에 숫자가 아닌 값이 들어온 경우
			alert("1개 이상 주문하세요.");
			frm.oqty.value="1";
			frm.oqty.focus();
			return;
		}
		else { // 숫자가 들어온 경우
			oqty = parseInt(oqty);
			if(oqty<1){ // 0개 주문한 경우
				alert("1개 이상 주문하세요.");
				frm.oqty.value="1";
				frm.oqty.focus();
				return;
			}
			else{	// 1개 이상 주문한 경우
				// 물품수량*실판매가 , 물품수량*포인트
				/*
				if(${sessionScope.loginuser != null}){
					var coin = ${sessionScope.loginuser.coin};
					if(sumtotalprice>coin){	// 코인잔액보다 주문총액이 많은 경우
						var coinYN = confirm("코인 잔액이 부족합니다. 코인을 충전 하시겠습니까?");
						if(!coinYN){
							return;
						}
						else{
							var url = "coinPurchaseTypeChoice.do?idx="+${(sessionScope.loginuser).idx};
							window.open(url, "coinPurchaseTypeChoice", "left=350px, top=100px, width=650px, height=570px");
						}
					}
					else {	// 코인잔액이 충분한 경우 */
						var sumtotalprice = oqty*parseInt("${pvo.saleprice}");
						var sumtotalpoint = oqty*parseInt("${pvo.point}");
					
						frm.sumtotalprice.value= sumtotalprice;
						frm.sumtotalpoint.value= sumtotalpoint;
						
						frm.method = "POST";
						frm.action = "orderAdd.do";
						frm.submit();
				/*	}
				} */
			}
		}
	} // end of goOrder

	
//	[181205]
//	좋아요/싫어요 기능 ==> Ajax처리

// #좋아요 싫어요 누적카운트 보여주기 --> 문서가 로딩되면 실행되어야함
	function goLikeDislikeCountShow(){	
		var form_data = {"pnum":"${pvo.pnum}"};
		$.ajax({
			url: "likeDislikeCntShow.do",
			type: "GET",
			data: form_data,
			dataType: "JSON",
			success: function(json){
				// 1개행만 가져오면 되기 때문에 JSONObject 사용
				var likeCnt = json.likeCnt;
				var dislikeCnt = json.dislikeCnt;
				
				$("#likeCnt").html(likeCnt);
				$("#dislikeCnt").html(dislikeCnt);
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		});
	}

//	#좋아요 추가하기 함수
	function goLikeAdd(pnum){
		var form_data = {"userid":"${sessionScope.loginuser.userid}", "pnum":pnum};
		$.ajax({
			url: "likeAdd.do",
			type: "POST",
			data: form_data,
			dataType: "JSON",
			success: function(json){
				swal(json.msg);
				goLikeDislikeCountShow();
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}

		});
	}// end of goListAdd
	
	
	function goDislikeAdd(pnum){
		var form_data = {"userid":"${sessionScope.loginuser.userid}", "pnum":pnum};
		$.ajax({
			url: "dislikeAdd.do",
			type: "POST",
			data: form_data,
			dataType: "JSON",
			success: function(json){
				swal(json.msg);
				goLikeDislikeCountShow();
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}

		});
	}// end of goDislikeAdd


	
	
</script>

<div class="container">

	<div class="row">
		<div class="col-md-12 line">
			<span style="font-size: 15pt; font-weight: bold;"> ::: 제품 상세 정보 ::: </span>
		</div>
	</div>
	
	<div class="row">
		<div class="col-md-4 line">
			<img src="images/${pvo.pimage1}" style="width: 100%; height: 100%;"/>
		</div>
		<div class="col-md-8 line" style="text-align: left;">
			<ul style="list-style-type: none;">
				<li><span style="font-weight: bold; color: red;">${pvo.pspec}</span></li>
				<li>제품번호: ${pvo.pnum}</li>
				<li>제품이름: ${pvo.pname}</li>
				<li>제품정가: <span style="text-decoration:line-through;"><fmt:formatNumber value="${pvo.price}" pattern="###,###"/>원&nbsp;</span></li>
				<li>판매가: <span style="font-size: 15pt; font-weight: bold; color: red;"><fmt:formatNumber value="${pvo.saleprice}" pattern="###,###"/>원</span></li>
				<li>할인율: ${pvo.percent}% 할인</li>
				<li>포인트: ${pvo.point}POINT</li>
				<li>재고: ${pvo.pqty}</li>
			</ul>
			<%-- #장바구니 담기 및 바로주문하기 폼 --%>
			<form name="cartOrderFrm">
				<ul style="list-style-type: none; margin-top: 5%;">
					<%-- 크롬에서는 input number타입이 가능하지만 웹표준을 따르지않는 익스플로러에서는 동작X ==> 제이쿼리 사용! --%>
					<li style="margin-bottom: 3%;">
						<label for="spinner">주문수량: </label><input id="spinner" name="oqty" value="1" style="width: 30px; height: 20px;"/>
					</li> 
					<li>
						<button type="button" class="btn btn-info" onClick="goCart(${pvo.pnum})">장바구니</button>
						<button type="button" class="btn btn-warning" onClick="goOrder(${pvo.pnum})">바로 주문하기</button>
					</li>
				</ul>
				<input type="hidden" name="pnum" value="${pvo.pnum}"/>
				<input type="hidden" name="saleprice" value="${pvo.saleprice}" />
				<input type="hidden" name="sumtotalprice" />
				<input type="hidden" name="sumtotalpoint" />
				<input type="hidden" name="goBackURL" value="${goBackURL}" /> 
										<%-- prodViewAction에서 goBackURL을 받아옴 --%>
			</form>
		</div>
	</div>
	
	<div class="row">
		<div class="col-md-12 line">
			<img src="images/${pvo.pimage2}" style="width: 50%; height: 50%;"/><br/>
			<c:forEach var="attachImgMap" items="${attachImageList}">
				<img src="images/${attachImgMap.imgfilename}" style="width: 50%; height: 50%;"/><br/>
			</c:forEach>
			
		</div>
	</div>
	<%-- 제품 상세 설명 --%>
	<div class="row">
		<div class="col-md-12 line">
			<span style="font-weight: bold; font-size: 15pt; color: white; background-color: navy;">제품설명</span>
			<p>
			${pvo.pcontent}
		</div>
	</div>
	
	<%-- 좋아요 싫어요 버튼 --%>
	<div class="row" style="margin-bottom: 30px;">
			
			<div class="col-md-offset-4 col-md-1">
				<img width="100%" src="<%= request.getContextPath() %>/images/like.png" style="cursor: pointer;" onClick="goLikeAdd('${pvo.pnum}')"/>
			</div>
			
			<div class="col-md-1" id="likeCnt" style="color: blue; font-size: 10pt; text-align: left;">
			</div>
			
			<div class="col-md-1">
				<img width="100%" src="<%= request.getContextPath() %>/images/dislike.png" style="cursor: pointer;" onClick="goDislikeAdd('${pvo.pnum}')"/>
			</div>
			
			<div class="col-md-1" id="dislikeCnt" style="color: red; font-size: 10pt; text-align: left;">
			
			</div>
		
	</div>
	

	
	
	
</div>




<jsp:include page="../footer.jsp"/>