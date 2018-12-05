<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header.jsp" />

<style type="text/css">
  .th, .td {border: 0px solid gray;}
  a:hover {text-decoration: none;}
</style>

<script type="text/javascript">
 $(document).ready(function(){

	 $("#countNEW").hide();
	 $("#totalNEWCount").hide();
	 $("#countPspec").hide();
	 $("#totalPspecCount").hide();
	
//	#HIT상품 리스트를 더 불러오기 위해 '더보기 ▽' 버튼 클릭 액션에 대한 초기값 호출
	displayHitAppend("1"); // displayHitAppend("페이지숫자");
	 
//	#더보기 버튼 클릭액션 이벤트 
	$("#btnMoreHIT").click(function(){
		if($(this).text()=="처음으로 △"){
			$("#displayResult").empty();
			displayHitAppend("1");
			$(this).text("더보기 ▽");
		}
		else{
			displayHitAppend($(this).val());
		//	>> 버튼에 저장되어있는 시작물품번호를 함수의 파라미터에 넣어줌			
		}
	});
	
//	#NEW상품 불러오기	
	displayNEWAppend("1");
	
	$("#btnMoreNEW").click(function(){
		if($(this).text()=="처음으로 △"){
			$("#displayNEWResult").empty();
			displayNEWAppend("1");
			$(this).text("더보기 ▽");
		}
		else{
			displayNEWAppend($(this).val());
		}
	});
	
	
 });
 
 	var lenHIT = 8;	// 더보기 클릭에 보여줄 페이지 갯수
 	
