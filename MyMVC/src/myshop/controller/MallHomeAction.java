package myshop.controller;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import my.util.MyUtil;
import myshop.model.*;


public class MallHomeAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
		throws Exception {
//		#부모클래스에 선언되어있는 카테고리목록 메소드를 가져와서 로그인폼 밑에 출력
		super.getCategoryList(req);
		String goBackURL = MyUtil.getCurrentURL(req);
		HttpSession session = req.getSession();
		session.setAttribute("returnPage", goBackURL);
		
		ProductDAO pdao = new ProductDAO();
		String pspec = "HIT";
//		#pspec 컬럼의 값에 따라 select
//		#HIT 상품 가져오기 (더보기 버튼)
//		1) 페이징 처리 하지 않은 것; Ajax 처리하기 이전
		List<ProductVO> hitList = pdao.selectByPspec(pspec);
		
		req.setAttribute("hitList", hitList);
		
//		2) 페이징 처리 한 것; Ajax를 사용하여 '더보기'방식으로 페이징 처리; XML
		int totalPspecCount = pdao.totalPspecCount(pspec);
		
		req.setAttribute("totalPspecCount", totalPspecCount);
		
		
//		super.setRedirect(false);
//		super.setViewPage("/WEB-INF/myshop/mallHome.jsp");
		
		
//		#NEW 상품 가져오기; JSON
		pspec = "NEW";
		int totalNEWCount = pdao.totalPspecCount(pspec);
		
		req.setAttribute("totalNEWCount", totalNEWCount);
		
		
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/mallHomeAjax.jsp");
	} // end of excute()
} // end of class
