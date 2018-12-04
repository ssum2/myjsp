package myshop.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;
import myshop.model.ProductVO;

public class MalldisplayXMLAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
		String start = req.getParameter("start");	// 페이지의 번호; ex) 1page -> 1~8번 상품 / 2page -> 9~17번 상품
		String len = req.getParameter("len"); // 8개씩 자름; sizePerPage; 한 페이지당 보여줄 상품의 개수
		String pspec = req.getParameter("pspec");

		if(start == null || start.trim().isEmpty()) {
			start = "1";
		}
		if(len==null || len.trim().isEmpty()) {
			len ="8";
		}
		if(pspec==null || pspec.trim().isEmpty()) {
			pspec="HIT";
		}
		
//		#페이징 처리된 상품리스트를 불러오는 공식
		int startRno = Integer.parseInt(start);
//		>> startRno 시작행 번호: 1
		int endRno = startRno+Integer.parseInt(len)-1; 
//		>> endRno 끝행 번호: 시작번호+한페이징 보여줄 상품개수 -1 = 8	
		
		InterProductDAO pdao = new ProductDAO();
		
		List<ProductVO> productList = pdao.getProductsByPspec(pspec, startRno, endRno);
		
		req.setAttribute("productList", productList);

		super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/malldisplayXML.jsp");
	}

}