//	#디스플레이할 HIT pspec 제품 정보 추가 요청하는 함수 
	function displayHitAppend(start){
		var form_data = {"start":start,
						 "len":lenHIT,
						 "pspec":"HIT"};
		// >> count라는 표현보단 length의 'len'으로 표현(pspec에 따른 상품 페이지수의 길이)
		
		$.ajax({
			url:"malldisplayXML.do",
			type:"GET",
			data: form_data,
			dataType:"XML",
			success:function(xml){
				var rootElement = $(xml).find(":root");
		//		console.log($(rootElement).prop("tagName"));
		//		>> start
				var productArr = $(rootElement).find("product");
		
				var html = "";
				
				if(productArr.length == 0){ // 불러올 상품 데이터가 없는 경우 null이 아니라 배열의 길이가 0 (arr 객체는 존재하기 때문)
					html += "<tr><td colspan='4' class='td' align='center'>현재 상품 준비중....</td></tr>";

				//	#HIT상품 데이터 출력하기			
					$("#displayResult").html(html);
				// 더보기 버튼 비활성화
					$("#btnMoreHIT").attr("disabled", true);
					$("#btnMoreHIT").css("cursor", "not-allowed");
				}
				else{
					html += "<tr>";
					for(var i=0; i<productArr.length; i++){
						var product = $(productArr).eq(i);
				//		>> 선택자.eq(index); element를 인덱스번호로 찾는 선택자  --> arr[i]과 비슷
				
				//		console.log($(product).prop("tagName"));	// >> 선택자의 태그내용; product
				
				//		console.log($(product).html());
				<%--	<pnum>37</pnum>
						<pimage1>59.jpg</pimage1>
						<pname>노트북30</pname>
						<price>1,200,000</price>				
						<saleprice>1,000,000</saleprice>
						<percent>17</percent>
						<point>60</point>			--%>
						
				//		console.log($(product).find("pname").text());	// 노트북30 ...
				
						html += "<td class='td' align='center'>"+"<a href=\"/MyMVC/prodView.do?pnum="+$(product).find('pnum').text()+"\">"+
									"<img width=\"120px;\" height=\"130px;\" src=\"images/"+$(product).find('pimage1').text()+"\">"+
									"</a>"+
									"<br/><br/><span style='background-color: navy; color:white; font-weight: bold;'>"+$(product).find("pspec").text()+"</span>"+
									"<br/>"+$(product).find('pname').text()+
									"<br/><span style='text-decoration: line-through;'>"+$(product).find('price').text()+"원</span>"+
									"<br/><span style=\"color: red; font-weight: bold;\">"+$(product).find('saleprice').text()+"/>원</span>"+
									"<br/><span style=\"color: blue; font-weight: bold;\">["+$(product).find('percent').text()+"% 할인]</span>"+
									"<br/><span style=\"color: orange;\">"+$(product).find('point').text()+" POINT</span>"+
								"</td>"; 
						
						
						if((i+1)%4==0){
							html+="</tr><tr><td colspan='4' style='line-height: 30px;'>&nbsp;</td></tr><tr>";
						}
					}	// end of for
					
					html += "</tr>";
					
					$("#displayResult").append(html);
					
					// 더보기 버튼의 value에 페이지번호 주기(다음 페이지의 첫번째 물품번호; 1페이지의 끝 8번 -> 2페이지의 시작 9번)
					$("#btnMoreHIT").val(parseInt(start)+lenHIT);
					/*
						parseInt(start)의 초기값 1
						-> 더보기 버튼 클릭시 => 1+lenHIT(8) = 9 -> btnMoreHIT.val(9)
					*/
					
					// 웹브라우저 상에 count를 출력; 현재 페이지의 물품갯수+다음페이지 물품갯수를 countPspec에 누적
					$("#countPspec").text(parseInt($("#countPspec").text())+$(productArr).length);
					
				//	alert("countPspec: "+$("#countPspec").text() +"\r\n"
				//		+"totalPspecCount: "+$("#totalPspecCount").text());
					
					
					// 더보기 버튼을 눌렀을 때 countPspec의 값과 totalPspecCount값이 일치하는 경우
					// 더보기 버튼을 '처음으로'로 변경하고 countPspec에는 0으로 초기화 
					if($("#totalPspecCount").text() == $("#countPspec").text()){
						$("#btnMoreHIT").text("처음으로 △");
						$("#countPspec").text("0");
					}
					
				}
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function
	
	
// #JSON으로 NEW 상품 가져오기
	var lenNEW = 8;	// 더보기 클릭에 보여줄 페이지 갯수
	
//	#디스플레이할 NEW pspec 제품 정보 추가 요청하는 함수 
	function displayNEWAppend(start){
		var form_data = {"start":start,
						 "len":lenNEW,
						 "pspec":"NEW"};
		
		$.ajax({
			url:"malldisplayJSON.do",
			type:"GET",
			data: form_data,
			dataType:"JSON",
			success:function(json){
				
				var html = "";
				
				if(json.length == 0){ // 데이터가 없는 경우
					html += "현재 상품 준비중....";
							
					$("#displayNEWResult").html(html);
					
					// 더보기 버튼 비활성화
					$("#btnMoreNEW").attr("disabled", true);
					$("#btnMoreNEW").css("cursor", "not-allowed");
					
				}
				else{
					$.each(json, function(entryIndex, entry){ // entry.key값
			        	  html += "<div style=\"display: inline-block; margin: 30px; border: solid gray 0px;\" align=\"left\">" 
			        	        + "  <a href=\"/MyMVC/prodView.do?pnum="+entry.pnum+"\">"
			        	        + "    <img width=\"120px;\" height=\"130px;\" src=\"images/"+entry.pimage1+"\">"
			        	        + "  </a><br/>"
			        	        + "제품명 : "+entry.pname+"<br/>"
			        	        // 숫자.toLocaleString('en'); 3자리마다 콤마를 부여하여 문자열 타입으로 return
			        	        + "정가 : <span style=\"color: red; text-decoration: line-through;\">"+(entry.price).toLocaleString('en')+" 원</span><br/>"
			        	        + "판매가 : <span style=\"color: red; font-weight: bold;\">"+(entry.saleprice).toLocaleString('en')+" 원</span><br/>"
			        	        + "할인율 : <span style=\"color: blue; font-weight: bold;\">["+entry.percent+"%] 할인</span><br/>"
			        	        + "포인트 : <span style=\"color: orange;\">"+entry.point+" POINT</span><br/>"
			        	        + "</div>";
			        	  
			              } ); // end of $.each()---------------------------
			          
			         html += "<div style=\"clear: both;\">&nbsp;</div>";
					
					$("#displayNEWResult").append(html);
					
					// 더보기 버튼의 value에 페이지번호 주기(다음 페이지의 첫번째 물품번호; 1페이지의 끝 8번 -> 2페이지의 시작 9번)
					$("#btnMoreNEW").val(parseInt(start)+lenNEW);
					
					// 웹브라우저 상에 count를 출력; 현재 페이지의 물품갯수+다음페이지 물품갯수를 countNEW에 누적
					$("#countNEW").text(parseInt($("#countNEW").text())+json.length);
					
					// 더보기 버튼을 눌렀을 때 countNEW의 값과 totalNEWCount값이 일치하는 경우
					// 더보기 버튼을 '처음으로'로 변경하고 countNEW에는 0으로 초기화 
					if($("#totalNEWCount").text() == $("#countNEW").text()){
						$("#btnMoreNEW").text("처음으로 △");
						$("#countNEW").text("0");
					}
					
				}
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of ajax
	} // end of function	

</script>
    
<h2>::: 쇼핑몰 상품 :::</h2>    
<br/>

<!-- HIT 상품 디스플레이 하기 -->
<table style="width: 90%; border: 0px solid gray; margin-bottom: 30px;" >
<thead>
	<tr>
		<th colspan="4" class="th" style="font-size: 12pt; background-color: #e1e1d0; height: 30px; text-align:center;">- HIT 상품 -</th>
	</tr>
	<tr>
		<th colspan="4" class="th">&nbsp;</th>
	</tr>
</thead>
<tbody id="displayResult">

</tbody>
</table>
<div style="margin-top: 20px; margin-bottom: 20px;">
	<button type="button" class="btn btn-default" id="btnMoreHIT" value="">더보기 ▽</button>
	<span id="countPspec">0</span><%-- 더보기 버튼을 클릭할 때마다 물품 몇개를 가져오는지 누적 --%>
	<span id="totalPspecCount">${totalPspecCount}</span>
	
</div>

<!-- NEW 제품 디스플레이(div 태그를 사용한것) -->
<div style="width: 90%; margin-top:50px; margin-bottom: 30px;">
	<div style="text-align: center; 
	            font-size: 14pt;
	            font-weight: bold;
	            background-color: #e1e1d0;
	            height: 30px;
	            margin-bottom: 15px;" >
	   <span style="vertical-align: middle;">- NEW 상품(DIV) -</span>
	 </div>

	 
	 <div id="displayNEWResult" style="width: 80%;margin: auto; border: solid 0px red;"></div>
	 <div style="width: 30%; margin-top: 20px; margin-bottom: 20px;">
		<button type="button" id="btnMoreNEW" class="btn btn-default" value=""> 더보기 ▽</button>
		<span id="countNEW">0</span>
		<span id="totalNEWCount">${totalNEWCount}</span>
		
	 </div>
	
</div>

<jsp:include page="../footer.jsp" />